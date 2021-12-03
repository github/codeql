# Improvements to JavaScript analysis

## General improvements

* Support for many frameworks and libraries has been improved, in particular for:
  - [a-sync-waterfall](https://www.npmjs.com/package/a-sync-waterfall)
  - [Electron](https://electronjs.org)
  - [Express](https://npmjs.org/express)
  - [hapi](https://hapijs.com/)
  - [js-cookie](https://github.com/js-cookie/js-cookie)
  - [React](https://reactjs.org/)
  - [socket.io](http://socket.io)
  - [Vue](https://vuejs.org/)

* File classification now recognizes additional generated files, for example, files from [HTML Tidy](html-tidy.org).

* The taint tracking library now recognizes flow through persistent storage, class fields, and callbacks in certain cases. Handling of regular expressions has also been improved. This may give more results for the security queries.

* Type inference for function calls has been improved. This may give additional results for queries that rely on type inference.

* The [Closure-Library](https://github.com/google/closure-library/wiki/goog.module:-an-ES6-module-like-alternative-to-goog.provide) module system is now supported.

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Arbitrary file write during archive extraction ("Zip Slip") (`js/zipslip`) | security, external/cwe/cwe-022 | Identifies extraction routines that allow arbitrary file overwrite vulnerabilities, indicating a possible violation of [CWE-022](https://cwe.mitre.org/data/definitions/22.html). Results are shown on LGTM by default. |
| Arrow method on Vue instance (`js/vue/arrow-method-on-vue-instance`) | reliability, frameworks/vue | Highlights arrow functions that are used as methods on Vue instances. Results are shown on LGTM by default.|
| Cross-window communication with unrestricted target origin (`js/cross-window-information-leak`) | security, external/cwe/201, external/cwe/359 | Highlights code that sends potentially sensitive information to another window without restricting the receiver window's origin, indicating a possible violation of [CWE-201](https://cwe.mitre.org/data/definitions/201.html). Results are shown on LGTM by default. |
| Double escaping or unescaping (`js/double-escaping`) | correctness, security, external/cwe/cwe-116 | Highlights potential double escaping or unescaping of special characters, indicating a possible violation of [CWE-116](https://cwe.mitre.org/data/definitions/116.html). Results are shown on LGTM by default. |
| Incomplete regular expression for hostnames (`js/incomplete-hostname-regexp`) | correctness, security, external/cwe/cwe-020 |  Highlights hostname sanitizers that are likely to be incomplete, indicating a violation of [CWE-020](https://cwe.mitre.org/data/definitions/20.html). Results are shown on LGTM by default.|
| Incomplete URL substring sanitization | correctness, security, external/cwe/cwe-020 | Highlights URL sanitizers that are likely to be incomplete, indicating a violation of [CWE-020](https://cwe.mitre.org/data/definitions/20.html). Results shown on LGTM by default. |
| Incorrect suffix check (`js/incorrect-suffix-check`) | correctness, security, external/cwe/cwe-020 | Highlights error-prone suffix checks based on `indexOf`, indicating a potential violation of [CWE-20](https://cwe.mitre.org/data/definitions/20.html). Results are shown on LGTM by default. |
| Loop iteration skipped due to shifting (`js/loop-iteration-skipped-due-to-shifting`) | correctness | Highlights code that removes an element from an array while iterating over it, causing the loop to skip over some elements. Results are shown on LGTM by default. |
| Unused property (`js/unused-property`) | maintainability | Highlights properties that are unused. Results are shown on LGTM by default. |
| Useless comparison test (`js/useless-comparison-test`) | correctness | Highlights code that is unreachable due to a numeric comparison that is always true or always false. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                                  | **Expected impact**          | **Change**                                                                   |
|--------------------------------------------|------------------------------|------------------------------------------------------------------------------|
| Ambiguous HTML id attribute                | Fewer false positive results | This query now treats templates more conservatively. Its precision has been revised to 'high'. |
| Assignment to exports variable             | Fewer results                | This query no longer flags code that is also flagged by the query "Useless assignment to local variable". |
| Client-side cross-site scripting           | More true positive and fewer false positive results. | This query now recognizes WinJS functions that are vulnerable to HTML injection. It no longer flags certain safe uses of jQuery, and recognizes custom sanitizers. |
| Hard-coded credentials                     | Fewer false positive results | This query no longer flags the empty string as a hardcoded username. |
| Insecure randomness | More results | This query now flags insecure uses of `crypto.pseudoRandomBytes`. |
| Reflected cross-site scripting             | Fewer false positive results. | This query now recognizes custom sanitizers. |
| Stored cross-site scripting                | Fewer false positive results. | This query now recognizes custom sanitizers. |
| Unbound event handler receiver (`js/unbound-event-handler-receiver`) | Fewer false positive results | Additional ways that class methods can be bound are now recognized. |
| Uncontrolled data used in network request  | More results                 | This query now recognizes host values that are vulnerable to injection. |
| Uncontrolled data used in path expression | Fewer false positive results | This query now recognizes the Express `root` option, which prevents path traversal. |
| Unneeded defensive code | More true positive and fewer false positive results | This query now recognizes additional defensive code patterns. |
| Unsafe dynamic method access              | Fewer false positive results | This query no longer flags concatenated strings as unsafe method names. |
| Unused parameter                           | Fewer false positive results | This query no longer flags parameters with leading underscore. |
| Unused variable, import, function or class | Fewer false positive results | This query now flags fewer variables that are implictly used by JSX elements. It no longer flags variables with a leading underscore and variables in dead code. |
| Unvalidated dynamic method call           | More true positive results | This query now flags concatenated strings as unvalidated method names in more cases. |
| Useless assignment to property. | Fewer false positive results | This query now treats assignments with complex right-hand sides correctly. |
| Useless conditional | Fewer results | Additional defensive coding patterns are now ignored. |
| Useless conditional | More true positive results | This query now flags additional uses of function call values. |

## Changes to QL libraries

* `DataFlow::SourceNode` is no longer an abstract class; to add new source nodes, extend `DataFlow::SourceNode::Range` instead.
* Subclasses of `DataFlow::PropRead` are no longer automatically made source nodes; you now need to additionally define a corresponding subclass of `DataFlow::SourceNode::Range` to achieve this.
* The deprecated libraries `semmle.javascript.DataFlow` and `semmle.javascript.dataflow.CallGraph` have been removed; they are both superseded by `semmle.javascript.dataflow.DataFlow`.
* Overriding `DataFlow::InvokeNode.getACallee()` no longer affects the call graph seen by the interprocedural data flow libraries. To do this, the 1-argument version `getACallee(int imprecision)` can be overridden instead.
* The predicate `DataFlow::returnedPropWrite` was intended for internal use only and is no longer available.
