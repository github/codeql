#!/bin/bash -e

URL=https://github.com/github/codeql-cli-binaries/releases
LATEST_VERSION=$(curl -L -s -H 'Accept: application/json' $URL/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
CURRENT_VERSION=v$(codeql version 2>/dev/null | sed -ne 's/.*release \([0-9.]*\)\./\1/p')
if [[ $CURRENT_VERSION != $LATEST_VERSION ]]; then
  curl -fSqL -o /tmp/codeql.zip $URL/download/$LATEST_VERSION/codeql-linux64.zip
  unzip /tmp/codeql.zip -qd /opt
  rm /tmp/codeql.zip
  ln -sf /opt/codeql/codeql /usr/local/bin/codeql
  echo installed version $LATEST_VERSION
else
  echo current version $CURRENT_VERSION is up-to-date
fi
