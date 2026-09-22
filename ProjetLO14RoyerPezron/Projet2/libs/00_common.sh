#!/usr/bin/env bash

: "${ARCHIVES:=./archives}"

declare -A TYPE      # "dir" ou "file"
declare -A CHILDREN  # liste: "a b c "
declare -A CONTENT   # contenu texte
declare -A PERM      # "-rw-r--r--" / "drwxr-xr-x"
declare -A SIZE      # taille en octets (fichier: bytes contenu, dossier: bytes récursifs)

CURRENT="\\"

ensure_children_key() {
  local k="$1"
  [[ -z "${CHILDREN[$k]+x}" ]] && CHILDREN["$k"]=""
}

remove_child_from_parent() {
  local parent="$1"
  local name="$2"
  ensure_children_key "$parent"
  CHILDREN["$parent"]="${CHILDREN[$parent]/$name /}"
}