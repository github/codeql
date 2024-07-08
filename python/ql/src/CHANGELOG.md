## 1.0.2

No user-facing changes.

## 1.0.1

### Minor Analysis Improvements

* Added models for `opml` library.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### Minor Analysis Improvements

* Added models of `gradio` PyPI package.

## 0.9.16

### New Queries

* The `py/header-injection` query, originally contributed to the experimental query pack by @jorgectf, has been promoted to the main query pack and renamed to `py/http-response-splitting`. This query finds instances of http header injection / response splitting vulnerabilities.

## 0.9.15

No user-facing changes.

## 0.9.14

No user-facing changes.

## 0.9.13

No user-facing changes.

## 0.9.12

No user-facing changes.

## 0.9.11

No user-facing changes.

## 0.9.10

### New Queries

* The query `py/nosql-injection` for finding NoSQL injection vulnerabilities is now part of the default security suite.

## 0.9.9

No user-facing changes.

## 0.9.8

No user-facing changes.

## 0.9.7

### Minor Analysis Improvements

- Added modeling of YARL's `is_absolute` method and checks of the `netloc` of a parsed URL as sanitizers for the `py/url-redirection` query, leading to fewer false positives.

## 0.9.6

No user-facing changes.

## 0.9.5

No user-facing changes.

## 0.9.4

No user-facing changes.

## 0.9.3

### Minor Analysis Improvements

* Added modeling of more `FileSystemAccess` in packages `cherrypy`, `aiofile`, `aiofiles`, `anyio`, `sanic`, `starlette`, `baize`, and `io`. This will mainly affect the _Uncontrolled data used in path expression_ (`py/path-injection`) query.

## 0.9.2

No user-facing changes.

## 0.9.1

No user-facing changes.

## 0.9.0

### New Queries

* The query `py/nosql-injection` for finding NoSQL injection vulnerabilities is now available in the default security suite.

### Minor Analysis Improvements

* Improved _URL redirection from remote source_ (`py/url-redirection`) query to not alert when URL has been checked with `django.utils.http. url_has_allowed_host_and_scheme`.
* Extended the `py/command-line-injection` query with sinks from Python's `asyncio` module.

## 0.8.5

No user-facing changes.

## 0.8.4

### Minor Analysis Improvements

* Improved _Reflected server-side cross-site scripting_ (`py/reflective-xss`) query to not alert on data passed to `flask.jsonify`. Since these HTTP responses are returned with mime-type `application/json`, they do not pose a security risk for XSS.
* Updated path explanations for `@kind path-problem` queries to always include left hand side of assignments, making paths easier to understand.

## 0.8.3

No user-facing changes.

## 0.8.2

No user-facing changes.

## 0.8.1

### Minor Analysis Improvements

* Fixed modeling of `aiohttp.ClientSession` so we properly handle `async with` uses. This can impact results of server-side request forgery queries (`py/full-ssrf`, `py/partial-ssrf`).

## 0.8.0

### Bug Fixes

