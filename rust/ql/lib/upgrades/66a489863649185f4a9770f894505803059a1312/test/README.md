# Rust upgrade preservation test

This directory contains a manual regression test for the Rust dbscheme upgrade from rust-analyzer 0.0.301 to 0.0.328.

It is **not yet checked by CI**. The test has to be run manually because it requires building an old extractor to create an old-schema database first.

## Directory structure

- `old/`: Test query for the **old** schema, showing fields that will be upgraded
- `new/`: Test query and sources for the **new** schema after upgrade

## Running the test

From anywhere in the repository:

```bash
rust/ql/lib/upgrades/66a489863649185f4a9770f894505803059a1312/test/run-test.sh
```

Or override the old commit if needed:

```bash
OLD_COMMIT=<commit> rust/ql/lib/upgrades/.../test/run-test.sh
```

The script will:
1. Copy test files to a temp directory
2. Stash uncommitted changes and checkout the old commit
3. Build the old extractor with `bazel run //rust:install`
4. Create an old-schema database with `codeql test run`
5. Restore your branch and pop the stash
6. Upgrade the database to the new schema
7. Run the preservation test on the upgraded database

If the expected output needs to be refreshed after an intentional query change, manually run the final `codeql test run` with `--learn`.
