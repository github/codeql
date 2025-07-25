## 2.0.0

### Breaking Changes

* The `Type` and `Symbol` classes have been deprecated and will be empty in newly extracted databases, since the TypeScript extractor no longer populates them.
  This is a breaking change for custom queries that explicitly relied on these classes.
  Such queries will still compile, but with deprecation warnings, and may have different query results due to type information no longer being available.
  We expect most custom queries will not be affected, however. If a custom query has no deprecation warnings, it should not be affected by this change.
  Uses of `getType()` should be rewritten to use the new `getTypeBinding()` or `getNameBinding()` APIs instead.
  If the new API is not sufficient, please consider opening an issue in `github/codeql` describing your use-case.

### Major Analysis Improvements

* The TypeScript extractor no longer relies on the TypeScript compiler for extracting type information.
  Instead, the information we need from types is now derived by an algorithm written in QL.
  This results in more robust extraction with faster extraction times, in some cases significantly faster.
* Taint is now tracked through the React `use` function.
* Parameters of React server functions, marked with the `"use server"` directive, are now seen as taint sources.

### Minor Analysis Improvements

* Removed three queries from the JS qlpack, which have been superseded by newer queries that are part of the Actions qlpack:
  * `js/actions/pull-request-target` has been superseded by `actions/untrusted-checkout/{medium,high,critical}`
  * `js/actions/actions-artifact-leak` has been superseded by `actions/secrets-in-artifacts`
  * `js/actions/command-injection` has been superseded by `actions/command-injection/{medium,critical}`

## 1.7.0

### Query Metadata Changes

* The `quality` tag has been added to multiple JavaScript quality queries, with tags for `reliability` or `maintainability` categories and their sub-categories. See [Query file metadata and alert message style guide](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags) for more information about these categories.
* Added `reliability` tag to the `js/suspicious-method-name-declaration` query.
* Added `reliability` and `language-features` tags to the `js/template-syntax-in-string-literal` query.

### Minor Analysis Improvements

* The `js/loop-iteration-skipped-due-to-shifting` query now has the `reliability` tag.
* Fixed false positives in the `js/loop-iteration-skipped-due-to-shifting` query when the return value of `splice` is used to decide whether to adjust the loop counter.
* Fixed false positives in the `js/template-syntax-in-string-literal` query where template syntax in string concatenation and "manual string interpolation" patterns were incorrectly flagged.
* The `js/useless-expression` query now correctly flags only the innermost expressions with no effect, avoiding duplicate alerts on compound expressions.

## 1.6.2

No user-facing changes.

## 1.6.1

### Minor Analysis Improvements

* The queries `js/hardcoded-credentials` and `js/password-in-configuration-file` have been removed from all query suites.

## 1.6.0

### Query Metadata Changes

* The tag `external/cwe/cwe-79` has been removed from `js/disabling-electron-websecurity` and the tag `external/cwe/cwe-079` has been added.
* The tag `external/cwe/cwe-20` has been removed from `js/count-untrusted-data-external-api` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `js/untrusted-data-to-external-api` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `js/untrusted-data-to-external-api-more-sources` and the tag `external/cwe/cwe-020` has been added.

### Minor Analysis Improvements

* Type information is now propagated more precisely through `Promise.all()` calls,
  leading to more resolved calls and more sources and sinks being detected.

## 1.5.4

No user-facing changes.

## 1.5.3

### Minor Analysis Improvements

* Data passed to the [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response) constructor is now treated as a sink for `js/reflected-xss`.
* Slightly improved detection of DOM element references, leading to XSS results being detected in more cases.

### Bug Fixes

* Fixed a bug that would prevent extraction of `tsconfig.json` files when it contained an array literal with a trailing comma.

## 1.5.2

### Bug Fixes

* Fixed a bug, first introduced in `2.20.3`, that would prevent `v-html` attributes in Vue files
  from being flagged by the `js/xss` query. The original behaviour has been restored and the `v-html`
  attribute is once again functioning as a sink for the `js/xss` query.
* Fixed a bug that would in rare cases cause some regexp-based checks
  to be seen as generic taint sanitisers, even though the underlying regexp
  is not restrictive enough. The regexps are now analysed more precisely,
  and unrestrictive regexp checks will no longer block taint flow.
