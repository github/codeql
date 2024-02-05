#!/bin/bash
rm -rf ql/src/test-db || true
rm -rf ql/lib/test-db || true
codeql database create ql/src/test-db -l yaml -s ql/src/test
codeql database create ql/lib/test-db -l yaml -s ql/lib/test
