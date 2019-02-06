# Improvements to JavaScript analysis

## General improvements

* Support for popular libraries has been improved. Consequently, queries may produce better results on code bases that use the following features:
  - client-side code, for example [React](https://reactjs.org/)
  - cookies and webstorage, for example [js-cookie](https://github.com/js-cookie/js-cookie)
  - server-side code, for example [hapi](https://hapijs.com/)
  - asynchronous code, for example [a-sync-waterfall](https://www.npmjs.com/package/a-sync-waterfall)
* File classification has been improved to recognize additional generated files, for example files from [HTML Tidy](html-tidy.org).

* The taint tracking library now recognizes flow through persistent storage, class fields, and callbacks in certain cases. This may give more results for the security queries.

* Type inference for function calls has been improved. This may give additional results for queries that rely on type inference.

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cross-window communication with unrestricted target origin (`js/cross-window-information-leak`) | security, external/cwe/201, external/cwe/359 | Highlights code that sends potentially sensitive information to another window without restricting the receiver window's origin, indicating a possible violation of [CWE-201](https://cwe.mitre.org/data/definitions/201.html). Results are shown on LGTM by default. |
| Double escaping or unescaping (`js/double-escaping`) | correctness, security, external/cwe/cwe-116 | Highlights potential double escaping or unescaping of special characters, indicating a possible violation of [CWE-116](https://cwe.mitre.org/data/definitions/116.html). Results are shown on LGTM by default. |
| Incomplete regular expression for hostnames (`js/incomplete-hostname-regexp`) | correctness, security, external/cwe/cwe-020 |  Highlights hostname sanitizers that are likely to be incomplete, indicating a violation of [CWE-020](https://cwe.mitre.org/data/definitions/20.html). Results are shown on LGTM by default.|
| Incomplete URL substring sanitization | correctness, security, external/cwe/cwe-020 | Highlights URL sanitizers that are likely to be incomplete, indicating a violation of [CWE-020](https://cwe.mitre.org/data/definitions/20.html). Results shown on LGTM by default. |
| Incorrect suffix check (`js/incorrect-suffix-check`) | correctness, security, external/cwe/cwe-020 | Highlights error-prone suffix checks based on `indexOf`, indicating a potential violation of [CWE-20](https://cwe.mitre.org/data/definitions/20.html). Results are shown on LGTM by default. |
| Loop iteration skipped due to shifting (`js/loop-iteration-skipped-due-to-shifting`) | correctness | Highlights code that removes an element from an array while iterating over it, causing the loop to skip over some elements. Results are shown on LGTM by default. |
| Unbound event handler receiver (`js/unbound-event-handler-receiver`) | Fewer false positive results | Additional ways that class methods can be bound are recognized. |
| Useless comparison test (`js/useless-comparison-test`) | correctness | Highlights code that is unreachable due to a numeric comparison that is always true or always false. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                                  | **Expected impact**          | **Change**                                                                   |
|--------------------------------------------|------------------------------|------------------------------------------------------------------------------|
| Client-side cross-site scripting           | More true-positive results, fewer false-positive results.                 | This rule now recognizes WinJS functions that are vulnerable to HTML injection, and no longer flags certain safe uses of jQuery. |
| Hard-coded credentials                     | Fewer false-positive results | This rule no longer flag the empty string as a hardcoded username. |
| Insecure randomness | More results | This rule now flags insecure uses of `crypto.pseudoRandomBytes`. |
| Uncontrolled data used in network request  | More results                 | This rule now recognizes host values that are vulnerable to injection. |
| Unused parameter                           | Fewer false-positive results | This rule no longer flags parameters with leading underscore. |
| Unused variable, import, function or class | Fewer false-positive results | This rule now flags fewer variables that are implictly used by JSX elements, and no longer flags variables with leading underscore. |
| Uncontrolled data used in path expression | Fewer false-positive results | This rule now recognizes the Express `root` option, which prevents path traversal. |
| Unneeded defensive code | More true-positive results, fewer false-positive results. | This rule now recognizes additional defensive code patterns. |
| Useless conditional | Fewer results | Additional defensive coding patterns are now ignored. |
| Useless assignment to property. | Fewer false-positive results | This rule now treats assignments with complex right-hand sides correctly. |
| Unsafe dynamic method access              | Fewer false-positive results | This rule no longer flags concatenated strings as unsafe method names. |
| Unvalidated dynamic method call           | More true-positive results | This rule now flags concatenated strings as unvalidated method names in more cases. |
| Useless conditional | More true-positive results | This rule now flags additional uses of function call values. | 

## Changes to QL libraries

* `DataFlow::SourceNode` is no longer an abstract class; to add new source nodes, extend `DataFlow::SourceNode::Range` instead.
* Subclasses of `DataFlow::PropRead` are no longer automatically made source nodes; you now need to additionally define a corresponding subclass of `DataFlow::SourceNode::Range` to achieve this.
* The deprecated libraries `semmle.javascript.DataFlow` and `semmle.javascript.dataflow.CallGraph` have been removed; they are both superseded by `semmle.javascript.dataflow.DataFlow`.
* The predicate `DataFlow::returnedPropWrite` was intended for internal use only and is no longer available.