* Fixed a recently-introduced bug that caused `js/server-side-unvalidated-url-redirection` to ignore
  valid hostname checks and report spurious alerts after such a check. The original behaviour has been restored.

## 1.5.1

No user-facing changes.

## 1.5.0

### Major Analysis Improvements

* Improved precision of data flow through arrays, fixing some spurious flows
  that would sometimes cause the `length` property of an array to be seen as tainted.
* Improved call resolution logic to better handle calls resolving "downwards", targeting
  a method declared in a subclass of the enclosing class. Data flow analysis
  has also improved to avoid spurious flow between unrelated classes in the class hierarchy.

## 1.4.1

### Bug Fixes

* Fixed a recently-introduced bug that prevented taint tracking through `URLSearchParams` objects.
  The original behaviour has been restored and taint should once again be tracked through such objects.
* Fixed a rare issue that would occur when a function declaration inside a block statement was referenced before it was declared.
  Such code is reliant on legacy web semantics, which is non-standard but nevertheless implemented by most engines.
  CodeQL now takes legacy web semantics into account and resolves references to these functions correctly.
* Fixed a bug that would cause parse errors in `.jsx` files in rare cases where the file
  contained syntax that was misinterpreted as Flow syntax.

## 1.4.0

### Major Analysis Improvements

* Improved support for NestJS applications that make use of dependency injection with custom providers.
  Calls to methods on an injected service should now be resolved properly.
* TypeScript extraction is now better at analyzing projects where the main `tsconfig.json` file does not include any
  source files, but references other `tsconfig.json`-like files that do include source files.
* The `js/incorrect-suffix-check` query now recognises some good patterns of the form `origin.indexOf("." + allowedOrigin)` that were previously falsely flagged.
* Added a new threat model kind called `view-component-input`, which can enabled with [advanced setup](https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models).
  When enabled, all React props, Vue props, and input fields in an Angular component are seen as taint sources, even if none of the corresponding instantiation sites appear to pass in a tainted value.
  Some users may prefer this as a "defense in depth" option but note that it may result in false positives.
  Regardless of whether the threat model is enabled, CodeQL will propagate taint from the instantiation sites of such components into the components themselves.

### Bug Fixes

* Fixed a bug that would occur when TypeScript code was found in an HTML-like file, such as a `.vue` file,
  but where it could not be associated with any `tsconfig.json` file. Previously the embedded code was not
  extracted in this case, but should now be extracted properly.

## 1.3.0

### Major Analysis Improvements

* The `js/xss-through-dom` query now recognises sources of DOM input originating from Angular templates.

### Bug Fixes

* Fixed a TypeScript extractor crash that would occur when encountering an export specifier
  whose local specifier was a string literal.

## 1.2.6

No user-facing changes.

## 1.2.5

No user-facing changes.

## 1.2.4

No user-facing changes.

## 1.2.3

No user-facing changes.

## 1.2.2

No user-facing changes.

## 1.2.1

No user-facing changes.

## 1.2.0

### Major Analysis Improvements

- Added a new query (`js/actions/actions-artifact-leak`) to detect GitHub Actions artifacts that may leak the GITHUB_TOKEN token.

## 1.1.3

No user-facing changes.

## 1.1.2

### Minor Analysis Improvements

* Message events in the browser are now properly classified as client-side taint sources. Previously they were
  incorrectly classified as server-side taint sources, which resulted in some alerts being reported by
  the wrong query, such as server-side URL redirection instead of client-side URL redirection.

## 1.1.1

No user-facing changes.

## 1.1.0

### New Queries

* Added a new query, `js/insecure-helmet-configuration`, to detect instances where Helmet middleware is configured with important security features disabled.

### Minor Analysis Improvements

* Added a new query, `js/functionality-from-untrusted-domain`, which detects uses in HTML and JavaScript scripts from untrusted domains, including the `polyfill.io` content delivery network
  * it can be extended to detect other compromised scripts using user-provided data extensions of the `untrustedDomain` predicate, which takes one string argument with the domain to warn on (and will warn on any subdomains too).
* Modified existing query, `js/functionality-from-untrusted-source`, to allow adding this new query, but reusing the same logic
  * Added the ability to use data extensions to require SRI on CDN hostnames using the `isCdnDomainWithCheckingRequired` predicate, which takes one string argument of the full hostname to require SRI for.
