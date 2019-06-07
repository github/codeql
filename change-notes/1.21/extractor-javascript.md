[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

## Changes to code extraction

* Custom file types can now be specified using the `filetypes` property in the `extraction/javascript/index` section of `lgtm.yml`. The property should be a map from file extensions (including the dot) to file types. Valid file types are `html`, `js`, `json`, `typescript`, `xml` and `yaml`.

* ECMAScript 2019 support is now enabled by default.

* On LGTM, JavaScript extraction for projects that do not contain any JavaScript or TypeScript code will now fail, even if the project contains other file types (such as HTML or YAML) recognized by the JavaScript extractor.

* XML files can now be extracted on LGTM. To enable XML extraction, set the `xml_mode` property in the `extraction/javascript/index` section of your `lgtm.yml` file to `all`. The default value of this property is `disabled`, meaning that XML files will not be extracted. (Note, that the `xml_mode` property does not apply to files that you map to the `xml` file type using the `filetypes` property. LGTM will always extract these files.)

* YAML files are now extracted by default on LGTM. If required, you can specify exclusion filters in your `lgtm.yml` file to override this behavior.

For detailed information about customizing LGTM extraction, see [JavaScript extraction](https://help.semmle.com/lgtm-enterprise/user/help/javascript-extraction.html).