* The query "Arbitrary file write during archive extraction ("Zip Slip")" (`py/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

## 0.7.4

No user-facing changes.

## 0.7.3

### Bug Fixes

* The display name (`@name`) of the `py/unsafe-deserialization` query has been updated in favor of consistency with other languages.

## 0.7.2

No user-facing changes.

## 0.7.1

No user-facing changes.

## 0.7.0

### Bug Fixes

* Nonlocal variables are excluded from alerts.

## 0.6.6

No user-facing changes.

## 0.6.5

### New Queries

* Added a new query, `py/shell-command-constructed-from-input`, to detect libraries that unsafely construct shell commands from their inputs.

## 0.6.4

No user-facing changes.

## 0.6.3

No user-facing changes.

## 0.6.2

No user-facing changes.

## 0.6.1

No user-facing changes.

## 0.6.0

### Minor Analysis Improvements

* The `analysis/AlertSuppression.ql` query has moved to the root folder. Users that refer to this query by path should update their configurations. The query has been updated to support the new `# codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `# lgtm` and `# lgtm[query-id]` comments can now also be placed on the line before an alert.
* Bumped the minimum keysize we consider secure for elliptic curve cryptography from 224 to 256 bits, following current best practices. This might effect results from the _Use of weak cryptographic key_ (`py/weak-crypto-key`) query.
* Added modeling of `getpass.getpass` as a source of passwords, which will be an additional source for `py/clear-text-logging-sensitive-data`, `py/clear-text-storage-sensitive-data`, and `py/weak-sensitive-data-hashing`.

## 0.5.6

No user-facing changes.

## 0.5.5

No user-facing changes.

## 0.5.4

No user-facing changes.

## 0.5.3

No user-facing changes.

## 0.5.2

### Minor Analysis Improvements

* Added model of `cx_Oracle`, `oracledb`, `phonenixdb` and `pyodbc` PyPI packages as a SQL interface following PEP249, resulting in additional sinks for `py/sql-injection`.
* Added model of `executemany` calls on PEP-249 compliant database APIs, resulting in additional sinks for `py/sql-injection`.
* Added model of `pymssql` PyPI package as a SQL interface following PEP249, resulting in additional sinks for `py/sql-injection`.
* The alert messages of many queries were changed to better follow the style guide and make the messages consistent with other languages.

### Bug Fixes

* Fixed how `flask.request` is modeled as a RemoteFlowSource, such that we show fewer duplicated alert messages for Code Scanning alerts. The import, such as `from flask import request`, will now be shown as the first step in a path explanation.

## 0.5.1

No user-facing changes.

## 0.5.0

### Query Metadata Changes

* Added the `security-severity` tag the `py/redos`, `py/polynomial-redos`, and `py/regex-injection` queries.

### Minor Analysis Improvements

* The alert message of many queries have been changed to make the message consistent with other languages.

## 0.4.3

## 0.4.2

### New Queries

* Added a new query, `py/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match 
  too many characters.

## 0.4.1

## 0.4.0

### Breaking Changes

* Contextual queries and the query libraries they depend on have been moved to the `codeql/python-all` package.

## 0.3.0

### Breaking Changes

* Contextual queries and the query libraries they depend on have been moved to the `codeql/python-all` package.

## 0.2.0

### Major Analysis Improvements

* Improved library modeling for the query "Request without certificate validation" (`py/request-without-cert-validation`), so it now also covers `httpx`, `aiohttp.client`, and `urllib3`.

### Minor Analysis Improvements

* The query "Use of a broken or weak cryptographic algorithm" (`py/weak-cryptographic-algorithm`) now reports if a cryptographic operation is potentially insecure due to use of a weak block mode.

## 0.1.4

## 0.1.3

### New Queries

* The query "PAM authorization bypass due to incorrect usage" (`py/pam-auth-bypass`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @porcupineyhairs](https://github.com/github/codeql/pull/8595).

## 0.1.2

### New Queries

* "XML external entity expansion" (`py/xxe`). Results will appear by default. This query was based on [an experimental query by @jorgectf](https://github.com/github/codeql/pull/6112).
* "XML internal entity expansion" (`py/xml-bomb`). Results will appear by default. This query was based on [an experimental query by @jorgectf](https://github.com/github/codeql/pull/6112).
* The query "CSRF protection weakened or disabled" (`py/csrf-protection-disabled`) has been implemented. Its results will now appear by default.

## 0.1.1

## 0.1.0

## 0.0.13

## 0.0.12

## 0.0.11

### New Queries

* The query "XPath query built from user-controlled sources" (`py/xpath-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @porcupineyhairs](https://github.com/github/codeql/pull/6331).

## 0.0.10

### New Queries

* The query "LDAP query built from user-controlled sources" (`py/ldap-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @jorgectf](https://github.com/github/codeql/pull/5443).
* The query "Log Injection" (`py/log-injection`) has been promoted from experimental to the main query pack. Its results will now appear when `security-extended` is used. This query was originally [submitted as an experimental query by @haby0](https://github.com/github/codeql/pull/6182).

## 0.0.9

### Bug Fixes

* The [View AST functionality](https://docs.github.com/en/code-security/codeql-for-vs-code/using-the-advanced-functionality-of-the-codeql-for-vs-code-extension/exploring-the-structure-of-your-source-code) no longer prints detailed information about regular expressions, greatly improving performance.

## 0.0.8

### Major Analysis Improvements

* User names and other account information is no longer considered to be sensitive data for the queries `py/clear-text-logging-sensitive-data` and `py/clear-text-storage-sensitive-data`, since this lead to many false positives.

## 0.0.7

## 0.0.6

### New Queries

* Two new queries have been added for detecting Server-side request forgery (SSRF). _Full server-side request forgery_ (`py/full-ssrf`) will only alert when the URL is fully user-controlled, and _Partial server-side request forgery_ (`py/partial-ssrf`) will alert when any part of the URL is user-controlled. Only `py/full-ssrf` will be run by default.

### Minor Analysis Improvements

* To support the new SSRF queries, the PyPI package `requests` has been modeled, along with `http.client.HTTP[S]Connection` from the standard library.

## 0.0.5

### Minor Analysis Improvements

* Added modeling of many functions from the `os` module that uses file system paths, such as `os.stat`, `os.chdir`, `os.mkdir`, and so on. All of these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `tempfile` module for creating temporary files and directories, such as the functions `tempfile.NamedTemporaryFile` and `tempfile.TemporaryDirectory`. The `suffix`, `prefix`, and `dir` arguments are all vulnerable to path-injection, and these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Extended the modeling of FastAPI such that `fastapi.responses.FileResponse` are considered `FileSystemAccess`, making them sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `posixpath`, `ntpath`, and `genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of `wsgiref.simple_server` applications, leading to new remote flow sources.

## 0.0.4

### Query Metadata Changes

* Fixed the query ids of two queries that are meant for manual exploration: `python/count-untrusted-data-external-api` and `python/untrusted-data-to-external-api` have been changed to `py/count-untrusted-data-external-api` and `py/untrusted-data-to-external-api`.
