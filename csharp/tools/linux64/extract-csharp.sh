#!/bin/bash
echo extract-csharp.sh: Called with arguments: "$@"

extractor="$CODEQL_EXTRACTOR_CSHARP_ROOT/tools/$CODEQL_PLATFORM/Semmle.Extraction.CSharp.Driver"

for i in "$@"
do
  shift
  if [[ `basename -- "$i"` =~ csc.exe|mcs.exe|csc.dll ]]
  then
    echo extract-csharp.sh: exec $extractor --cil $@
    exec "$extractor" --compiler $i --cil $@
  fi
done

echo extract-csharp.sh: Not a compiler invocation
