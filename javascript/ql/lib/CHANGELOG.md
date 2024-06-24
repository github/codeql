## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### Minor Analysis Improvements

* Additional heuristics for a new sensitive data classification for private information (e.g. credit card numbers) have been added to the shared `SensitiveDataHeuristics.qll` library. This may result in additional results for queries that use sensitive data such as `js/clear-text-storage-sensitive-data` and `js/clear-text-logging`.

### Bug Fixes

* Fixed a bug where very large TypeScript files would cause database creation to crash. Large files over 10MB were already excluded from analysis, but the file size check was not applied to TypeScript files.

## 0.9.1

No user-facing changes.

## 0.9.0

### Breaking Changes

* Deleted the deprecated `getInput` predicate from the `CryptographicOperation` class. Use `getAnInput` instead.
* Deleted the deprecated `RegExpPatterns` module from `Regexp.qll`.
* Deleted the deprecated `semmle/javascript/security/BadTagFilterQuery.qll`, `semmle/javascript/security/OverlyLargeRangeQuery.qll`, `semmle/javascript/security/regexp/RegexpMatching.qll`, and `Security/CWE-020/HostnameRegexpShared.qll` files.

### Minor Analysis Improvements

* Improved detection of whether a file uses CommonJS module system.

## 0.8.14

No user-facing changes.

## 0.8.13

### Major Analysis Improvements

* Added support for TypeScript 5.4.

## 0.8.12

No user-facing changes.

## 0.8.11

No user-facing changes.

## 0.8.10

No user-facing changes.

## 0.8.9

### Minor Analysis Improvements

* The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.

## 0.8.8

No user-facing changes.

## 0.8.7

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `CPU`, `TLD`, `SSA`, `ASM` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getMessageSuffix` predicates in `CodeInjectionCustomizations.qll`.
* Deleted the deprecated `semmle/javascript/security/dataflow/ExternalAPIUsedWithUntrustedData.qll` file.
* Deleted the deprecated `getANonHtmlHeaderDefinition` and `nonHtmlContentTypeHeader` predicates from `ReflectedXssCustomizations.qll`.
* Deleted the deprecated `semmle/javascript/security/OverlyLargeRangeQuery.qll`, `semmle/javascript/security/regexp/ExponentialBackTracking.qll`, `semmle/javascript/security/regexp/NfaUtils.qll`, and `semmle/javascript/security/regexp/NfaUtils.qll` files.
* Deleted the deprecated `Expressions/TypoDatabase.qll` file.
* The diagnostic query `js/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned JavaScript and TypeScript files, now considers any JavaScript and TypeScript file seen during extraction, even one with some errors, to be extracted / scanned.

## 0.8.6

No user-facing changes.

## 0.8.5

No user-facing changes.

## 0.8.4

### Minor Analysis Improvements

* Added models for the `sqlite` and `better-sqlite3` npm packages.
* TypeScript 5.3 is now supported.

## 0.8.3

No user-facing changes.

## 0.8.2

No user-facing changes.

## 0.8.1

### Minor Analysis Improvements

