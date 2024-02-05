#!/bin/bash
rm -rf ql/src/test/test.testproj || true
rm -rf ql/lib/test/test.testproj || true
codeql database create ql/src/test/test.testproj -l yaml -s ql/src/test
codeql database create ql/lib/test/test.testproj -l yaml -s ql/lib/test
