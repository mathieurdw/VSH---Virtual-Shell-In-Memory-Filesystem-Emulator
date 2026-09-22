#!/usr/bin/env bash

vsh_extract() {
  local archive="$1"
  local file="$ARCHIVES/$archive"

  [[ -z "$archive" ]] && { echo "extract: archive manquante" >&2; return 1; }
  [[ ! -f "$file" ]] && { echo "extract: archive introuvable: $file" >&2; return 1; }

  local extract_dir="${archive}_extract"
  mkdir -p "$extract_dir" || { echo "extract: impossible de créer $extract_dir" >&2; return 1; }

  local first_line body_start
  read -r first_line < "$file" || { echo "extract: archive vide" >&2; return 1; }
  body_start="${first_line#*:}"

  # Convertit "\A\B" -> "<extract_dir>/A/B"
  vsh_dir_to_fs() {
    local v="$1"
    v="${v#\\}"
    v="${v//\\//}"
    [[ -z "$v" ]] && echo "$extract_dir" || echo "$extract_dir/$v"
  }

  local cur_vsh="\\"
  local cur_fs="$extract_dir"

  local lineno=1 line
  while IFS= read -r line; do
    lineno=$((lineno + 1))
    (( lineno >= body_start )) && break

    [[ -z "$line" ]] && continue
    [[ "$line" == "@" ]] && continue

    if [[ "$line" == directory* ]]; then
      set -- $line
      cur_vsh="$2"
      [[ -z "$cur_vsh" ]] && cur_vsh="\\"
      cur_fs="$(vsh_dir_to_fs "$cur_vsh")"
      mkdir -p "$cur_fs"
      continue
    fi

    set -- $line
    local name="$1" perm="$2" size="$3" start="$4" nlines="$5"
    local dest="$cur_fs/$name"

    # si c'est un répertoire
    if [[ "${perm:0:1}" == "d" ]]; then
      mkdir -p "$dest"
      chmod "$(perm_to_octal "$perm")" "$dest" 2>/dev/null
      continue
    fi

    mkdir -p "$cur_fs"

    # fichier vide
    if [[ "$size" =~ ^[0-9]+$ ]] && (( size == 0 )); then
      : > "$dest"
      chmod "$(perm_to_octal "$perm")" "$dest" 2>/dev/null
      continue
    fi

    # fichier non vide
    if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$nlines" =~ ^[0-9]+$ ]] && (( nlines > 0 )); then
      local abs_start=$((body_start + start - 1))
      local abs_end=$((abs_start + nlines - 1))
      sed -n "${abs_start},${abs_end}p" "$file" > "$dest"
      chmod "$(perm_to_octal "$perm")" "$dest" 2>/dev/null
    else
      : > "$dest"
      chmod "$(perm_to_octal "$perm")" "$dest" 2>/dev/null
    fi
  done < "$file"

  return 0
}