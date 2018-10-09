# Improvements to JavaScript analysis

## General improvements

* Modelling of taint flow through array operations has been improved. This may give additional results for the security queries.

* The taint tracking library now recognizes additional sanitization patterns. This may give fewer false-positive results for the security queries.

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following features:
  - file system access, for example through [fs-extra](https://github.com/jprichardson/node-fs-extra) or [globby](https://www.npmjs.com/package/globby)

* The type inference now handles nested imports (that is, imports not appearing at the toplevel). This may yield fewer false-positive results on projects that use this non-standard language feature.

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Enabling Node.js integration for Electron web content renderers (`js/enabling-electron-renderer-node-integration`) | security, frameworks/electron, external/cwe/cwe-094  | Highlights Electron web content renderer preferences with Node.js integration enabled, indicating a violation of [CWE-94](https://cwe.mitre.org/data/definitions/94.html). Results are not shown on LGTM by default. |
| Host header poisoning in email generation |  security, external/cwe/cwe-640 | Highlights code that generates emails with links that can be hijacked by HTTP host header poisoning, indicating a violation of [CWE-640](https://cwe.mitre.org/data/definitions/640.html). Results shown on LGTM by default.  |
| Replacement of a substring with itself (`js/identity-replacement`) | correctness, security, external/cwe/cwe-116 | Highlights string replacements that replace a string with itself, which usually indicates a mistake. Results shown on LGTM by default. |
| Stored cross-site scripting (`js/stored-xss`) | security, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights uncontrolled stored values flowing into HTML content, indicating a violation of [CWE-079](https://cwe.mitre.org/data/definitions/79.html). Results shown on LGTM by default. |
| Unclear precedence of nested operators (`js/unclear-operator-precedence`) | maintainability, correctness, external/cwe/cwe-783 | Highlights nested binary operators whose relative precedence is easy to misunderstand. Results shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**        | **Change**                                   |
|--------------------------------|----------------------------|----------------------------------------------|
| Useless assignment to local variable | Fewer false-positive results | This rule now recognizes additional ways default values can be set. |
| Regular expression injection | Fewer false-positive results | This rule now identifies calls to `String.prototype.search` with more precision. |
| Unbound event handler receiver | Fewer false-positive results | This rule now recognizes additional ways class methods can be bound. |
| Remote property injection | Fewer results | The precision of this rule has been revised to "medium". Results are no longer shown on LGTM by default. |
| Missing CSRF middleware | Fewer false-positive results | This rule now recognizes additional CSRF protection middlewares. |
| Server-side URL redirect | More results | This rule now recognizes redirection calls in more cases. |
| Whitespace contradicts operator precedence | Fewer false-positive results | This rule no longer flags operators with asymmetric whitespace. |

## Changes to QL libraries

* The flow configuration framework now supports distinguishing and tracking different kinds of taint, specified by an extensible class `FlowLabel` (which can also be referred to by its alias `TaintKind`).

* The `DataFlow::ThisNode` class now corresponds to the implicit receiver parameter of a function, as opposed to an indivdual `this` expression. This means `getALocalSource` now maps all `this` expressions within a given function to the same source. The data-flow node associated with a `ThisExpr` can no longer be cast to `DataFlow::SourceNode` or `DataFlow::ThisNode` - it is recomended to use `getALocalSource` before casting or instead of casting.

* `ReactComponent::getAThisAccess` has been renamed to `getAThisNode`. The old name is still usable but is deprecated. It no longer gets individual `this` expressions, but the `ThisNode` mentioned above.
