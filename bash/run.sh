#!/usr/bin/env bash

set -e
shopt -s extglob

################################################################################
# Parse arguments
################################################################################

mode=1

function print_help {
  cat <<-EOF
  usage: $0 [argument [argument ...]]

  Script to do something.

  optional arguments:
    -h, --help            Show this help message and exit.
    -t, --test            Run in debug mode.
EOF
}

# https://gist.github.com/jehiah/855086
while [[ ${1:0:1} == - ]]; do
  [[ $1 =~ ^-h|--help ]] && { print_help; return; };
  [[ $1 == -- ]] && { shift; break; };
  [[ $1 =~ ^-m|--mount$ ]] && { mode=1; shift 1; continue; };
  [[ $1 =~ ^-u|--umount$ ]] && { mode=2; shift 1; continue; };
  [[ $1 =~ ^-t|--test$ ]] && { is_debug=1; shift 1; continue; };
  break;
done

################################################################################
# Main
################################################################################

function log {
  (>&2 echo "$@")
}

check=1
function run {
  local cmd="$@"
  log
  log "#################################"
  log $cmd
  log "#################################"
  if [[ $is_debug -ne 1 ]]; then
    eval $cmd
    if [ $check -ne 0 -a $? -ne 0 ]; then
      log "Command failed!"
      exit 1
    fi
  fi
}

run "ls /"
