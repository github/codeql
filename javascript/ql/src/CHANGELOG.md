## 0.0.6

### Major Analysis Improvements

* TypeScript 4.5 is now supported.

## 0.0.5

### New Queries

* The `js/sensitive-get-query` query has been added. It highlights GET requests that read sensitive information from the query string.
* The `js/insufficient-key-size` query has been added. It highlights the creation of cryptographic keys with a short key size.
* The `js/session-fixation` query has been added. It highlights servers that reuse a session after a user has logged in.
