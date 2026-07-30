#!/bin/bash
# Regenerate the extractor corpus: rerun the corpus tests with update mode on,
# so each `.output` file is rewritten from what the extractor currently
# produces.
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")/.."

# A sandboxed test cannot touch the source tree. `--strategy=TestRunner=local`
# drops the sandbox, and the corpus files in the runfiles tree are symlinks back
# to the real ones, so update mode writes through them. Setting this here rather
# than tagging the target keeps the ordinary test run sandboxed.
#
# `--nocache_test_results` because a cached PASS would skip the run, and the
# side effect is the point.
exec bazel test \
    --strategy=TestRunner=local \
    --test_env=UNIFIED_UPDATE_CORPUS=1 \
    --nocache_test_results \
    //unified/extractor:corpus_tests \
    "$@"
