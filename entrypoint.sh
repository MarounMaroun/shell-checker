#!/bin/bash

GITHUB_API_URI="https://api.github.com"
GITHUB_API_HEADER="Accept: application/vnd.github.v3+json"

token="$1"
severity="$2"
exclude="$3"

echo "---= Excluded params: [$exclude] =---"
echo "---= Severity: $severity =---"

pr_num=$(jq -r .pull_request.number "$GITHUB_EVENT_PATH")
echo "---= Running on PR #$pr_num =---"
body=$(curl -sSL -H "Authorization: token $token" -H "$GITHUB_API_HEADER" "$GITHUB_API_URI/repos/$GITHUB_REPOSITORY/pulls/$pr_num/files")

err=0
for file in $(echo "$body" | jq -r 'map(select(.status != "removed")) | .[].filename'); do
  extension=$(echo "$file" | awk -F . '{print $NF}')
  if [[ "$extension" =~ (sh|bash|zsh|ksh) ]]; then
    shellcheck -e "$exclude" -S "$severity" "$GITHUB_WORKSPACE/$file" || err=$?
  fi
done

exit $err
