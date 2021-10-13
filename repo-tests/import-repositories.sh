#!/bin/bash

set -e
set -x

# commits relevant files from the selected repositories and stores the used commit sha in $repo.txt
repos="codeql-ruby codeql codeql-go"
for repo in $repos; do
    echo "importing $repo"
    rm -rf "$repo";
    git clone --depth 1 git@github.com:github/"$repo".git;
    git -C "$repo" rev-parse HEAD > "$repo.txt";
    # remove upgrades and tests (heuristic)
    find "$repo" -depth -type d \( -path "*/upgrades" -o -path "*/ql/test" \) -exec rm -rf {} \; ;
    # only preserve files mentioned in tools/autobuild.sh
    find "$repo" -type f -not \( -name "*.qll" -o -name "*.ql" -o -name "*.dbscheme" -o -name qlpack.yml \) -exec rm -f {} \; ;
    # remove empty directories (git does not care though)
    find "$repo" -type d -empty -delete;
    git add "$repo" "$repo.txt";
    git commit -m "Add $repo sources ($(tr -d '\n' < $repo.txt))";
    echo "done"
done
