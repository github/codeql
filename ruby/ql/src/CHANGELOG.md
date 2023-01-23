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
