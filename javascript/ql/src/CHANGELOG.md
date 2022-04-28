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

* A new query, `js/unsafe-code-construction`, has been added to the query suite, highlighting libraries that may leave clients vulnerable to arbitary code execution.
  The query is not run by default.
* A new query `js/file-system-race` has been added. The query detects when there is time between a file being checked and used. The query is not run by default.
* A new query `js/jwt-missing-verification` has been added. The query detects applications that don't verify JWT tokens.
* The `js/insecure-dependency` query has been added. It detects depedencies that are downloaded using an unencrypted connection.

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
