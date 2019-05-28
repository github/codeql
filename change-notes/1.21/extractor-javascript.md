[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

## Changes to code extraction

* ECMAScript 2019 support is now enabled by default.
* On LGTM, JavaScript extraction for projects that do not contain any JavaScript or TypeScript code will now fail, even if the project contains other file types (such as HTML or YAML) recognized by the JavaScript extractor.
* YAML files are now extracted by default on LGTM. You can specify exclusion filters in your `lgtm.yml` file to override this behavior.