* The contents of `.jsp` files are now extracted, and any `<script>` tags inside these files will be parsed as JavaScript.
* [Import attributes](https://github.com/tc39/proposal-import-attributes) are now supported in JavaScript code.
  Note that import attributes are an evolution of an earlier proposal called "import assertions", which were implemented in TypeScript 4.5.
  The QL library includes new predicates named `getImportAttributes()` that should be used in favor of the now deprecated `getImportAssertion()`;
  in addition, the `getImportAttributes()` method of the `DynamicImportExpr` has been renamed to `getImportOptions()`. 
* Deleted the deprecated `getAnImmediateUse`, `getAUse`, `getARhs`, and `getAValueReachingRhs` predicates from the `API::Node` class.
* Deleted the deprecated `mayReferToParameter` predicate from `DataFlow::Node`.
* Deleted the deprecated `getStaticMethod` and `getAStaticMethod` predicates from `DataFlow::ClassNode`.
* Deleted the deprecated `isLibaryFile` predicate from `ClassifyFiles.qll`, use `isLibraryFile` instead.
* Deleted many library models that were build on the AST. Use the new models that are build on the dataflow library instead.
* Deleted the deprecated `semmle.javascript.security.performance` folder, use `semmle.javascript.security.regexp` instead.
* Tagged template literals have been added to `DataFlow::CallNode`. This allows the analysis to find flow into functions called with a tagged template literal, 
  and the arguments to a tagged template literal are part of the API-graph in `ApiGraphs.qll`.

## 0.8.0

No user-facing changes.

## 0.7.5

No user-facing changes.

## 0.7.4

### Major Analysis Improvements

* Added support for TypeScript 5.2.

## 0.7.3

No user-facing changes.

## 0.7.2

### Minor Analysis Improvements

* Added `log-injection` as a customizable sink kind for log injection.

## 0.7.1

No user-facing changes.

## 0.7.0

### Minor Analysis Improvements

* Added models for the Webix Framework.

## 0.6.4

No user-facing changes.

## 0.6.3

### Major Analysis Improvements

* Added support for TypeScript 5.1.

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `XML`, `JSON`, `URL`, `API`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `localTaintStep` predicate from `DataFlow.qll`.
* Deleted the deprecated `stringStep`, and `localTaintStep` predicates from `TaintTracking.qll`.
* Deleted many modules that started with a lowercase letter. Use the versions that start with an uppercase letter instead.
* Deleted the deprecated `HtmlInjectionConfiguration` and `JQueryHtmlOrSelectorInjectionConfiguration` classes from `DomBasedXssQuery.qll`, use `Configuration` instead.
* Deleted the deprecated `DefiningIdentifier` class and the `Definitions.qll` file it was in. Use `SsaDefinition` instead.
* Deleted the deprecated `definitionReaches`, `localDefinitionReaches`, `getAPseudoDefinitionInput`, `nextDefAfter`, and `localDefinitionOverwrites` predicates from `DefUse.qll`.
* Updated the following JavaScript sink kind names. Any custom data extensions that use these sink kinds will need to be updated accordingly in order to continue working.
  * `command-line-injection` to `command-injection`
  * `credentials[kind]` to `credentials-kind`
* Added a support of sub modules in `node_modules`.

## 0.6.2

### Minor Analysis Improvements

* Improved the queries for injection vulnerabilities in GitHub Actions workflows (`js/actions/command-injection` and `js/actions/pull-request-target`) and the associated library `semmle.javascript.Actions`. These now support steps defined in composite actions, in addition to steps defined in Actions workflow files. It supports more potentially untrusted input values. Additionally to the shell injections it now also detects injections in `actions/github-script`. It also detects simple injections from user controlled `${{ env.name }}`. Additionally to the `yml` extension now it also supports workflows with the `yaml` extension.

## 0.6.1

### Major Analysis Improvements

* The Yaml.qll library was moved into a shared library pack named `codeql/yaml` to make it possible for other languages to re-use it. This change should be backwards compatible for existing JavaScript queries.

## 0.6.0

### Major Analysis Improvements

* Added support for TypeScript 5.0.

### Minor Analysis Improvements

* `router.push` and `router.replace` in `Next.js` are now considered as XSS sink.
* The crypto-js module in `CryptoLibraries.qll` now supports progressive hashing with algo.update().

## 0.5.2

No user-facing changes.

## 0.5.1

### Minor Analysis Improvements

* Deleted the deprecated `getPath` and `getFolder` predicates from the `XmlFile` class.
* Deleted the deprecated `getId` from the `Function`, `NamespaceDefinition`, and `ImportEqualsDeclaration` classes.
* Deleted the deprecated `flowsTo` predicate from the `HTTP::Servers::RequestSource` and `HTTP::Servers::ResponseSource` class.
* Deleted the deprecated `getEventName` predicate from the `SocketIO::ReceiveNode`, `SocketIO::SendNode`, `SocketIOClient::SendNode` classes.
* Deleted the deprecated `RateLimitedRouteHandlerExpr` and `RouteHandlerExpressionWithRateLimiter` classes.
* [Import assertions](https://github.com/tc39/proposal-import-assertions) are now supported.
  Previously this feature was only supported in TypeScript code, but is now supported for plain JavaScript as well and is also accessible in the AST.

## 0.5.0

### Breaking Changes

* The `CryptographicOperation` concept has been changed to use a range pattern. This is a breaking change and existing implementations of `CryptographicOperation` will need to be updated in order to compile. These implementations can be updated by:
  1. Extending `CryptographicOperation::Range` rather than `CryptographicOperation`
  2. Renaming the `getInput()` member predicate as `getAnInput()`
  3. Implementing the `BlockMode getBlockMode()` member predicate. The implementation for this can be `none()` if the operation is a hashing operation or an encryption operation using a stream cipher.

## 0.4.3

### Minor Analysis Improvements

* Added dataflow sources for the [express-ws](https://www.npmjs.com/package/express-ws) library. 

## 0.4.2

### Minor Analysis Improvements

* Added sinks from the [`node-pty`](https://www.npmjs.com/package/node-pty) library to the `js/code-injection` query.

## 0.4.1

No user-facing changes.

## 0.4.0

### New Features

* Improved support for [Restify](http://restify.com/) framework, leading to more results when scanning applications developed with this framework.
* Added support for the [Spife](https://github.com/npm/spife) framework.

### Minor Analysis Improvements

* Deleted the deprecated `Instance` class from the `Vue` module.
* Deleted the deprecated `VHtmlSourceWrite` class from `DomBasedXssQuery.qll`.
* Deleted all the deprecated `[QueryName].qll` files from the `javascript/ql/lib/semmle/javascript/security/dataflow` folder, use the corresponding `[QueryName]Query.qll` files instead.
* The ReDoS libraries in `semmle.code.javascript.security.regexp` has been moved to a shared pack inside the `shared/` folder, and the previous location has been deprecated.

## 0.3.6

No user-facing changes.

## 0.3.5

No user-facing changes.

## 0.3.4

### Major Analysis Improvements

* Added support for TypeScript 4.9.

## 0.3.3

No user-facing changes.

## 0.3.2

No user-facing changes.

## 0.3.1

### Minor Analysis Improvements

- Several of the SQL and NoSQL library models have improved, leading to more results for the `js/sql-injection` query,
  and in some cases the `js/missing-rate-limiting` query.

## 0.3.0

### Breaking Changes

* Many library models have been rewritten to use dataflow nodes instead of the AST.
  The types of some classes have been changed, and these changes may break existing code.
  Other classes and predicates have been renamed, in these cases the old name is still available as a deprecated feature.

* The basetype of the following list of classes has changed from an expression to a dataflow node, and thus code using these classes might break. 
  The fix to these breakages is usually to use `asExpr()` to get an expression from a dataflow node, or to use `.flow()` to get a dataflow node from an expression.  
   - DOM.qll#WebStorageWrite
   - CryptoLibraries.qll#CryptographicOperation
   - Express.qll#Express::RequestBodyAccess
   - HTTP.qll#HTTP::ResponseBody
   - HTTP.qll#HTTP::CookieDefinition
   - HTTP.qll#HTTP::ServerDefinition
   - HTTP.qll#HTTP::RouteSetup
   - NoSQL.qll#NoSql::Query
   - SQL.qll#SQL::SqlString
   - SQL.qll#SQL::SqlSanitizer
   - HTTP.qll#ResponseBody
   - HTTP.qll#CookieDefinition
   - HTTP.qll#ServerDefinition
   - HTTP.qll#RouteSetup
   - HTTP.qll#HTTP::RedirectInvocation
   - HTTP.qll#RedirectInvocation
   - Express.qll#Express::RouterDefinition
   - AngularJSCore.qll#LinkFunction
   - Connect.qll#Connect::StandardRouteHandler
   - CryptoLibraries.qll#CryptographicKeyCredentialsExpr
   - AWS.qll#AWS::Credentials
   - Azure.qll#Azure::Credentials
   - Connect.qll#Connect::Credentials
   - DigitalOcean.qll#DigitalOcean::Credentials
   - Express.qll#Express::Credentials
   - NodeJSLib.qll#NodeJSLib::Credentials
   - PkgCloud.qll#PkgCloud::Credentials
   - Request.qll#Request::Credentials
   - ServiceDefinitions.qll#InjectableFunctionServiceRequest
   - SensitiveActions.qll#SensitiveVariableAccess
   - SensitiveActions.qll#CleartextPasswordExpr
   - Connect.qll#Connect::ServerDefinition
   - Restify.qll#Restify::ServerDefinition
   - Connect.qll#Connect::RouteSetup
   - Express.qll#Express::RouteSetup
   - Fastify.qll#Fastify::RouteSetup
   - Hapi.qll#Hapi::RouteSetup
   - Koa.qll#Koa::RouteSetup
   - Restify.qll#Restify::RouteSetup
   - NodeJSLib.qll#NodeJSLib::RouteSetup
   - Express.qll#Express::StandardRouteHandler
   - Express.qll#Express::SetCookie
   - Hapi.qll#Hapi::RouteHandler
   - HTTP.qll#HTTP::Servers::StandardHeaderDefinition
   - HTTP.qll#Servers::StandardHeaderDefinition
   - Hapi.qll#Hapi::ServerDefinition
   - Koa.qll#Koa::AppDefinition
   - SensitiveActions.qll#SensitiveCall

### Deprecated APIs

* Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### Major Analysis Improvements

* Added support for TypeScript 4.8.

### Minor Analysis Improvements

* A model for the `mermaid` library has been added. XSS queries can now detect flow through the `render` method of the `mermaid` library. 

## 0.2.5

## 0.2.4

### Deprecated APIs

* Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.
* The utility files previously in the `semmle.javascript.security.performance` package have been moved to the `semmle.javascript.security.regexp` package.  
  The previous files still exist as deprecated aliases.

### Minor Analysis Improvements

* Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

### Bug Fixes

* Fixed that top-level `for await` statements would produce a syntax error. These statements are now parsed correctly.

## 0.2.3

## 0.2.2

## 0.2.1

### Minor Analysis Improvements

* The `chownr` library is now modeled as a sink for the `js/path-injection` query.
* Improved modeling of sensitive data sources, so common words like `certain` and `secretary` are no longer considered a certificate and a secret (respectively).
* The `gray-matter` library is now modeled as a sink for the `js/code-injection` query.

## 0.2.0

### Major Analysis Improvements

* Added support for TypeScript 4.7.

### Minor Analysis Improvements

* All new ECMAScript 2022 features are now supported.

## 0.1.4

## 0.1.3

### Minor Analysis Improvements

* The `isLibaryFile` predicate from `ClassifyFiles.qll` has been renamed to `isLibraryFile` to fix a typo. 

## 0.1.2

### Deprecated APIs

* The `ReflectedXss`, `StoredXss`, `XssThroughDom`, and `ExceptionXss` modules from `Xss.qll` have been deprecated.  
  Use the `Customizations.qll` file belonging to the query instead.

### Minor Analysis Improvements

* The [cash](https://github.com/fabiospampinato/cash) library is now modelled as an alias for JQuery.  
  Sinks and sources from cash should now be handled by all XSS queries. 
* Added the `Selection` api as a DOM text source in the `js/xss-through-dom` query.
* The security queries now recognize drag and drop data as a source, enabling the queries to flag additional alerts.
* The security queries now recognize ClipboardEvent function parameters as a source, enabling the queries to flag additional alerts.

## 0.1.1

## 0.1.0

### Bug Fixes

* The following predicates on `API::Node` have been changed so as not to include the receiver. The receiver should now only be accessed via `getReceiver()`.
  - `getParameter(int i)` previously included the receiver when `i = -1`
  - `getAParameter()` previously included the receiver
  - `getLastParameter()` previously included the receiver for calls with no arguments

## 0.0.14

## 0.0.13

### Deprecated APIs

* Some predicates from `DefUse.qll`, `DataFlow.qll`, `TaintTracking.qll`, `DOM.qll`, `Definitions.qll` that weren't used by any query have been deprecated. 
  The documentation for each predicate points to an alternative.
* Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.
* Some modules that started with a lowercase letter have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### Minor Analysis Improvements

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.0.12

### Major Analysis Improvements

* Added support for TypeScript 4.6.

### Minor Analysis Improvements

* Added sources from the [`jszip`](https://www.npmjs.com/package/jszip) library to the `js/zipslip` query.

## 0.0.11

## 0.0.10

## 0.0.9

### Deprecated APIs

* The `codeql/javascript-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/javascript-all` CodeQL pack.

## 0.0.8

## 0.0.7

## 0.0.6

### New Features

* TypeScript 4.5 is now supported.

## 0.0.5
