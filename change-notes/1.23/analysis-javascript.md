# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [firebase](https://www.npmjs.com/package/firebase)

* The call graph has been improved to resolve method calls in more cases. This may produce more security alerts.

## New queries

| **Query**                                                                 | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Unused index variable (`js/unused-index-variable`)                        | correctness                                                       | Highlights loops that iterate over an array, but do not use the index variable to access array elements, indicating a possible typo or logic error. |


## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Client-side cross-site scripting (`js/xss`) | More results | More potential vulnerabilities involving functions that manipulate DOM attributes are now recognized. |
| Prototype pollution (`js/prototype-pollution`) | Same results | The results are now shown on LGTM by default. |

## Changes to QL libraries

* `Expr.getDocumentation()` now handles chain assignments.
