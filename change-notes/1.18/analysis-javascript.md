# Improvements to JavaScript analysis

## General improvements

* Additional heuristics have been added to `semmle.javascript.heuristics`. Add `import semmle.javascript.heuristics.all` to a query in order to activate all of the heuristics at once.

* Modelling of data flow through destructuring assignments has been improved. This may give additional results for the security queries and other queries that rely on data flow.

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following libraries:
  - [bluebird](http://bluebirdjs.com)
  - [browserid-crypto](https://github.com/mozilla/browserid-crypto)
  - [cookie-parser](https://github.com/expressjs/cookie-parser)
  - [cookie-session](https://github.com/expressjs/cookie-session)
  - [crypto-js](https://github.com/https://github.com/brix/crypto-js)
  - [express-jwt](https://github.com/auth0/express-jwt)
  - [express-session](https://github.com/expressjs/session)
  - [fast-json-parse](https://github.com/mcollina/fast-json-parse)
  - [forge](https://github.com/digitalbazaar/forge)
  - [json-parse-better-errors](https://github.com/zkat/json-parse-better-errors)
  - [json-parse-safe](https://github.com/joaquimserafim/json-parse-safe)
  - [json-safe-parse](https://github.com/bahamas10/node-json-safe-parse)
  - [MySQL2](https://github.com/sidorares/node-mysql2)
  - [parse-json](https://github.com/sindresorhus/parse-json)
  - [q](http://documentup.com/kriskowal/q/)
  - [safe-json-parse](https://github.com/Raynos/safe-json-parse)

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Disabling Electron webSecurity (`js/disabling-electron-websecurity`) | security, frameworks/electron | Highlights Electron browser objects that are created with the `webSecurity` property set to false. Results shown on LGTM by default. |
| Enabling Electron allowRunningInsecureContent (`js/enabling-electron-insecure-content`) | security, frameworks/electron | Highlights Electron browser objects that are created with the `allowRunningInsecureContent` property set to true. Results shown on LGTM by default. |
| Use of externally-controlled format string (`js/tainted-format-string`) | security, external/cwe/cwe-134 | Highlights format strings containing user-provided data, indicating a violation of [CWE-134](https://cwe.mitre.org/data/definitions/134.html). Results shown on LGTM by default. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Arguments redefined | Fewer results | This rule previously also flagged redefinitions of `eval`. This was an oversight that is now fixed. |
| CORS misconfiguration for credentials transfer | More true-positive results | This rule now treats header names case-insensitively. |
| Hard-coded credentials | More true-positive results | This rule now recognizes secret cryptographic keys. |
| Insecure randomness | More true-positive results | This rule now recognizes secret cryptographic keys. |
| Missing rate limiting | More true-positive results, fewer false-positive results | This rule now recognizes additional rate limiters and expensive route handlers. | 
| Missing X-Frame-Options HTTP header | Fewer false-positive results | This rule now treats header names case-insensitively. |
| Reflected cross-site scripting | Fewer false-positive results | This rule now treats header names case-insensitively. |
| Server-side URL redirect | More true-positive results | This rule now treats header names case-insensitively. |
| Superfluous trailing arguments | Fewer false-positive results | This rule now ignores calls to some empty functions. |
| Uncontrolled command line | More true-positive results | This rule now recognizes indirect command injection through `sh -c` and similar. |
| Unused variable | Fewer results | This rule no longer flags class expressions that could be made anonymous. While technically true, these results are not interesting. |

## Changes to QL libraries

* HTTP header names are now always normalized to lower case to reflect the fact that they are case insensitive. In particular, the result of `HeaderDefinition.getAHeaderName`, and the first parameter of `HeaderDefinition.defines`, `ExplicitHeaderDefinition.definesExplicitly` and `RouteHandler.getAResponseHeader` is now always a lower-case string.
* The class `JsonParseCall` has been deprecated. Use `JsonParserCall` instead.
* The handling of spread arguments in the data flow library has been changed: `DataFlow::InvokeNode.getArgument(i)` is now only defined when there is no spread argument at or before argument position `i`, and similarly `InvokeNode.getNumArgument` is only defined for invocations without spread arguments.
