[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

## Changes to code extraction

* Asynchronous generator methods are now parsed correctly and no longer cause a spurious syntax error.
* Recognition of CommonJS modules has improved. As a result, some files that were previously extracted as
  global scripts are now extracted as modules.
* Top-level `await` is now supported.
