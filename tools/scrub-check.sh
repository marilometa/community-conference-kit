#!/usr/bin/env bash
# Blocks a commit if any term from .scrub-denylist.txt appears in the repository.
# The denylist is git-ignored: one term per line, matched as a whole word, case-insensitive.
# Lines starting with # are comments. List plurals and variants separately.
set -euo pipefail
cd "$(dirname "$0")/.."
LIST=".scrub-denylist.txt"
if [[ ! -f "$LIST" ]]; then echo "FAIL: $LIST not found. Create it before committing." >&2; exit 1; fi
hits=0
while IFS= read -r term || [[ -n "$term" ]]; do
  [[ -z "$term" || "$term" == \#* ]] && continue
  if grep -RIl -i -w -F --exclude-dir=.git --exclude="$LIST" -- "$term" . >/dev/null 2>&1; then
    echo "DENYLIST HIT: '$term'"; grep -RIl -i -w -F --exclude-dir=.git --exclude="$LIST" -- "$term" . | sed 's/^/  in /'; hits=1
  fi
done < "$LIST"
if [[ $hits -eq 1 ]]; then echo "FAIL: denylisted terms found. Do not commit."; exit 1; fi
echo "PASS: no denylisted terms."
