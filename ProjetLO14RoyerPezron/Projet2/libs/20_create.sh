#!/usr/bin/env bash

# Taille "logique" d'un dossier = somme des tailles de tous les fichiers dessous (récursif)
_dir_content_size_fs() {
  local dir="$1"
  find "$dir" -type f -printf "%s\n" 2>/dev/null | awk '{s+=$1} END{print s+0}'
}

vsh_create() {
  local name="$1"
  local root_dir="${2:-.}"

  mkdir -p "$ARCHIVES"
  local out="$ARCHIVES/$name"

  local -a header=()
  local -a body=()
  local body_line=1

  # Écrit un bloc "directory <vdir>" + liste d'entrées + "@", puis récursion
  _write_dir_block() {
    local fs_dir="$1"   # chemin sur le vrai FS
    local vdir="$2"     # chemin VSH (ex: "\" ou "\Sous")

    header+=("directory $vdir")

    # 1) sous-dossiers immédiats
    while IFS= read -r -d '' sub; do
      local dname dperm dsize
      dname=$(basename "$sub")
      dperm=$(stat -c %A "$sub")
      dsize=$(_dir_content_size_fs "$sub")
      header+=("$dname $dperm $dsize")
    done < <(find "$fs_dir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

    # 2) fichiers immédiats
    while IFS= read -r -d '' f; do
      local fname perm size
      fname=$(basename "$f")
      [[ "$fname" == ".DS_Store" ]] && continue

      perm=$(stat -c %A "$f")
      size=$(stat -c %s "$f")

      if (( size == 0 )); then
        header+=("$fname $perm 0")
      else
        local nlines
        nlines=$(awk 'END{print NR}' "$f")

        header+=("$fname $perm $size $body_line $nlines")

        # IMPORTANT: garde la dernière ligne même si pas de \n
        while IFS= read -r line || [[ -n "$line" ]]; do
          body+=("$line")
        done < "$f"

        body_line=$((body_line + nlines))
      fi
    done < <(find "$fs_dir" -mindepth 1 -maxdepth 1 -type f -print0 | sort -z)

    header+=("@")

    # 3) récursion dans les sous-dossiers
    while IFS= read -r -d '' sub; do
      local dname child_vdir
      dname=$(basename "$sub")
      if [[ "$vdir" == "\\" ]]; then
        child_vdir="\\$dname"
      else
        child_vdir="$vdir\\$dname"
      fi
      _write_dir_block "$sub" "$child_vdir"
    done < <(find "$fs_dir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
  }

  # Racine: vdir="\" ; fs_dir=root_dir
  _write_dir_block "$root_dir" "\\"

  local body_start=$((2 + ${#header[@]}))

  {
    echo "2:$body_start"
    printf "%s\n" "${header[@]}"
    printf "%s\n" "${body[@]}"
  } > "$out"
}