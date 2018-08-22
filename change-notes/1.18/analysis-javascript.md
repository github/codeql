# Improvements to JavaScript analysis

## General improvements

* Additional heuristics have been added to `semmle.javascript.heuristics`. Add `import semmle.javascript.heuristics.all` to a query in order to activate all of the heuristics at once.

* Modelling of data flow through destructuring assignments has been improved. This may give additional results for the security queries and other queries that rely on data flow.

* Modelling of global variables has been improved. This may give more true-positive results and fewer false-positive results for a variety of queries.

* Modelling of re-export declarations has been improved. This may result in fewer false-positive results for a variety of queries.

* Modelling of taint flow through the array operations `map` and `join` has been improved. This may give additional results for the security queries.

* The taint tracking library recognizes more ways in which taint propagates. In particular, some flow through nested properties and through string formatters is now recognized. This may give additional results for the security queries.

* The taint tracking library now recognizes additional sanitization patterns. This may give fewer false-positive results for the security queries.

* Type inference for simple function calls has been improved. This may give additional results for queries that rely on type inference.

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following libraries:
  - [bluebird](http://bluebirdjs.com)
  - [browserid-crypto](https://github.com/mozilla/browserid-crypto)
  - [cookie-parser](https://github.com/expressjs/cookie-parser)
  - [cookie-session](https://github.com/expressjs/cookie-session)
  - [crypto-js](https://github.com/https://github.com/brix/crypto-js)
  - [deep-assign](https://github.com/sindresorhus/deep-assign)
  - [deep-extend](https://github.com/unclechu/node-deep-extend)
  - [deep-merge](https://github.com/Raynos/deep-merge)
  - [deep](https://github.com/jeffomatic/deep)
  - [deepmerge](https://github.com/KyleAMathews/deepmerge)
  - [defaults-deep](https://github.com/jonschlinkert/defaults-deep)
  - [defaults](https://github.com/tmpvar/defaults)
  - [ent](https://github.com/substack/node-ent)
  - [entities](https://github.com/fb55/node-entities)
  - [escape-goat](https://github.com/sindresorhus/escape-goat)
  - [express-jwt](https://github.com/auth0/express-jwt)
  - [express-session](https://github.com/expressjs/session)
  - [extend-shallow](https://github.com/jonschlinkert/extend-shallow)
  - [extend](https://github.com/justmoon/node-extend)
  - [extend2](https://github.com/eggjs/extend2)
  - [fast-json-parse](https://github.com/mcollina/fast-json-parse)
  - [forge](https://github.com/digitalbazaar/forge)
  - [format-util](https://github.com/tmpfs/format-util)
  - [global](https://www.npmjs.com/package/global)
  - [he](https://github.com/mathiasbynens/he)
  - [html-entities](https://github.com/mdevils/node-html-entities)
  - [jquery](https://jquery.com)
  - [js-extend](https://github.com/vmattos/js-extend)
  - [json-parse-better-errors](https://github.com/zkat/json-parse-better-errors)
  - [json-parse-safe](https://github.com/joaquimserafim/json-parse-safe)
  - [json-safe-parse](https://github.com/bahamas10/node-json-safe-parse)
  - [just-extend](https://github.com/angus-c/just)
  - [lodash](https://lodash.com)
  - [merge-deep](https://github.com/jonschlinkert/merge-deep)
  - [merge-options](https://github.com/schnittstabil/merge-options)
  - [merge](https://github.com/yeikos/js.merge)
  - [mixin-deep](https://github.com/jonschlinkert/mixin-deep)
  - [mixin-object](https://github.com/jonschlinkert/mixin-object)
  - [MySQL2](https://github.com/sidorares/node-mysql2)
  - [node.extend](https://github.com/dreamerslab/node.extend)
  - [object-assign](https://github.com/sindresorhus/object-assign)
  - [object.assign](https://github.com/ljharb/object.assign)
  - [object.defaults](https://github.com/jonschlinkert/object.defaults)
  - [parse-json](https://github.com/sindresorhus/parse-json)
  - [printf](https://github.com/adaltas/node-printf)
  - [printj](https://github.com/SheetJS/printj)
  - [q](http://documentup.com/kriskowal/q/)
  - [ramda](https://ramdajs.com)
  - [React Native](https://facebook.github.io/react-native/)
  - [safe-json-parse](https://github.com/Raynos/safe-json-parse)
  - [sanitize](https://github.com/pocketly/node-sanitize)
  - [sanitizer](https://github.com/theSmaw/Caja-HTML-Sanitizer)
  - [smart-extend](https://github.com/danielkalen/smart-extend)
  - [sprintf.js](https://github.com/alexei/sprintf.js)
  - [string-template](https://github.com/Matt-Esch/string-template)
  - [underscore](https://underscorejs.org)
  - [util-extend](https://github.com/isaacs/util-extend)
  - [utils-merge](https://github.com/jaredhanson/utils-merge)
  - [validator](https://github.com/chriso/validator.js)
  - [xss](https://github.com/leizongmin/js-xss)
  - [xtend](https://github.com/Raynos/xtend)

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Clear-text logging of sensitive information (`js/clear-text-logging`) | security, external/cwe/cwe-312, external/cwe/cwe-315, external/cwe/cwe-359 | Highlights logging of sensitive information, indicating a violation of [CWE-312](https://cwe.mitre.org/data/definitions/312.html). Results shown on LGTM by default. |
| Disabling Electron webSecurity (`js/disabling-electron-websecurity`) | security, frameworks/electron | Highlights Electron browser objects that are created with the `webSecurity` property set to false. Results shown on LGTM by default. |
| Enabling Electron allowRunningInsecureContent (`js/enabling-electron-insecure-content`) | security, frameworks/electron | Highlights Electron browser objects that are created with the `allowRunningInsecureContent` property set to true. Results shown on LGTM by default. |
| Use of externally-controlled format string (`js/tainted-format-string`) | security, external/cwe/cwe-134 | Highlights format strings containing user-provided data, indicating a violation of [CWE-134](https://cwe.mitre.org/data/definitions/134.html). Results shown on LGTM by default. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Arguments redefined | Fewer results | This rule previously also flagged redefinitions of `eval`. This was an oversight that is now fixed. |
| Comparison between inconvertible types | Fewer results | This rule now flags fewer comparisons involving parameters. |
| Comparison between inconvertible types | Lower severity | The severity of this rule has been revised to "warning". |
| CORS misconfiguration for credentials transfer | More true-positive results | This rule now treats header names case-insensitively. |
| Hard-coded credentials | More true-positive results | This rule now recognizes secret cryptographic keys. |
| Incomplete sanitization | More true-positive results | This rule now recognizes incomplete URL encoding and decoding. |
| Insecure randomness | More true-positive results | This rule now recognizes secret cryptographic keys. |
| Missing rate limiting | More true-positive results, fewer false-positive results | This rule now recognizes additional rate limiters and expensive route handlers. | 
| Missing X-Frame-Options HTTP header | Fewer false-positive results | This rule now treats header names case-insensitively. |
| Reflected cross-site scripting | Fewer false-positive results | This rule now treats header names case-insensitively. |
| Server-side URL redirect | More true-positive results | This rule now treats header names case-insensitively. |
| Superfluous trailing arguments | Fewer false-positive results | This rule now ignores calls to some empty functions. |
| Uncontrolled command line | More true-positive results | This rule now recognizes indirect command injection through `sh -c` and similar. |
| Unused variable | Fewer results | This rule no longer flags class expressions that could be made anonymous. While technically true, these results are not interesting. |
| Unused variable | Renamed | This rule has been renamed to "Unused variable, import, function or class" to reflect the fact that it flags different kinds of unused program elements. |
| Use of incompletely initialized object| Fewer results | This rule now flags the constructor instead its errorneous `this` or `super` expressions. |
| Useless conditional | Fewer results | This rule no longer flags uses of boolean return values. | 
| Useless conditional | Fewer results | This rule now flags fewer comparisons involving parameters. | 

## Changes to QL libraries

* HTTP and HTTPS requests made using the Node.js `http.request` and `https.request` APIs and the Electron `Electron.net.request` and `Electron.ClientRequest` APIs are modeled as `RemoteFlowSources`.
* HTTP header names are now always normalized to lower case to reflect the fact that they are case insensitive. In particular, the result of `HeaderDefinition.getAHeaderName`, and the first parameter of `HeaderDefinition.defines`, `ExplicitHeaderDefinition.definesExplicitly` and `RouteHandler.getAResponseHeader` is now always a lower-case string.
* New AST nodes for TypeScript 2.9 features have been added.
* The class `JsonParseCall` has been deprecated. Use `JsonParserCall` instead.
* The handling of spread arguments in the data flow library has been changed: `DataFlow::InvokeNode.getArgument(i)` is now only defined when there is no spread argument at or before argument position `i`, and similarly `InvokeNode.getNumArgument` is only defined for invocations without spread arguments.
