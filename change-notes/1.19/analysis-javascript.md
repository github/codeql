# Improvements to JavaScript analysis

## General improvements

* Modeling of taint flow through array and buffer operations has been improved. This may give additional results for the security queries.

* Support for AMD modules has been improved. This may give additional results for the security queries, as well as any queries that use type inference on code bases that use such modules.

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following features:
  - File system access, for example, through [fs-extra](https://github.com/jprichardson/node-fs-extra) or [globby](https://www.npmjs.com/package/globby)
  - Outbound network access, for example, through the [fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
  - The [lodash](https://lodash.com), [underscore](https://underscorejs.org/), [async](https://www.npmjs.com/package/async) and [async-es](https://www.npmjs.com/package/async-es) libraries

* The taint tracking library now recognizes additional sanitization patterns. This may give fewer false-positive results for the security queries.

* Type inference for function calls has been improved. This may give additional results for queries that rely on type inference.

* Path explanations have been added to the relevant security queries. 
Use [QL for Eclipse](https://help.semmle.com/ql-for-eclipse/Content/WebHelp/getting-started.html) 
to run queries and explore the data flow in results.

## New LGTM queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Enabling Node.js integration for Electron web content renderers (`js/enabling-electron-renderer-node-integration`) | security, frameworks/electron, external/cwe/cwe-094  | Highlights Electron web content renderer preferences with Node.js integration enabled, indicating a violation of [CWE-94](https://cwe.mitre.org/data/definitions/94.html). Results are hidden on LGTM by default. |
| Hard-coded data interpreted as code (`js/hardcoded-data-interpreted-as-code`) | security, external/cwe/cwe-506 | Highlights locations where hard-coded data is transformed and then executed as code or interpreted as an import path, which may indicate embedded malicious code ([CWE-506](https://cwe.mitre.org/data/definitions/506.html)). Results are hidden on LGTM by default. |
| Host header poisoning in email generation (`js/host-header-forgery-in-email-generation`)|  security, external/cwe/cwe-640 | Highlights code that generates emails with links that can be hijacked by HTTP host header poisoning, indicating a violation of [CWE-640](https://cwe.mitre.org/data/definitions/640.html). Results shown on LGTM by default.  |
| Replacement of a substring with itself (`js/identity-replacement`) | correctness, security, external/cwe/cwe-116 | Highlights string replacements that replace a string with itself, which usually indicates a mistake. Results shown on LGTM by default. |
| Stored cross-site scripting (`js/stored-xss`) | security, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights uncontrolled stored values flowing into HTML content, indicating a violation of [CWE-079](https://cwe.mitre.org/data/definitions/79.html). Results shown on LGTM by default. |
| Unclear precedence of nested operators (`js/unclear-operator-precedence`) | maintainability, correctness, external/cwe/cwe-783 | Highlights nested binary operators whose relative precedence is easy to misunderstand. Results shown on LGTM by default. |
| Unneeded defensive code | correctness, external/cwe/cwe-570, external/cwe/cwe-571 | Highlights locations where defensive code is not needed. Results are shown on LGTM by default. |
| Unsafe dynamic method access (`js/unsafe-dynamic-method-access` ) | security, external/cwe/cwe-094 | Highlights code that invokes a user-controlled method on an object with unsafe methods. Results are shown on LGTM by default. |
| Unvalidated dynamic method access (`js/unvalidated-dynamic-method-call` ) | security, external/cwe/cwe-754 | Highlights code that invokes a user-controlled method without guarding against exceptional circumstances. Results are shown on LGTM by default. |
| Useless assignment to property (`js/useless-assignment-to-property`) | maintainability | Highlights property assignments whose value is always overwritten. Results are shown on LGTM by default. |

## Other new queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| File data in outbound network request (`js/file-access-to-http`) | security, external/cwe/cwe-200 | Highlights locations where file data is sent in a network request.|
| User-controlled data written to file (`js/http-to-file-access`) | security, external/cwe/cwe-912 | Highlights locations where user-controlled data is written to a file. |


## Changes to existing queries

| **Query**                      | **Expected impact**        | **Change**                                   |
|--------------------------------|----------------------------|----------------------------------------------|
| Ambiguous HTML id attribute | Lower severity | Severity revised to "warning". |
| Clear-text logging of sensitive information | Fewer results | Query now tracks flow more precisely. |
| Client side cross-site scripting | More results | HTML injection in the body of an email is also highlighted. |
| Client-side URL redirect | Fewer false positive results | Safe redirects recognized in more cases. |
| Conflicting HTML element attributes | Lower severity | Severity revised to "warning". |
| Duplicate 'if' condition | Lower severity | Severity revised to "warning". |
| Duplicate switch case | Lower severity | Severity revised to "warning". |
| Inconsistent use of 'new' | Simpler result presentation | Results show one call with `new` and one without. |
| Information exposure through a stack trace | More results | Cases where the entire exception object (including the stack trace) may be exposed are highlighted. |
| Missing 'this' qualifier | Fewer false positive results | Additional intentional calls to global functions are recognized. |
| Missing CSRF middleware | Fewer false positive results | Additional types of CSRF protection middleware are recognized. |
| Missing variable declaration | Lower severity | Severity revised to "warning". |
| Regular expression injection | Fewer false positive results | Calls to `String.prototype.search` are identified with more precision. |
| Remote property injection | Fewer results | No longer highlights dynamic method calls, which are now handled by two new queries: TODO. The precision of this rule has been revised to "medium", reflecting the precision of the remaining results. Results are now hidden on LGTM by default. |
| Self assignment | Fewer false positive results | Self-assignments preceded by a JSDoc comment with a `@type` tag are no longer highlighted. |
| Server-side URL redirect | More results and fewer false positive results | More redirection calls are identified. More safe redirections are recognized and ignored. |
| Unbound event handler receiver | Fewer false positive results | Additional ways that class methods can be bound are recognized. |
| Uncontrolled data used in remote request | More results | Additional kinds of requests are identified. |
| Unknown directive | Fewer false positives results | YUI compressor directives are now recognized. |
| Unused import | Fewer false positive results | Imports used by the `transform-react-jsx` Babel plugin are no longer highlighted. |
| Unused variable, import, function or class | Fewer false positive results and fewer results | Fewer variables that may be used by `eval` calls are highlighted. Only one result is reported for an import statement with multiple unused imports. |
| Useless assignment to local variable | Fewer false positive results | Additional ways default values can be set are recognized. |
| Useless conditional | More results, fewer false positive results | More types of conditional are recognized. Additional defensive coding patterns are now ignored. |
| Whitespace contradicts operator precedence | Fewer false positive results | Operators with asymmetric whitespace are no longer highlighted. |
| Wrong use of 'this' for static method | More results, fewer false-positive results | Inherited methods are now identified. |

## Changes to QL libraries

* A `DataFlow::ParameterNode` instance now exists for all function parameters. Previously, unused parameters did not have a corresponding data-flow node.

* `ReactComponent::getAThisAccess` has been renamed to `getAThisNode`. The old name is still usable but is deprecated. It no longer gets individual `this` expressions, but the `ThisNode` mentioned below.

* The `DataFlow::ThisNode` class now corresponds to the implicit receiver parameter of a function, as opposed to an individual `this` expression. This means that `getALocalSource` now maps all `this` expressions within a given function to the same source. The data-flow node associated with a `ThisExpr` can no longer be cast to `DataFlow::SourceNode` or `DataFlow::ThisNode`. Using `getALocalSource` before casting, or instead of casting, is recommended.

* The flow configuration framework now supports distinguishing and tracking different kinds of taint, specified by an extensible class `FlowLabel` (which can also be referred to by its alias `TaintKind`).
