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
