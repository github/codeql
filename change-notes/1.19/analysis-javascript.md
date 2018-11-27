# Improvements to JavaScript analysis

## General improvements

* Modelling of taint flow through array operations has been improved. This may give additional results for the security queries.

* Support for AMD modules has been improved. This may give additional results for the security queries as well as any queries that use type inference on code bases that use such modules.

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following features:
  - file system access, for example through [fs-extra](https://github.com/jprichardson/node-fs-extra) or [globby](https://www.npmjs.com/package/globby)
  - outbound network access, for example through the [fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
  - the [lodash](https://lodash.com), [underscore](https://underscorejs.org/), [async](https://www.npmjs.com/package/async) and [async-es](https://www.npmjs.com/package/async-es) libraries

* The taint tracking library now recognizes additional sanitization patterns. This may give fewer false-positive results for the security queries.

* Type inference for function calls has been improved. This may give additional results for queries that rely on type inference.

* Where applicable, path explanations have been added to the security queries.

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Enabling Node.js integration for Electron web content renderers (`js/enabling-electron-renderer-node-integration`) | security, frameworks/electron, external/cwe/cwe-094  | Highlights Electron web content renderer preferences with Node.js integration enabled, indicating a violation of [CWE-94](https://cwe.mitre.org/data/definitions/94.html). Results are not shown on LGTM by default. |
| File data in outbound network request | security, external/cwe/cwe-200 | Highlights locations where file data is sent in a network request. Results are not shown on LGTM by default. |
| Host header poisoning in email generation |  security, external/cwe/cwe-640 | Highlights code that generates emails with links that can be hijacked by HTTP host header poisoning, indicating a violation of [CWE-640](https://cwe.mitre.org/data/definitions/640.html). Results shown on LGTM by default.  |
| Unsafe dynamic method access (`js/unsafe-dynamic-method-access` ) | security, external/cwe/cwe-094 | Highlights code that invokes a user-controlled method on an object with unsafe methods. Results are shown on LGTM by default. |
| Replacement of a substring with itself (`js/identity-replacement`) | correctness, security, external/cwe/cwe-116 | Highlights string replacements that replace a string with itself, which usually indicates a mistake. Results shown on LGTM by default. |
| Stored cross-site scripting (`js/stored-xss`) | security, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights uncontrolled stored values flowing into HTML content, indicating a violation of [CWE-079](https://cwe.mitre.org/data/definitions/79.html). Results shown on LGTM by default. |
| Unclear precedence of nested operators (`js/unclear-operator-precedence`) | maintainability, correctness, external/cwe/cwe-783 | Highlights nested binary operators whose relative precedence is easy to misunderstand. Results shown on LGTM by default. |
| Unneeded defensive code | correctness, external/cwe/cwe-570, external/cwe/cwe-571 | Highlights locations where defensive code is not needed. Results are shown on LGTM by default. |
| Useless assignment to property | maintainability | Highlights property assignments whose value is always overwritten. Results are shown on LGTM by default. |
| User-controlled data in file | security, external/cwe/cwe-912 | Highlights locations where user-controlled data is written to a file. Results are not shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**        | **Change**                                   |
|--------------------------------|----------------------------|----------------------------------------------|
| Ambiguous HTML id attribute | Lower severity | The severity of this rule has been revised to "warning". |
| Clear-text logging of sensitive information | Fewer results | This rule now tracks flow more precisely. |
| Client side cross-site scripting | More results | This rule now also flags HTML injection in the body of an email. |
| Client-side URL redirect | Fewer false-positive results | This rule now recognizes safe redirects in more cases. |
| Conflicting HTML element attributes | Lower severity | The severity of this rule has been revised to "warning". |
| Duplicate 'if' condition | Lower severity | The severity of this rule has been revised to "warning". |
| Duplicate switch case | Lower severity | The severity of this rule has been revised to "warning". |
| Information exposure through a stack trace | More results | This rule now also flags cases where the entire exception object (including the stack trace) may be exposed. |
| Missing CSRF middleware | Fewer false-positive results | This rule now recognizes additional CSRF protection middlewares. |
| Missing 'this' qualifier | Fewer false-positive results | This rule now recognizes additional intentional calls to global functions. | 
| Missing variable declaration | Lower severity | The severity of this rule has been revised to "warning". |
| Regular expression injection | Fewer false-positive results | This rule now identifies calls to `String.prototype.search` with more precision. |
| Remote property injection | Fewer results | The precision of this rule has been revised to "medium". Results are no longer shown on LGTM by default. |
| Self assignment | Fewer false-positive results | This rule now ignores self-assignments preceded by a JSDoc comment with a `@type` tag. |
| Server-side URL redirect | Fewer false-positive results | This rule now recognizes safe redirects in more cases. |
| Server-side URL redirect | More results | This rule now recognizes redirection calls in more cases. |
| Unbound event handler receiver | Fewer false-positive results | This rule now recognizes additional ways class methods can be bound. |
| Uncontrolled data used in remote request | More results | This rule now recognizes additional kinds of requests. |
| Unknown directive | Fewer false positives results | This rule now recognizes YUI compressor directives. |
| Unused import | Fewer false-positive results | This rule no longer flags imports used by the `transform-react-jsx` Babel plugin. |
| Unused variable, import, function or class | Fewer false-positive results | This rule now flags fewer variables that may be used by `eval` calls. |
| Unused variable, import, function or class | Fewer results | This rule now flags import statements with multiple unused imports once. |
| Useless assignment to local variable | Fewer false-positive results | This rule now recognizes additional ways default values can be set. |
| Whitespace contradicts operator precedence | Fewer false-positive results | This rule no longer flags operators with asymmetric whitespace. |
| Wrong use of 'this' for static method | More results, fewer false-positive results | This rule now recognizes inherited methods. |

## Changes to QL libraries

* A `DataFlow::ParameterNode` instance now exists for all function parameters. Previously, unused parameters did not have a corresponding dataflow node.

* `ReactComponent::getAThisAccess` has been renamed to `getAThisNode`. The old name is still usable but is deprecated. It no longer gets individual `this` expressions, but the `ThisNode` mentioned above.

* The `DataFlow::ThisNode` class now corresponds to the implicit receiver parameter of a function, as opposed to an indivdual `this` expression. This means `getALocalSource` now maps all `this` expressions within a given function to the same source. The data-flow node associated with a `ThisExpr` can no longer be cast to `DataFlow::SourceNode` or `DataFlow::ThisNode` - it is recomended to use `getALocalSource` before casting or instead of casting.

* The flow configuration framework now supports distinguishing and tracking different kinds of taint, specified by an extensible class `FlowLabel` (which can also be referred to by its alias `TaintKind`).
