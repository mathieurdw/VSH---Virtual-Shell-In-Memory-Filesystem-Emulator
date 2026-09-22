#!/usr/bin/env bash

vsh_save_archive() {
  local archive="$1"
  local file="$ARCHIVES/$archive"

  mkdir -p "$ARCHIVES" || return 1

  local -a header=()
  local -a body=()
  local body_line=1

  _write_dir_block_vsh() {
    local dir="$1"

    header+=("directory $dir")

    # liste des entrées (enfants immédiats)
    local kids="${CHILDREN[$dir]}"
    local k child perm size content nlines bytes

    for k in $kids; do
      [[ "$dir" == "\\" ]] && child="\\$k" || child="$dir\\$k"

      perm="${PERM[$child]}"
      [[ -z "$perm" ]] && perm="drwxr-xr-x"

      if [[ "${TYPE[$child]}" == "dir" ]]; then
        size=$(_compute_dir_size_vsh "$child")
        SIZE["$child"]="$size"
        header+=("$k $perm $size")
      else
        content="${CONTENT[$child]}"
        bytes=$(printf "%s" "$content" | wc -c); bytes=${bytes// /}
        SIZE["$child"]="$bytes"

        if [[ -z "$content" ]]; then
          header+=("$k $perm 0")
        else
          nlines=$(printf "%s\n" "$content" | awk 'END{print NR}'); nlines=${nlines// /}
          header+=("$k $perm $bytes $body_line $nlines")

          while IFS= read -r line || [[ -n "$line" ]]; do
            body+=("$line")
          done < <(printf "%s\n" "$content")

          body_line=$((body_line + nlines))
        fi
      fi
    done

    header+=("@")

    # récursion
    for k in $kids; do
      [[ "$dir" == "\\" ]] && child="\\$k" || child="$dir\\$k"
      [[ "${TYPE[$child]}" == "dir" ]] && _write_dir_block_vsh "$child"
    done
  }

  # racine
  ensure_children_key "\\"
  _write_dir_block_vsh "\\"

  local body_start=$((2 + ${#header[@]}))

  {
    echo "2:$body_start"
    printf "%s\n" "${header[@]}"
    printf "%s\n" "${body[@]}"
  } > "$file"
}