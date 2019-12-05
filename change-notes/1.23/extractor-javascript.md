[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

## Changes to code extraction

* Asynchronous generator methods are now parsed correctly and no longer cause a spurious syntax error.
* Files in `node_modules` and `bower_components` folders are no longer extracted by default. If you still want to extract files from these folders, you can add the following filters to your `lgtm.yml` file (or add them to existing filters):

  ```yaml
  extraction:
    javascript:
      index:
        filters:
          - include: "**/node_modules"
          - include: "**/bower_components"
  ```

* Additional [Flow](https://flow.org/) syntax is now supported.
* Recognition of CommonJS modules has improved. As a result, some files that were previously extracted as
  global scripts are now extracted as modules.
* Top-level `await` is now supported.
* Bugs were fixed in how the TypeScript extractor handles default-exported anonymous classes and computed-instance field names.
