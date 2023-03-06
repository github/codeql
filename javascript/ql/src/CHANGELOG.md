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
