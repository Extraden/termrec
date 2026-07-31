#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

export TERMREC_HOME="$tmp_dir/state"

"$repo_dir/bin/termrec" doctor
"$repo_dir/bin/termrec" start --name smoke -- bash -c 'printf "termrec-smoke-test\n"'

session_dir=$("$repo_dir/bin/termrec" path latest)

[[ -f "$session_dir/input.log" ]]
[[ -f "$session_dir/output.log" ]]
[[ -f "$session_dir/timing.log" ]]
[[ -f "$session_dir/meta.txt" ]]
grep -a -q 'termrec-smoke-test' "$session_dir/output.log"
grep -q 'exit_status=0' "$session_dir/meta.txt"

archive=$({ "$repo_dir/bin/termrec" pack latest; } | head -n 1)
[[ -f "$archive" ]]

printf 'Smoke test passed.\n'
