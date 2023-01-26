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