* Created a new library, `semmle.javascript.security.FunctionalityFromUntrustedSource`, to support both queries.

## 1.0.3

### Minor Analysis Improvements

* Added a new experimental query, `js/cors-misconfiguration`, which detects misconfigured CORS HTTP headers in the `cors` and `apollo` libraries. 

## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

## 0.8.16

No user-facing changes.

## 0.8.15

### Minor Analysis Improvements

* The JavaScript extractor will on longer report syntax errors related to "strict mode".
  Files containing such errors are now being fully analyzed along with other sources files.
  This improves our support for source files that technically break the "strict mode" rules,
  but where a build steps transforms the code such that it ends up working at runtime.

## 0.8.14

### Minor Analysis Improvements

* `API::Node#getInstance()` now includes instances of subclasses, include transitive subclasses.
  The same changes applies to uses of the `Instance` token in data extensions.

## 0.8.13

### Query Metadata Changes

* The `@precision` of the `js/unsafe-external-link` has been reduced to `low` to reflect the fact that modern browsers do not expose the opening window for such links. This mitigates the potential security risk of having a link with `target="_blank"`.

### Minor Analysis Improvements

* The call graph has been improved, leading to more alerts for data flow based queries.

## 0.8.12

No user-facing changes.

## 0.8.11

No user-facing changes.

## 0.8.10

No user-facing changes.

## 0.8.9

### Bug Fixes

* The left operand of the `&&` operator no longer propagates data flow by default.

## 0.8.8

No user-facing changes.

## 0.8.7

### Minor Analysis Improvements

