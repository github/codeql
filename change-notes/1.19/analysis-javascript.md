# Improvements to JavaScript analysis

## General improvements

* Modelling of taint flow through array operations has been improved. This may give additional results for the security queries.

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following features:
  - file system access, for example through [fs-extra](https://github.com/jprichardson/node-fs-extra) or [globby](https://www.npmjs.com/package/globby)


## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Enabling Node.js integration for Electron web content renderers (`js/enabling-electron-renderer-node-integration`) | security, frameworks/electron, external/cwe/cwe-094  | Highlights Electron web content renderer preferences with Node.js integration enabled, indicating a violation of [CWE-94](https://cwe.mitre.org/data/definitions/94.html). Results are not shown on LGTM by default. |
| Stored cross-site scripting (`js/stored-xss`) | security, external/cwe/cwe-079, external/cwe/cwe-116 | Highlights uncontrolled stored values flowing into HTML content, indicating a violation of [CWE-079](https://cwe.mitre.org/data/definitions/79.html). Results shown on LGTM by default. |
| Replacement of a substring with itself (`js/identity-replacement`) | correctness, security, external/cwe/cwe-116 | Highlights string replacements that replace a string with itself, which usually indicates a mistake. Results shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**        | **Change**                                   |
|--------------------------------|----------------------------|----------------------------------------------|
| Regular expression injection | Fewer false-positive results | This rule now identifies calls to `String.prototype.search` with more precision. |
| Unbound event handler receiver | Fewer false-positive results | This rule now recognizes additional ways class methods can be bound. |
| Remote property injection | Fewer results | The precision of this rule has been revised to "medium". Results are no longer shown on LGTM by default. |
| Missing CSRF middleware | Fewer false-positive results | This rule now recognizes additional CSRF protection middlewares. |

## Changes to QL libraries
