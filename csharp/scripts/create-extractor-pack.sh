#!/bin/bash
set -eux

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  platform="linux64"
  dotnet_platform="linux-x64"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  platform="osx64"
  if [[ $(uname -m) == 'arm64' ]]; then
    dotnet_platform="osx-arm64"
  else
    dotnet_platform="osx-x64"
  fi
else
  echo "Unknown OS"
  exit 1
fi

rm -rf extractor-pack
mkdir -p extractor-pack
mkdir -p extractor-pack/tools/${platform}

function dotnet_publish {
  dotnet publish --self-contained --configuration Release --runtime ${dotnet_platform} -p:RuntimeFrameworkVersion=9.0.0 $1 --output extractor-pack/tools/${platform}
}

dotnet tool restore
dotnet_publish extractor/Semmle.Extraction.CSharp.Standalone
dotnet_publish extractor/Semmle.Extraction.CSharp.Driver
dotnet_publish autobuilder/Semmle.Autobuild.CSharp

cp -r codeql-extractor.yml tools/* downgrades tools ql/lib/semmlecode.csharp.dbscheme ql/lib/semmlecode.csharp.dbscheme.stats extractor-pack/
