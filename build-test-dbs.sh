#!/bin/bash
rm -rf src-test.testproj || true
rm -rf lib-test.testproj || true
codeql database create src-test.testproj -l yaml -s ql/src/test
codeql database create lib-test.testproj -l yaml -s ql/lib/test
