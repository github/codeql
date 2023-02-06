#!/bin/bash -e

URL=https://github.com/github/codeql-cli-binaries/releases
LATEST_VERSION=$(curl -L -s -H 'Accept: application/json' $URL/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
CURRENT_VERSION=v$(codeql version 2>/dev/null | sed -ne 's/.*release \([0-9.]*\)\./\1/p')
if [[ $CURRENT_VERSION != $LATEST_VERSION ]]; then
  if [[ $UID != 0 ]]; then
    echo "update required, please run this script with sudo:"
    echo "  sudo $0"
    exit 1
  fi
  ZIP=$(mktemp codeql.XXXX.zip)
  curl -fSqL -o $ZIP $URL/download/$LATEST_VERSION/codeql-linux64.zip
  unzip -q $ZIP -d /opt
  rm $ZIP
  ln -sf /opt/codeql/codeql /usr/local/bin/codeql
  echo installed version $LATEST_VERSION
else
  echo current version $CURRENT_VERSION is up-to-date
fi
