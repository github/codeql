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

No user-facing changes.

## 0.8.14

### New Queries

* Added a new query, `rb/insecure-mass-assignment`, for finding instances of mass assignment operations accepting arbitrary parameters from remote user input.
* Added a new query, `rb/csrf-protection-not-enabled`, to detect cases where Cross-Site Request Forgery protection is not enabled in Ruby on Rails controllers.

## 0.8.13

No user-facing changes.

## 0.8.12

No user-facing changes.

## 0.8.11

No user-facing changes.

## 0.8.10

### Minor Analysis Improvements

* Calls to `Object#method`, `Object#public_method` and `Object#singleton_method` with untrusted data are now recognised as sinks for code injection.
* Added additional request sources for Ruby on Rails.

## 0.8.9

No user-facing changes.

## 0.8.8

### New Queries

* Added a new experimental query, `rb/insecure-randomness`, to detect when application uses random values that are not cryptographically secure.

### Minor Analysis Improvements

* Added new unsafe deserialization sinks for the ox gem.
* Added an additional unsafe deserialization sink for the oj gem.

## 0.8.7

No user-facing changes.

## 0.8.6

No user-facing changes.

## 0.8.5

No user-facing changes.

## 0.8.4

No user-facing changes.

## 0.8.3

No user-facing changes.

## 0.8.2

No user-facing changes.

## 0.8.1

### New Queries

* Added a new experimental query, `rb/jwt-empty-secret-or-algorithm`, to detect when application uses an empty secret or weak algorithm.
* Added a new experimental query, `rb/jwt-missing-verification`, to detect when the application does not verify a JWT payload.

## 0.8.0

### Minor Analysis Improvements

* Built-in Ruby queries now use the new DataFlow API.

## 0.7.5

No user-facing changes.

## 0.7.4

### New Queries

* Added a new experimental query, `rb/improper-ldap-auth`, to detect cases where user input is used during LDAP authentication without proper validation or sanitization, potentially leading to authentication bypass.

## 0.7.3

No user-facing changes.

## 0.7.2

### New Queries

* Added a new experimental query, `rb/ldap-injection`, to detect cases where user input is incorporated into LDAP queries without proper validation or sanitization, potentially leading to LDAP injection vulnerabilities.

## 0.7.1

### New Queries

* Added a new experimental query, `rb/xpath-injection`, to detect cases where XPath statements are constructed from user input in an unsafe manner.

### Minor Analysis Improvements

* Improved resolution of calls performed on an object created with `Proc.new`.

## 0.7.0

### Minor Analysis Improvements

* Fixed a bug in how `map_filter` calls are analyzed. Previously, such calls would
  appear to the return the receiver of the call, but now the return value of the callback
  is properly taken into account.

### Bug Fixes

