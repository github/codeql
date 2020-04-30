# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [jGrowl](https://github.com/stanlemon/jGrowl)
  - [jQuery](https://jquery.com/)

## New queries

| **Query**                                                                       | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cross-site scripting through DOM (`js/xss-through-dom`) | security, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights potential XSS vulnerabilities where existing text from the DOM is used as HTML. Results are not shown on LGTM by default. |
| Incomplete HTML attribute sanitization (`js/incomplete-html-attribute-sanitization`) | security, external/cwe/cwe-20, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights potential XSS vulnerabilities due to incomplete sanitization of HTML meta-characters. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Misspelled variable name (`js/misspelled-variable-name`) | Message changed | The message for this query now correctly identifies the misspelled variable in additional cases. |
| Uncontrolled data used in path expression (`js/path-injection`) | More results | This query now recognizes additional file system calls. |
| Uncontrolled command line (`js/command-line-injection`) | More results | This query now recognizes additional command execution calls. |

## Changes to libraries

* Added data flow for `Map` and `Set`, and added matching type-tracking steps that can accessed using the `CollectionsTypeTracking` module.
