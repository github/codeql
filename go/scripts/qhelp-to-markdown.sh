#!/bin/bash

set -e

if [ $# -ne 2 ]; then
  echo "Usage: qhelp-to-markdown.sh qhelp-directory out-directory"
  exit 1
fi

for qh in $(find $1 -name "*.qhelp"); do 
  mkdir -p $2/$(dirname $qh)
  codeql generate query-help --format=markdown $qh > $2/${qh/qhelp/md}
done
