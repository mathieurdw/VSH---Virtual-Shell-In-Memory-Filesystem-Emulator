#!/usr/bin/env bash

# Calcule la taille "logique" d'un dossier virtuel = somme récursive des tailles fichiers
_compute_dir_size_vsh() {
  local dir="$1"
  local total=0
  local kids="${CHILDREN[$dir]}"
  local k child s

  for k in $kids; do
    [[ "$dir" == "\\" ]] && child="\\$k" || child="$dir\\$k"

    if [[ "${TYPE[$child]}" == "file" ]]; then
      s="${SIZE[$child]}"
      if [[ -z "$s" ]]; then
        s=$(printf "%s" "${CONTENT[$child]}" | wc -c); s=${s// /}
      fi
      total=$((total + s))
    elif [[ "${TYPE[$child]}" == "dir" ]]; then
      s=$(_compute_dir_size_vsh "$child")
      total=$((total + s))
    fi
  done

  echo "$total"
}

cmd_touch() {
  local target="$1"
  [[ -z "$target" ]] && { echo "touch: nom manquant"; return; }

  local path parent name
  path="$(resolve_path "$target" "$CURRENT")"

  [[ -n "${TYPE[$path]}" ]] && { echo "touch: $target: existe déjà"; return; }

  parent="${path%\\*}"
  name="${path##*\\}"
  [[ -z "$parent" || "$parent" == "$path" ]] && parent="\\"

  [[ "${TYPE[$parent]}" != "dir" ]] && { echo "touch: $target: dossier parent inexistant"; return; }

  ensure_children_key "$parent"

  TYPE["$path"]="file"
  CONTENT["$path"]=""
  PERM["$path"]="-rw-r--r--"
  SIZE["$path"]=0

  CHILDREN["$parent"]+="$name "
}

cmd_mkdir() {
  local opt_p=false
  local target

  if [[ "$1" == "-p" ]]; then
    opt_p=true
    target="$2"
  else
    target="$1"
  fi

  [[ -z "$target" ]] && { echo "mkdir: nom manquant"; return; }

  local full_path
  full_path="$(resolve_path "$target" "$CURRENT")"

  local rel="${full_path#\\}"
  IFS='\' read -r -a parts <<< "$rel"

  local cur="\\"
  local part next

  for part in "${parts[@]}"; do
    [[ -z "$part" ]] && continue

    if [[ "$cur" == "\\" ]]; then
      next="\\$part"
    else
      next="$cur\\$part"
    fi

    if [[ -n "${TYPE[$next]}" ]]; then
      [[ "${TYPE[$next]}" != "dir" ]] && { echo "mkdir: $target: conflit avec un fichier"; return; }
    else
      if ! $opt_p && [[ "$next" != "$full_path" ]]; then
        echo "mkdir: $target: dossier parent inexistant"
        return
      fi

      TYPE["$next"]="dir"
      PERM["$next"]="drwxr-xr-x"
      SIZE["$next"]=0
      CHILDREN["$next"]=""

      ensure_children_key "$cur"
      CHILDREN["$cur"]+="$part "
    fi

    cur="$next"
  done
}

_rm_recursive() {
  local path="$1"

  if [[ "${TYPE[$path]}" == "dir" ]]; then
    local kids="${CHILDREN[$path]}"
    local k child

    for k in $kids; do
      [[ "$path" == "\\" ]] && child="\\$k" || child="$path\\$k"
      _rm_recursive "$child"
    done

    unset CHILDREN["$path"]
  fi

  unset TYPE["$path"]
  unset CONTENT["$path"]
  unset PERM["$path"]
  unset SIZE["$path"]
}

cmd_rm() {
  local target="$1"
  [[ -z "$target" ]] && { echo "rm: nom manquant"; return; }

  local path parent name
  path="$(resolve_path "$target" "$CURRENT")"

  [[ -z "${TYPE[$path]}" ]] && { echo "rm: $target: inexistant"; return; }

  parent="${path%\\*}"
  name="${path##*\\}"
  [[ -z "$parent" || "$parent" == "$path" ]] && parent="\\"

  _rm_recursive "$path"
  remove_child_from_parent "$parent" "$name"
}