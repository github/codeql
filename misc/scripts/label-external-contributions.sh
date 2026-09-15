#!/usr/bin/env bash

set -euo pipefail

repository="github/codeql"
label="external-contribution"

for command in gh jq fzf; do
  if ! command -v "$command" >/dev/null; then
    echo "Required command not found: $command" >&2
    exit 1
  fi
done

if ! gh auth status >/dev/null 2>&1; then
  echo "Authenticate with GitHub CLI before running this script." >&2
  exit 1
fi

if [[ ! -r /dev/tty || ! -w /dev/tty ]]; then
  echo "This script requires an interactive terminal." >&2
  exit 1
fi

pulls="$(
  gh api --method GET --paginate "repos/$repository/pulls" \
    -f state=open \
    -f sort=created \
    -f direction=desc \
    -f per_page=100
)"

rows=""
while IFS=$'\t' read -r number created author status title; do
  if [[ "$status" == "unlabelled" ]]; then
    events="$(
      gh api --method GET --paginate \
      "repos/$repository/issues/$number/events" \
        -f per_page=100
    )"
    if jq -s -e --arg label "$label" \
      'any(.[][]; .event == "unlabeled" and .label.name == $label)' \
      >/dev/null <<<"$events"; then
      status="removed"
    fi
  fi

  rows+="$number"$'\t'"$created"$'\t'"$author"$'\t'"$status"$'\t'"$title"$'\n'
done < <(
  jq -r --arg label "$label" '
    .[]
    | select(
        .draft == false
        and .user.type == "User"
        and .author_association != "MEMBER"
        and .author_association != "OWNER"
      )
    | [
        (.number | tostring),
        .created_at[0:10],
        .user.login,
        (if any(.labels[]?; .name == $label)
         then "labelled"
         else "unlabelled"
         end),
        (.title
         | gsub("[\u0000-\u001f\u007f\u202a-\u202e\u2066-\u2069]"; " "))
      ]
    | @tsv
  ' <<<"$pulls"
)

if [[ -z "$rows" ]]; then
  echo "No external contributions found."
  exit 0
fi

set +e
selection="$(
  printf '%s' "$rows" |
    fzf --multi \
      --no-mouse \
      --delimiter=$'\t' \
      --with-nth=2,3,4,5 \
      --header="Select unlabelled PRs with TAB, then press ENTER" \
      --prompt="External contributions> "
)"
fzf_status=$?
set -e

case "$fzf_status" in
  0) ;;
  1 | 130)
    echo "No pull requests selected."
    exit 0
    ;;
  *)
    echo "fzf failed with exit code $fzf_status." >&2
    exit "$fzf_status"
    ;;
esac

selected_numbers="$(
  awk -F $'\t' '$4 == "unlabelled" { print $1 }' <<<"$selection"
)"
if [[ -z "$selected_numbers" ]]; then
  echo "No unlabelled pull requests selected."
  exit 0
fi

selected_count="$(wc -l <<<"$selected_numbers")"
printf 'Apply label "%s" to %s pull request(s)? [y/N] ' \
  "$label" "$selected_count" >/dev/tty
read -r confirmation </dev/tty
if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
  echo "No labels applied."
  exit 0
fi

while IFS= read -r number; do
  if [[ ! "$number" =~ ^[1-9][0-9]*$ ]]; then
    echo "Invalid pull request number: $number" >&2
    exit 1
  fi

  gh pr edit "$number" --repo "$repository" --add-label "$label"
done <<<"$selected_numbers"
