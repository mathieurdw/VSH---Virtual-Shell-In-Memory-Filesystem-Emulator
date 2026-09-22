#!/usr/bin/env bash

resolve_path() {
  local input="$1"
  local current="$2"

  if [[ -z "$input" ]]; then
    echo "$current"
    return
  fi

  if [[ "$input" == \\* ]]; then
    echo "$input"
    return
  fi

  if [[ "$current" == "\\" ]]; then
    echo "\\$input"
  else
    echo "$current\\$input"
  fi
}

perm_to_octal() {
  local p="$1"
  local out="" tri val

  # ignore le 1er char (d ou -)
  p="${p:1}"

  for tri in "${p:0:3}" "${p:3:3}" "${p:6:3}"; do
    val=0
    [[ "${tri:0:1}" == "r" ]] && val=$((val+4))
    [[ "${tri:1:1}" == "w" ]] && val=$((val+2))
    [[ "${tri:2:1}" == "x" ]] && val=$((val+1))
    out+="$val"
  done

  echo "$out"
}