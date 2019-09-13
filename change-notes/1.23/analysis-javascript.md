# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [firebase](https://www.npmjs.com/package/firebase)
  - [mongodb](https://www.npmjs.com/package/mongodb)
  - [mongoose](https://www.npmjs.com/package/mongoose)

* The call graph has been improved to resolve method calls in more cases. This may produce more security alerts.

## New queries

| **Query**                                                                 | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Unused index variable (`js/unused-index-variable`)                        | correctness                                                       | Highlights loops that iterate over an array, but do not use the index variable to access array elements, indicating a possible typo or logic error. Results are shown on LGTM by default. |
| Tainted .length in loop condition (`js/loop-bound-injection`)             | security                                                          | Highlights loops where a user-controlled object with an arbitrary .length value can trick the server to loop indefinitely. Results are not shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Incomplete string escaping or encoding (`js/incomplete-sanitization`) | Fewer false-positive results | This rule now recognizes additional ways delimiters can be stripped away. |
| Client-side cross-site scripting (`js/xss`) | More results | More potential vulnerabilities involving functions that manipulate DOM attributes are now recognized. |
| Code injection (`js/code-injection`) | More results | More potential vulnerabilities involving functions that manipulate DOM event handler attributes are now recognized. |
| Prototype pollution (`js/prototype-pollution`) | More results | The query now highlights vulnerable uses of jQuery and Angular, and the results are shown on LGTM by default. |
| Incorrect suffix check (`js/incorrect-suffix-check`) | Fewer false-positive results | The query recognizes valid checks in more cases. |

## Changes to QL libraries

* `Expr.getDocumentation()` now handles chain assignments.
