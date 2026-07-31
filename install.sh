#!/usr/bin/env bash

set -eu

prefix=${PREFIX:-"$HOME/.local"}
bind_dir="$prefix/bin"
source_file="$(cd "$(dirname "$0")" && pwd)/bin/termrec"
target="$bind_dir/termrec"

mkdir -p "$bind_dir"
install -m 755 "$source_file" "$target"

printf 'Installed termrec to %s\n' "$target"

case ":${PATH}:" in
    *":$bind_dir:"*) ;;
    *)
        printf '\n%s is not currently in PATH. Add this to ~/.zshrc:\n' "$bind_dir"
        printf 'export PATH="%s:$PATH"\n' "$bind_dir"
        ;;
esac
