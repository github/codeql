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


## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Client-side cross-site scripting (`js/xss`) | More results | More potential vulnerabilities involving functions that manipulate DOM attributes are now recognized. |
| Code injection (`js/code-injection`) | More results | More potential vulnerabilities involving functions that manipulate DOM event handler attributes are now recognized. |
| Incorrect suffix check (`js/incorrect-suffix-check`) | Fewer false-positive results | The query recognizes valid checks in more cases. 
| Prototype pollution (`js/prototype-pollution`) | More results | The query now highlights vulnerable uses of jQuery and Angular, and the results are shown on LGTM by default. |
| Uncontrolled command line (`js/command-line-injection`) | More results | This query now treats responses from servers as untrusted. |

## Changes to QL libraries

* `Expr.getDocumentation()` now handles chain assignments.
