# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
  - [bluebird](http://bluebirdjs.com/)
  - [express](https://www.npmjs.com/package/express)
  - [fastify](https://www.npmjs.com/package/fastify)
  - [fstream](https://www.npmjs.com/package/fstream)
  - [jGrowl](https://github.com/stanlemon/jGrowl)
  - [jQuery](https://jquery.com/)
  - [marsdb](https://www.npmjs.com/package/marsdb)
  - [minimongo](https://www.npmjs.com/package/minimongo/)
  - [mssql](https://www.npmjs.com/package/mssql)
  - [mysql](https://www.npmjs.com/package/mysql)
  - [pg](https://www.npmjs.com/package/pg)
  - [sequelize](https://www.npmjs.com/package/sequelize)
  - [spanner](https://www.npmjs.com/package/spanner)
  - [sqlite](https://www.npmjs.com/package/sqlite)
  - [ssh2-streams](https://www.npmjs.com/package/ssh2-streams)
  - [ssh2](https://www.npmjs.com/package/ssh2)

* TypeScript 3.9 is now supported.

## New queries

| **Query**                                                                       | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cross-site scripting through DOM (`js/xss-through-dom`) | security, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights potential XSS vulnerabilities where existing text from the DOM is used as HTML. Results are not shown on LGTM by default. |
| Incomplete HTML attribute sanitization (`js/incomplete-html-attribute-sanitization`) | security, external/cwe/cwe-20, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights potential XSS vulnerabilities due to incomplete sanitization of HTML meta-characters. Results are shown on LGTM by default. |
| Unsafe expansion of self-closing HTML tag (`js/unsafe-html-expansion`) | security, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights potential XSS vulnerabilities caused by unsafe expansion of self-closing HTML tags. |
| Unsafe shell command constructed from library input (`js/shell-command-constructed-from-input`) | correctness, security, external/cwe/cwe-078, external/cwe/cwe-088 | Highlights potential command injections due to a shell command being constructed from library inputs. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Client-side cross-site scripting (`js/xss`) | Fewer results | This query no longer flags optionally sanitized values. |
| Client-side URL redirect (`js/client-side-unvalidated-url-redirection`) | Fewer results | This query now recognizes additional safe patterns of doing URL redirects. |
| Client-side cross-site scripting (`js/xss`) | Fewer results | This query now recognizes additional safe patterns of constructing HTML. |
| Code injection (`js/code-injection`) | More results | More potential vulnerabilities involving NoSQL code operators are now recognized. |
| Expression has no effect (`js/useless-expression`) | Fewer results | This query no longer flags an expression when that expression is the only content of the containing file. |
| Incomplete URL scheme check (`js/incomplete-url-scheme-check`) | More results | This query now recognizes additional url scheme checks. |
| Misspelled variable name (`js/misspelled-variable-name`) | Message changed | The message for this query now correctly identifies the misspelled variable in additional cases. |
| Prototype pollution in utility function (`js/prototype-pollution-utility`) | More results | This query now recognizes additional utility functions as vulnerable to prototype polution. |
| Prototype pollution in utility function (`js/prototype-pollution-utility`) | More results | This query now recognizes more coding patterns that are vulnerable to prototype pollution. |
| Uncontrolled command line (`js/command-line-injection`) | More results | This query now recognizes additional command execution calls. |
| Uncontrolled data used in path expression (`js/path-injection`) | More results | This query now recognizes additional file system calls. |
| Unknown directive (`js/unknown-directive`) | Fewer results | This query no longer flags directives generated by the Babel compiler. |
| Unused property (`js/unused-property`) | Fewer results | This query no longer flags properties of objects that are operands of `yield` expressions. |
| Zip Slip (`js/zipslip`) | More results | This query now recognizes additional vulnerabilities. |

The following low-precision queries are no longer run by default on LGTM (their results already were not displayed):

  - `js/angular/dead-event-listener`
  - `js/angular/unused-dependency`
  - `js/bitwise-sign-check`
  - `js/comparison-of-identical-expressions`
  - `js/conflicting-html-attribute`
  - `js/ignored-setter-parameter`
  - `js/jsdoc/malformed-param-tag`
  - `js/jsdoc/missing-parameter`
  - `js/jsdoc/unknown-parameter`
  - `js/json-in-javascript-file`
  - `js/misspelled-identifier`
  - `js/nested-loops-with-same-variable`
  - `js/node/cyclic-import`
  - `js/node/unused-npm-dependency`
  - `js/omitted-array-element`
  - `js/return-outside-function`
  - `js/single-run-loop`
  - `js/too-many-parameters`
  - `js/unused-property`
  - `js/useless-assignment-to-global`

## Changes to libraries

* A library `semmle.javascript.explore.CallGraph` has been added to help write queries for exploring the call graph.
* Added data flow for `Map` and `Set`, and added matching type-tracking steps that can accessed using the `CollectionsTypeTracking` module.
* The data-flow node representing a parameter or destructuring pattern is now always the `ValueNode` corresponding to that AST node. This has a few consequences:
  - `Parameter.flow()` now gets the correct data flow node for a parameter. Previously this had a result, but the node was disconnected from the data flow graph.
  - `ParameterNode.asExpr()` and `.getAstNode()` now gets the parameter's AST node, whereas previously it had no result.
  - `Expr.flow()` now has a more meaningful result for destructuring patterns. Previously this node was disconnected from the data flow graph. Now it represents the values being destructured by the pattern.
* The global data-flow and taint-tracking libraries now model indirect parameter accesses through the `arguments` object in some cases, which may lead to additional results from some of the security queries, particularly "Prototype pollution in utility function".
