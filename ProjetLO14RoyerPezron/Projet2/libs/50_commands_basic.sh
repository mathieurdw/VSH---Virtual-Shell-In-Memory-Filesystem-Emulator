#!/usr/bin/env bash

cmd_ls() {
  local opt_a=false
  local opt_l=false
  local target=""
  local arg

  # Analyse options / cible
  for arg in "$@"; do
    case "$arg" in
      -a) opt_a=true ;;
      -l) opt_l=true ;;
      -al|-la) opt_a=true; opt_l=true ;;
      *) target="$arg" ;;
    esac
  done

  local path
  path="$(resolve_path "$target" "$CURRENT")"

  if [[ "${TYPE[$path]}" != "dir" ]]; then
    echo "ls: $target: dossier inexistant"
    return
  fi

  local name child perm size suffix

  for name in ${CHILDREN[$path]}; do
    # chemin complet VSH
    if [[ "$path" == "\\" ]]; then
      child="\\$name"
    else
      child="$path\\$name"
    fi

    # suffixe selon type
    suffix=""
    if [[ "${TYPE[$child]}" == "dir" ]]; then
      suffix="\\"
    elif [[ "${TYPE[$child]}" == "file" && "${PERM[$child]}" == *x* ]]; then
      suffix="*"
    fi

    if $opt_l; then
      perm="${PERM[$child]}"
      size="${SIZE[$child]}"
      [[ -z "$perm" ]] && perm="drwxr-xr-x"
      [[ -z "$size" ]] && size=0
      printf "%s %s %s%s\n" "$perm" "$size" "$name" "$suffix"
    else
      printf "%s%s " "$name" "$suffix"
    fi
  done

  ! $opt_l && echo
}

cmd_pwd() {
  echo "$CURRENT"
}

cmd_cd() {
  local target="$1"
  [[ -z "$target" ]] && return

  # cd \ -> racine
  if [[ "$target" == "\\" ]]; then
    CURRENT="\\"
    return
  fi

  # cd .. -> remonter d'un niveau
  if [[ "$target" == ".." ]]; then
    if [[ "$CURRENT" == "\\" ]]; then
      CURRENT="\\"
    else
      CURRENT="${CURRENT%\\*}"
      [[ -z "$CURRENT" ]] && CURRENT="\\"
    fi
    return
  fi

  local path
  path="$(resolve_path "$target" "$CURRENT")"

  if [[ "${TYPE[$path]}" == "dir" ]]; then
    CURRENT="$path"
  else
    echo "cd: $target: dossier inexistant"
  fi
}

cmd_cat() {
  local target path
  local first=true

  for target in "$@"; do
    path="$(resolve_path "$target" "$CURRENT")"

    if [[ "${TYPE[$path]}" == "file" ]]; then
      if ! $first; then
        echo
      fi
      first=false
      echo "${CONTENT[$path]}"
    else
      echo "cat: $target: fichier inexistant"
    fi
  done
}