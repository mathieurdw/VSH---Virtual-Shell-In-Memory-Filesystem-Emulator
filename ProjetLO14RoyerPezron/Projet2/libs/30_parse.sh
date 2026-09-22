#!/usr/bin/env bash

parse_archive() {
  local archive="$1"
  local file="$ARCHIVES/$archive"

  TYPE=()
  CHILDREN=()
  CONTENT=()
  PERM=()
  SIZE=()
  CURRENT="\\"

  exec 3<"$file" || return 1

  read -r range <&3 || { exec 3<&-; return 1; }
  local header_start body_start
  IFS=':' read -r header_start body_start <<< "$range"

  # racine
  TYPE["\\"]="dir"
  PERM["\\"]="drwxr-xr-x"
  SIZE["\\"]=0
  CHILDREN["\\"]=""

  local cur="\\"

  for ((ln=header_start; ln<body_start; ln++)); do
    read -r line <&3 || break
    [[ -z "$line" ]] && continue

    # fin de bloc
    if [[ "$line" == "@" ]]; then
      continue
    fi

    # début de bloc
    if [[ "$line" == directory* ]]; then
      set -- $line
      local dir="$2"
      [[ -z "$dir" ]] && dir="\\"

      # Crée le dossier courant si pas déjà là
      if [[ -z "${TYPE[$dir]}" ]]; then
        TYPE["$dir"]="dir"
        PERM["$dir"]="drwxr-xr-x"
        SIZE["$dir"]=0
        CHILDREN["$dir"]=""
      fi

      cur="$dir"
      ensure_children_key "$cur"
      continue
    fi

    # entrée : name perm size [start nlines]
    set -- $line
    local name="$1"
    local perm="$2"
    local size="$3"
    local start="$4"
    local nlines="$5"

    local path
    if [[ "$cur" == "\\" ]]; then
      path="\\$name"
    else
      path="$cur\\$name"
    fi

    ensure_children_key "$cur"
    CHILDREN["$cur"]+="$name "

    # dossier
    if [[ "${perm:0:1}" == "d" ]]; then
      TYPE["$path"]="dir"
      PERM["$path"]="$perm"
      SIZE["$path"]="$size"
      ensure_children_key "$path"
      continue
    fi

    # fichier
    TYPE["$path"]="file"
    PERM["$path"]="$perm"
    SIZE["$path"]="$size"

    if [[ "$size" =~ ^[0-9]+$ ]] && [[ "$start" =~ ^[0-9]+$ ]] && [[ "$nlines" =~ ^[0-9]+$ ]] && (( size > 0 )); then
      local abs_start=$((body_start + start - 1))
      local abs_end=$((abs_start + nlines - 1))
      CONTENT["$path"]="$(sed -n "${abs_start},${abs_end}p" "$file")"
    else
      CONTENT["$path"]=""
    fi
  done

  exec 3<&-
  return 0
}