#!/bin/sh
printf '\033c\033]0;%s\a' G 1
base_path="$(dirname "$(realpath "$0")")"
"$base_path/G 1.x86_64" "$@"
