#!/usr/bin/env bash

vsh_browse() {
  local archive="$1"
  parse_archive "$archive" || { echo "browse: archive introuvable"; return 1; }

  while true; do
    printf "vsh:%s> " "$CURRENT"
    read -r cmd args

    case "$cmd" in
      ls)
        set -- $args
        cmd_ls "$@"
        ;;
      pwd)
        cmd_pwd
        ;;
      cd)
        cmd_cd "$args"
        ;;
      cat)
        set -- $args
        cmd_cat "$@"
        ;;
      touch)
        cmd_touch "$args"
        ;;
      mkdir)
        set -- $args
        cmd_mkdir "$@"
        ;;
      rm)
        cmd_rm "$args"
        ;;
      exit|quit)
        vsh_save_archive "$archive"
        break
        ;;
      *)
        echo "commande inconnue"
        ;;
    esac
  done
}