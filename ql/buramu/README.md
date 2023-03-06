Gathers up `git blame` information for all lines with `deprecated` annotations in QL files in the
codebase.

## Usage

From within the root of the `codeql` repo (having first run the `create-extractor-pack.sh` script):
```
    ./ql/target/release/buramu > deprecated.blame
```

## Output
The contents of the `deprecated.blame` file will look something like this:
```
today: 2023-02-17
file: cpp/ql/lib/semmle/code/cpp/security/TaintTrackingImpl.qll
  last_modified: 2022-11-25 124 167 173 184 188 329 358 400 415 546 553 584 593
file: go/ql/lib/semmle/go/security/FlowSources.qll
  last_modified: 2022-12-19 33
file: python/ql/src/experimental/semmle/python/Concepts.qll
  last_modified: 2022-08-18 172 202
  last_modified: 2022-03-11 94 110 129 145 177 206 225 241 258 272 289 303 454 485 529 570
```