* Added support for [doT](https://github.com/olado/doT) templates. 

## 0.8.6

No user-facing changes.

## 0.8.5

No user-facing changes.

## 0.8.4

### Minor Analysis Improvements

* Added django URLs to detected "safe" URL patterns in `js/unsafe-external-link`. 

## 0.8.3

### Query Metadata Changes

* Lower the security severity of log-injection to medium.
* Increase the security severity of XSS to high.

## 0.8.2

### Minor Analysis Improvements

* Added modeling for importing `express-rate-limit` using a named import.

## 0.8.1

### Minor Analysis Improvements

* Added the `AmdModuleDefinition::Range` class, making it possible to define custom aliases for the AMD `define` function.

## 0.8.0

No user-facing changes.

## 0.7.5

### Bug Fixes

* Fixed an extractor crash that could occur in projects containing TypeScript files larger than 10 MB.

## 0.7.4

### Minor Analysis Improvements

* Files larger than 10 MB are no longer be extracted or analyzed.
* Imports can now be resolved in more cases, where a non-constant string expression is passed to a `require()` call.

### Bug Fixes

* Fixed an extractor crash that would occur in rare cases when a TypeScript file contains a self-referential namespace alias.

## 0.7.3

No user-facing changes.

## 0.7.2

No user-facing changes.

## 0.7.1

### Minor Analysis Improvements

* The `fs/promises` package is now recognised as an alias for `require('fs').promises`.
* The `js/path-injection` query can now track taint through calls to `path.join()` with a spread argument, such as `path.join(baseDir, ...args)`.

## 0.7.0

### Bug Fixes

* The query "Arbitrary file write during zip extraction ("Zip Slip")" (`js/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

## 0.6.4

No user-facing changes.

## 0.6.3

### Minor Analysis Improvements

* Fixed an issue where calls to a method named `search` would lead to false positive alerts related to regular expressions.
  This happened when the call was incorrectly seen as a call to `String.prototype.search`, since this function converts its first argument
  to a regular expression. The analysis is now more restrictive about when to treat `search` calls as regular expression sinks.

## 0.6.2

### Major Analysis Improvements

* Added taint sources from the `@actions/core` and `@actions/github` packages.
* Added command-injection sinks from the `@actions/exec` package.

### Minor Analysis Improvements

* The `js/indirect-command-line-injection` query no longer flags command arguments that cannot be interpreted as a shell string.
* The `js/unsafe-deserialization` query no longer flags deserialization through the `js-yaml` library, except
  when it is used with an unsafe schema.
* The Forge module in `CryptoLibraries.qll` now correctly classifies SHA-512/224,
  SHA-512/256, and SHA-512/384 hashes used in message digests as NonKeyCiphers.

### Bug Fixes

* Fixed a spurious diagnostic warning about comments in JSON files being illegal.
  Comments in JSON files are in fact fully supported, and the diagnostic message was misleading.

## 0.6.1

### Minor Analysis Improvements

* Improved the call graph to better handle the case where a function is stored on
  a plain object and subsequently copied to a new host object via an `extend` call.

### Bug Fixes

* Fixes an issue that would cause TypeScript extraction to hang in rare cases when extracting
  code containing recursive generic type aliases.

## 0.6.0

### Minor Analysis Improvements

* The `DisablingCertificateValidation.ql` query has been updated to check `createServer` from `https` for disabled certificate validation.
* Improved the model of jQuery to account for XSS sinks where the HTML string
  is provided via a callback. This may lead to more results for the `js/xss` query.
* The `js/weak-cryptographic-algorithm` query now flags cryptograhic operations using a weak block mode,
  such as AES-ECB.

### Bug Fixes

* Fixed a bug where a destructuring pattern could not be parsed if it had a property
  named `get` or `set` with a default value.

## 0.5.6

No user-facing changes.

## 0.5.5

### Minor Analysis Improvements

* The following queries now recognize HTML sanitizers as propagating taint: `js/sql-injection`,
  `js/path-injection`, `js/server-side-unvalidated-url-redirection`, `js/client-side-unvalidated-url-redirection`,
  and `js/request-forgery`.

## 0.5.4

### Minor Analysis Improvements

* The `js/regex-injection` query now recognizes environment variables and command-line arguments as sources.

## 0.5.3

No user-facing changes.

## 0.5.2

No user-facing changes.

## 0.5.1

No user-facing changes.

## 0.5.0

### Minor Analysis Improvements

* The `AlertSuppression.ql` query has been updated to support the new `// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `// lgtm` and `// lgtm[query-id]` comments can now also be placed on the line before an alert.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

### Minor Analysis Improvements

* Added support for `@hapi/glue` and Hapi plugins to the `frameworks/Hapi.qll` library.

### Bug Fixes

* Fixed a bug that would cause the extractor to crash when an `import` type is used in
  the `extends` clause of an `interface`.
* Fixed an issue with multi-line strings in YAML files being associated with an invalid location,
  causing alerts related to such strings to appear at the top of the YAML file.

## 0.4.3

### New Queries

* Added a new query, `js/second-order-command-line-injection`, to detect shell
  commands that may execute arbitrary code when the user has control over 
  the arguments to a command-line program.
  This currently flags up unsafe invocations of git and hg.

### Minor Analysis Improvements

* Added sources for user defined path and query parameters in `Next.js`.
* The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.

## 0.4.2

### Minor Analysis Improvements

* Removed some false positives from the `js/file-system-race` query by requiring that the file-check dominates the file-access.
* Improved taint tracking through `JSON.stringify` in cases where a tainted value is stored somewhere in the input object.

## 0.4.1

No user-facing changes.

## 0.4.0

### Minor Analysis Improvements

* Improved how the JavaScript parser handles ambiguities between plain JavaScript and dialects such as Flow and E4X that use the same file extension. The parser now prefers plain JavaScript if possible, falling back to dialects only if the source code can not be parsed as plain JavaScript. Previously, there were rare cases where parsing would fail because the parser would erroneously attempt to parse dialect-specific syntax in a regular JavaScript file.
- The `js/regexp/always-matches` query will no longer report an empty regular expression as always
  matching, as this is often the intended behavior.
* The alert message of many queries have been changed to make the message consistent with other languages.

### Bug Fixes

- Fixed a bug in the `js/type-confusion-through-parameter-tampering` query that would cause it to ignore
  sanitizers in branching conditions. The query should now report fewer false positives.

## 0.3.4

## 0.3.3

### New Queries

* Added a new query, `py/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match 
  too many characters.

## 0.3.2

## 0.3.1

### New Queries

- A new query "Case-sensitive middleware path" (`js/case-sensitive-middleware-path`) has been added.
  It highlights middleware routes that can be bypassed due to having a case-sensitive regular expression path.

## 0.3.0

### Breaking Changes

* Contextual queries and the query libraries they depend on have been moved to the `codeql/javascript-all` package.

## 0.2.0

### Minor Analysis Improvements

* The `js/resource-exhaustion` query no longer treats the 3-argument version of `Buffer.from` as a sink,
  since it does not allocate a new buffer.

## 0.1.4

## 0.1.3

### New Queries

* The `js/actions/command-injection` query has been added. It highlights GitHub Actions workflows that may allow an 
  attacker to execute arbitrary code in the workflow.
  The query previously existed an experimental query.
* A new query `js/insecure-temporary-file` has been added. The query detects the creation of temporary files that may be accessible by others users. The query is not run by default. 

## 0.1.2

### New Queries

* The `js/missing-origin-check` query has been added. It highlights "message" event handlers that do not check the origin of the event.  
  The query previously existed as the experimental `js/missing-postmessageorigin-verification` query.

## 0.1.1

### Minor Analysis Improvements

* The call graph now deals more precisely with calls to accessors (getters and setters).
  Previously, calls to static accessors were not resolved, and some method calls were
  incorrectly seen as calls to an accessor. Both issues have been fixed.

## 0.1.0

### New Queries

* The `js/resource-exhaustion` query has been added. It highlights locations where an attacker can cause a large amount of resources to be consumed. 
  The query previously existed as an experimental query.

### Minor Analysis Improvements

* Improved handling of custom DOM elements, potentially leading to more alerts for the XSS queries.
* Improved taint tracking through calls to the `Array.prototype.reduce` function.

## 0.0.14

## 0.0.13

### Minor Analysis Improvements

* Fixed an issue that would sometimes prevent the data-flow analysis from finding flow
  paths through a function that stores its result on an object.
  This may lead to more results for the security queries.

## 0.0.12

## 0.0.11

### New Queries

* A new query, `js/functionality-from-untrusted-source`, has been added to the query suite. It finds DOM elements
  that load functionality from untrusted sources, like `script` or `iframe` elements using `http` links.
  The query is run by default.

### Query Metadata Changes

* The `js/request-forgery` query previously flagged both server-side and client-side request forgery,
  but these are now handled by two different queries:
  * `js/request-forgery` is now specific to server-side request forgery. Its precision has been raised to
    `high` and is now shown by default (it was previously in the `security-extended` suite).
  * `js/client-side-request-forgery` is specific to client-side request forgery. This is technically a new query
    but simply flags a subset of what the old query did.
    This has precision `medium` and is part of the `security-extended` suite.

### Minor Analysis Improvements

* Added dataflow through the [`snapdragon`](https://npmjs.com/package/snapdragon) library.

## 0.0.10

### New Queries

* A new query, `js/unsafe-code-construction`, has been added to the query suite, highlighting libraries that may leave clients vulnerable to arbitrary code execution.
  The query is not run by default.
* A new query `js/file-system-race` has been added. The query detects when there is time between a file being checked and used. The query is not run by default.
* A new query `js/jwt-missing-verification` has been added. The query detects applications that don't verify JWT tokens.
* The `js/insecure-dependency` query has been added. It detects dependencies that are downloaded using an unencrypted connection.

## 0.0.9

### New Queries

* A new query `js/samesite-none-cookie` has been added. The query detects when the SameSite attribute is set to None on a sensitive cookie.
* A new query `js/empty-password-in-configuration-file` has been added. The query detects empty passwords in configuration files. The query is not run by default.

## 0.0.8

## 0.0.7

### Minor Analysis Improvements

* Support for handlebars templates has improved. Raw interpolation tags of the form `{{& ... }}` are now recognized,
  as well as whitespace-trimming tags like `{{~ ... }}`.
* Data flow is now tracked across middleware functions in more cases, leading to more security results in general. Affected packages are `express` and `fastify`.
* `js/missing-token-validation` has been made more precise, yielding both fewer false positives and more true positives.

## 0.0.6

### Major Analysis Improvements

* TypeScript 4.5 is now supported.

## 0.0.5

### New Queries

* The `js/sensitive-get-query` query has been added. It highlights GET requests that read sensitive information from the query string.
* The `js/insufficient-key-size` query has been added. It highlights the creation of cryptographic keys with a short key size.
* The `js/session-fixation` query has been added. It highlights servers that reuse a session after a user has logged in.