* The experimental query "Arbitrary file write during zipfile/tarfile extraction" (`ruby/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

## 0.6.4

No user-facing changes.

## 0.6.3

### Minor Analysis Improvements

* Fixed a bug that would occur when an `initialize` method returns `self` or one of its parameters.
  In such cases, the corresponding calls to `new` would be associated with an incorrect return type.
  This could result in inaccurate call target resolution and cause false positive alerts.
* Fixed an issue where calls to `delete` or `assoc` with a constant-valued argument would be analyzed imprecisely,
  as if the argument value was not a known constant.

## 0.6.2

No user-facing changes.

## 0.6.1

No user-facing changes.

## 0.6.0

### New Queries

* Added a new experimental query, `rb/server-side-template-injection`, to detect cases where user input may be embedded into a template's code in an unsafe manner.

## 0.5.6

### Minor Analysis Improvements

* `rb/sensitive-get-query` no longer reports flow paths from input parameters to sensitive use nodes. This avoids cases where many flow paths could be generated for a single parameter, which caused excessive paths to be generated.

## 0.5.5

### New Queries

* Added a new query, `rb/zip-slip`, to detect arbitrary file writes during extraction of zip/tar archives.

## 0.5.4

No user-facing changes.

## 0.5.3

### New Queries

* Added a new query, `rb/regex/badly-anchored-regexp`, to detect regular expression validators that use `^` and `$` 
  as anchors and therefore might match only a single line of a multi-line string.

### Minor Analysis Improvements

* The `rb/polynomial-redos` query now considers the entrypoints of the API of a gem as sources.

## 0.5.2

### New Queries

* Added a new query, `rb/html-constructed-from-input`, to detect libraries that unsafely construct HTML from their inputs.

## 0.5.1

### New Queries

* Added a new query, `rb/unsafe-code-construction`, to detect libraries that unsafely construct code from their inputs.

### Minor Analysis Improvements

* The `rb/unsafe-deserialization` query now recognizes input from STDIN as a source.

## 0.5.0

### New Queries

* Added a new query, `rb/stack-trace-exposure`, to detect exposure of stack-traces to users via HTTP responses.

### Minor Analysis Improvements

* The `AlertSuppression.ql` query has been updated to support the new `# codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `# lgtm` and `# lgtm[query-id]` comments can now also be placed on the line before an alert.
* Extended the `rb/kernel-open` query with following sinks: `IO.write`, `IO.binread`, `IO.binwrite`, `IO.foreach`, `IO.readlines`, and `URI.open`.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

### New Queries

* Added a new query, `rb/shell-command-constructed-from-input`, to detect libraries that unsafely construct shell commands from their inputs.

### Minor Analysis Improvements

* The `rb/sql-injection` query now considers consider SQL constructions, such as calls to `Arel.sql`, as sinks.

## 0.4.3

### Minor Analysis Improvements

* The `rb/weak-cryptographic-algorithm` has been updated to no longer report uses of hash functions such as `MD5` and `SHA1` even if they are known to be weak. These hash algorithms are used very often in non-sensitive contexts, making the query too imprecise in practice.

## 0.4.2

### New Queries

* Added a new query, `rb/non-constant-kernel-open`, to detect uses of Kernel.open and related methods with non-constant values.
* Added a new query, `rb/sensitive-get-query`, to detect cases where sensitive data is read from the query parameters of an HTTP `GET` request.

### Minor Analysis Improvements

* HTTP response header and body writes via `ActionDispatch::Response` are now
  recognized.
* The `rb/path-injection` query now treats the `file:` argument of the Rails `render` method as a sink.
* The alert messages of many queries were changed to better follow the style guide and make the messages consistent with other languages.

## 0.4.1

### Minor Analysis Improvements

* The `rb/xxe` query has been updated to add the following sinks for XML external entity expansion:
    1. Calls to parse XML using `LibXML` when its `default_substitute_entities` option is enabled.
    2. Uses of the Rails methods `ActiveSupport::XmlMini.parse`, `Hash.from_xml`, and `Hash.from_trusted_xml` when `ActiveSupport::XmlMini` is configured to use `LibXML` as its backend, and its `default_substitute_entities` option is enabled.

## 0.4.0

### New Queries

* Added a new query, `rb/hardcoded-data-interpreted-as-code`, to detect cases where hardcoded data is executed as code, a technique associated with backdoors.

### Minor Analysis Improvements

* The `rb/unsafe-deserialization` query now includes alerts for user-controlled data passed to `Hash.from_trusted_xml`, since that method can deserialize YAML embedded in the XML, which in turn can result in deserialization of arbitrary objects.
* The alert message of many queries have been changed to make the message consistent with other languages.

## 0.3.4

## 0.3.3

### New Queries

* Added a new query, `rb/log-injection`, to detect cases where a malicious user may be able to forge log entries.
* Added a new query, `rb/incomplete-multi-character-sanitization`. The query
  finds string transformations that do not replace all occurrences of a
  multi-character substring.
* Added a new query, `rb/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match 
  too many characters.

## 0.3.2

## 0.3.1

### New Queries

* Added a new experimental query, `rb/manually-checking-http-verb`, to detect cases when the HTTP verb for an incoming request is checked and then used as part of control flow.
* Added a new experimental query, `rb/weak-params`, to detect cases when the rails strong parameters pattern isn't followed and values flow into persistent store writes.

## 0.3.0

### Breaking Changes

* Contextual queries and the query libraries they depend on have been moved to the `codeql/ruby-all` package.

## 0.2.0

### New Queries

* Added a new query, `rb/improper-memoization`. The query finds cases where the parameter of a memoization method is not used in the memoization key.

### Minor Analysis Improvements

* The query "Use of a broken or weak cryptographic algorithm" (`rb/weak-cryptographic-algorithm`) now reports if a cryptographic operation is potentially insecure due to use of a weak block mode.

## 0.1.4

## 0.1.3

## 0.1.2

## 0.1.1

### New Queries

* Added a new query, `rb/insecure-download`. The query finds cases where executables and other sensitive files are downloaded over an insecure connection, which may allow for man-in-the-middle attacks.
* Added a new query, `rb/regex/missing-regexp-anchor`, which finds regular expressions which are improperly anchored. Validations using such expressions are at risk of being bypassed.
* Added a new query, `rb/incomplete-sanitization`. The query finds string transformations that do not replace or escape all occurrences of a meta-character.

## 0.1.0

### New Queries

* Added a new query, `rb/insecure-dependency`. The query finds cases where Ruby gems may be downloaded over an insecure communication channel.
* Added a new query, `rb/weak-cryptographic-algorithm`. The query finds uses of cryptographic algorithms that are known to be weak, such as DES.
* Added a new query, `rb/http-tainted-format-string`. The query finds cases where data from remote user input is used in a string formatting method in a way that allows arbitrary format specifiers to be inserted.
* Added a new query, `rb/http-to-file-access`. The query finds cases where data from remote user input is written to a file.
* Added a new query, `rb/incomplete-url-substring-sanitization`. The query finds instances where a URL is incompletely sanitized due to insufficient checks.

## 0.0.13

## 0.0.12

### New Queries

* Added a new query, `rb/clear-text-storage-sensitive-data`. The query finds cases where sensitive information, such as user credentials, are stored as cleartext.
* Added a new query, `rb/incomplete-hostname-regexp`. The query finds instances where a hostname is incompletely sanitized due to an unescaped character in a regular expression.

## 0.0.11

## 0.0.10

### New Queries

* Added a new query, `rb/clear-text-logging-sensitive-data`. The query finds cases where sensitive information, such as user credentials, are logged as cleartext.

## 0.0.9

## 0.0.8

### New Queries

* Added a new query, `rb/weak-cookie-configuration`. The query finds cases where cookie configuration options are set to values that may make an application more vulnerable to certain attacks.

### Minor Analysis Improvements

* The query `rb/csrf-protection-disabled` has been extended to find calls to the Rails method `protect_from_forgery` that may weaken CSRF protection.

## 0.0.7

## 0.0.6

## 0.0.5

## 0.0.4

### New Queries

* A new query (`rb/request-forgery`) has been added. The query finds HTTP requests made with user-controlled URLs.
* A new query (`rb/csrf-protection-disabled`) has been added. The query finds cases where cross-site forgery protection is explicitly disabled.

### Query Metadata Changes

* The precision of "Hard-coded credentials" (`rb/hardcoded-credentials`) has been decreased from "high" to "medium". This query will no longer be run and displayed by default on Code Scanning and LGTM.
