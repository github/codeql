# Improvements to JavaScript analysis

## General improvements

* Improved modeling of data flow through destructuring assignments may give additional results for the security queries and other queries that rely on data flow.

* Improved modeling of global variables may give more true-positive results and fewer false-positive results for a variety of queries.

* Improved modeling of re-export declarations may result in fewer false-positive results for a variety of queries.

* Improved modeling of taint flow through array operations may give additional results for the security queries.

* The taint tracking library recognizes more ways in which taint propagates. In particular, some flow through string formatters is now recognized. This may give additional results for the security queries.

* The taint tracking library now recognizes additional sanitization patterns. This may give fewer false-positive results for the security queries.

* Type inference for simple function calls has been improved. This may give additional results for queries that rely on type inference.

* Additional heuristics have been added to `semmle.javascript.heuristics`. Add `import semmle.javascript.heuristics.all` to a query in order to activate all of the heuristics at once.

* Handling of ambient TypeScript code has been improved. As a result, fewer false-positive results will be reported in `.d.ts` files.

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following libraries:
 [axios](https://github.com/axios/axios), 
 [bluebird](https://bluebirdjs.com), 
 [browserid-crypto](https://github.com/mozilla/browserid-crypto), 
 [compose-function](https://github.com/stoeffel/compose-function), 
 [cookie-parser](https://github.com/expressjs/cookie-parser), 
 [cookie-session](https://github.com/expressjs/cookie-session), 
 [cross-fetch](https://github.com/lquixada/cross-fetch), 
 [crypto-js](https://github.com/https://github.com/brix/crypto-js), 
 [deep-assign](https://github.com/sindresorhus/deep-assign), 
 [deep-extend](https://github.com/unclechu/node-deep-extend), 
 [deep-merge](https://github.com/Raynos/deep-merge), 
 [deep](https://github.com/jeffomatic/deep), 
 [deepmerge](https://github.com/KyleAMathews/deepmerge), 
 [defaults-deep](https://github.com/jonschlinkert/defaults-deep), 
 [defaults](https://github.com/tmpvar/defaults), 
 [dottie](https://github.com/mickhansen/dottie.js), 
 [dotty](https://github.com/deoxxa/dotty), 
 [ent](https://github.com/substack/node-ent), 
 [entities](https://github.com/fb55/node-entities), 
 [escape-goat](https://github.com/sindresorhus/escape-goat), 
 [express-jwt](https://github.com/auth0/express-jwt), 
 [express-session](https://github.com/expressjs/session), 
 [extend-shallow](https://github.com/jonschlinkert/extend-shallow), 
 [extend](https://github.com/justmoon/node-extend), 
 [extend2](https://github.com/eggjs/extend2), 
 [fast-json-parse](https://github.com/mcollina/fast-json-parse), 
 [forge](https://github.com/digitalbazaar/forge), 
 [format-util](https://github.com/tmpfs/format-util), 
 [got](https://github.com/sindresorhus/got), 
 [global](https://github.com/Raynos/global), 
 [he](https://github.com/mathiasbynens/he), 
 [html-entities](https://github.com/mdevils/node-html-entities), 
 [isomorphic-fetch](https://github.com/matthew-andrews/isomorphic-fetch), 
 [jquery](https://jquery.com), 
 [js-extend](https://github.com/vmattos/js-extend), 
 [json-parse-better-errors](https://github.com/zkat/json-parse-better-errors), 
 [json-parse-safe](https://github.com/joaquimserafim/json-parse-safe), 
 [json-safe-parse](https://github.com/bahamas10/node-json-safe-parse), 
 [just-compose](https://github.com/angus-c/just), 
 [just-extend](https://github.com/angus-c/just), 
 [lodash](https://lodash.com), 
 [merge-deep](https://github.com/jonschlinkert/merge-deep), 
 [merge-options](https://github.com/schnittstabil/merge-options), 
 [merge](https://github.com/yeikos/js.merge), 
 [mixin-deep](https://github.com/jonschlinkert/mixin-deep), 
 [mixin-object](https://github.com/jonschlinkert/mixin-object), 
 [MySQL2](https://github.com/sidorares/node-mysql2), 
 [node.extend](https://github.com/dreamerslab/node.extend), 
 [node-fetch](https://github.com/bitinn/node-fetch), 
 [object-assign](https://github.com/sindresorhus/object-assign), 
 [object.assign](https://github.com/ljharb/object.assign), 
 [object.defaults](https://github.com/jonschlinkert/object.defaults), 
 [parse-json](https://github.com/sindresorhus/parse-json), 
 [printf](https://github.com/adaltas/node-printf), 
 [printj](https://github.com/SheetJS/printj), 
 [q](https://documentup.com/kriskowal/q/), 
 [ramda](https://ramdajs.com), 
 [request](https://github.com/request/request), 
 [request-promise](https://github.com/request/request-promise), 
 [request-promise-any](https://github.com/request/request-promise-any), 
 [request-promise-native](https://github.com/request/request-promise-native), 
 [React Native](https://facebook.github.io/react-native/), 
 [safe-json-parse](https://github.com/Raynos/safe-json-parse), 
 [sanitize](https://github.com/pocketly/node-sanitize), 
 [sanitizer](https://github.com/theSmaw/Caja-HTML-Sanitizer), 
 [smart-extend](https://github.com/danielkalen/smart-extend), 
 [sprintf.js](https://github.com/alexei/sprintf.js), 
 [string-template](https://github.com/Matt-Esch/string-template), 
 [superagent](https://github.com/visionmedia/superagent), 
 [underscore](https://underscorejs.org), 
 [util-extend](https://github.com/isaacs/util-extend), 
 [utils-merge](https://github.com/jaredhanson/utils-merge), 
 [validator](https://github.com/chriso/validator.js), 
 [xss](https://github.com/leizongmin/js-xss), 
 [xtend](https://github.com/Raynos/xtend).

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Clear-text logging of sensitive information (`js/clear-text-logging`) | security, external/cwe/cwe-312, external/cwe/cwe-315, external/cwe/cwe-359 | Highlights logging of sensitive information, indicating a violation of [CWE-312](https://cwe.mitre.org/data/definitions/312.html). Results shown on LGTM by default. |
| Disabling Electron webSecurity (`js/disabling-electron-websecurity`) | security, frameworks/electron | Highlights Electron browser objects that are created with the `webSecurity` property set to false. Results shown on LGTM by default. |
| Enabling Electron allowRunningInsecureContent (`js/enabling-electron-insecure-content`) | security, frameworks/electron | Highlights Electron browser objects that are created with the `allowRunningInsecureContent` property set to true. Results shown on LGTM by default. |
| Uncontrolled data used in remote request (`js/request-forgery`) | security, external/cwe/cwe-918 | Highlights remote requests that are built from unsanitized user input, indicating a violation of [CWE-918](https://cwe.mitre.org/data/definitions/918.html). Results are hidden on LGTM by default. |
| Use of externally-controlled format string (`js/tainted-format-string`) | security, external/cwe/cwe-134 | Highlights format strings containing user-provided data, indicating a violation of [CWE-134](https://cwe.mitre.org/data/definitions/134.html). Results shown on LGTM by default. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Arguments redefined (`js/arguments-redefinition`) | Fewer results | This query previously also flagged redefinitions of `eval`. This was an oversight that is now fixed. |
| Comparison between inconvertible types (`js/comparison-between-incompatible-types`) | Fewer results | This query now flags fewer comparisons involving parameters. The severity of this query has been revised to "warning". |
| CORS misconfiguration for credentials transfer (`js/cors-misconfiguration-for-credentials`) | More true-positive results | This query now treats header names case-insensitively. |
| Hard-coded credentials (`js/hardcoded-credentials`) | More true-positive results | This query now recognizes secret cryptographic keys. |
| Incomplete string escaping or encoding (`js/incomplete-sanitization`) | New name, more true-positive results | The "Incomplete sanitization" query has been renamed to more clearly reflect its purpose. It now recognizes incomplete URL encoding and decoding. |
| Insecure randomness (`js/insecure-randomness`) | More true-positive results | This query now recognizes secret cryptographic keys. |
| Misleading indentation after control statement (`js/misleading-indentation-after-control-statement`) | Fewer results | This query temporarily ignores TypeScript files. |
| Missing rate limiting (`js/missing-rate-limiting`) | More true-positive results, fewer false-positive results | This query now recognizes additional rate limiters and expensive route handlers. |
| Omitted array element (`js/omitted-array-element`)| Fewer results | This query temporarily ignores TypeScript files. |
| Reflected cross-site scripting (`js/reflected-xss`) | Fewer false-positive results | This query now treats header names case-insensitively. |
| Semicolon insertion (`js/automatic-semicolon-insertion`) | Fewer results | This query temporarily ignores TypeScript files. |
| Server-side URL redirect (`js/server-side-unvalidated-url-redirection`) | More true-positive results | This query now treats header names case-insensitively. |
| Superfluous trailing arguments (`js/superfluous-trailing-arguments`) | Fewer false-positive results | This query now ignores calls to some empty functions. |
| Type confusion through parameter tampering (`js/type-confusion-through-parameter-tampering`) | Fewer false-positive results | This query no longer flags emptiness checks. |
| Uncontrolled command line (`js/command-line-injection`) | More true-positive results | This query now recognizes indirect command injection through `sh -c` and similar. |
| Unused variable, import, function or class (`js/unused-local-variable`) | New name, fewer results | The "Unused variable" query has been renamed to reflect the fact that it highlights different kinds of unused program elements. In addition, the query no longer highlights class expressions that could be made anonymous. While technically true, these results are not interesting. |
| Use of incompletely initialized object (`js/incomplete-object-initialization`) | Fewer results | This query now highlights the constructor instead of its erroneous `this` or `super` expressions. |
| Useless conditional (`js/trivial-conditional`) | Fewer results | This query no longer flags uses of boolean return values and highlights fewer comparisons involving parameters. |

## Changes to QL libraries

* HTTP and HTTPS requests made using the Node.js `http.request` and `https.request` APIs, and the Electron `Electron.net.request` and `Electron.ClientRequest` APIs, are modeled as `RemoteFlowSources`.
* HTTP header names are now always normalized to lower case to reflect the fact that they are case insensitive. In particular, the result of `HeaderDefinition.getAHeaderName`, and the first parameter of `HeaderDefinition.defines`, `ExplicitHeaderDefinition.definesExplicitly`, and `RouteHandler.getAResponseHeader` are now always a lower-case string.
* New AST nodes have been added for TypeScript 2.9 and 3.0 features.
* The class `JsonParseCall` has been deprecated. Update your queries to use `JsonParserCall` instead.
* The handling of spread arguments in the data flow library has been changed: `DataFlow::InvokeNode.getArgument(i)` is now only defined when there is no spread argument at or before argument position `i`, and similarly `InvokeNode.getNumArgument` is only defined for invocations without spread arguments.
