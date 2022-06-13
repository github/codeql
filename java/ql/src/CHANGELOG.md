## 0.1.3

### New Queries

* Two new queries "Inefficient regular expression" (`java/redos`) and "Polynomial regular expression used on uncontrolled data" (`java/polynomial-redos`) have been added.
These queries help find instances of Regular Expression Denial of Service vulnerabilities. 

### Minor Analysis Improvements

* Query `java/sensitive-log` has received several improvements.
  * It no longer considers usernames as sensitive information.
  * The conditions to consider a variable a constant (and therefore exclude it as user-provided sensitive information) have been tightened.
  * A sanitizer has been added to handle certain elements introduced by a Kotlin compiler plugin that have deceptive names.

## 0.1.2

### Query Metadata Changes

* Query `java/predictable-seed` now has a tag for CWE-337. 

### Minor Analysis Improvements

* Query `java/insecure-cookie` now tolerates setting a cookie's secure flag to `request.isSecure()`. This means servlets that intentionally accept unencrypted connections will no longer raise an alert.
* The query `java/non-https-urls` has been simplified
and no longer requires its sinks to be `MethodAccess`es.
* The logic to detect `WebView`s with JavaScript (and optionally file access) enabled in the query `java/android/unsafe-android-webview-fetch` has been improved.

## 0.1.1

### Minor Analysis Improvements

* Query `java/insecure-cookie` no longer produces a false positive if `cookie.setSecure(...)` is called passing a constant that always equals `true`.

## 0.1.0

### Query Metadata Changes

* Added the `security-severity` tag to several queries.

### Minor Analysis Improvements

* Fixed "Local information disclosure in a temporary directory" (`java/local-temp-file-or-directory-information-disclosure`) to resolve false-negatives when OS isn't properly used as logical guard.
* The `SwitchCase.getRuleExpression()` predicate now gets expressions for case rules with an expression on the right-hand side of the arrow belonging to both `SwitchStmt` and `SwitchExpr`, and the corresponding `getRuleStatement()` no longer returns an `ExprStmt` in either case. Previously `SwitchStmt` and `SwitchExpr` behaved differently in 
this respect.

## 0.0.13

## 0.0.12

### New Queries

* The query "Insertion of sensitive information into log files" (`java/sensitive-logging`) has been promoted from experimental to the main query pack. This query was originally [submitted as an experimental query by @luchua-bc](https://github.com/github/codeql/pull/3090).

### Minor Analysis Improvements

 * Updated "Local information disclosure in a temporary directory" (`java/local-temp-file-or-directory-information-disclosure`) to remove false-positives when OS is properly used as logical guard.

## 0.0.11

## 0.0.10

### Breaking Changes

* Add more classes to Netty request/response splitting. Change identification to `java/netty-http-request-or-response-splitting`.
  Identify request splitting differently from response splitting in query results.
  Support addional classes:
  * `io.netty.handler.codec.http.CombinedHttpHeaders`
  * `io.netty.handler.codec.http.DefaultHttpRequest`
  * `io.netty.handler.codec.http.DefaultFullHttpRequest`

### New Queries

* A new query titled "Local information disclosure in a temporary directory" (`java/local-temp-file-or-directory-information-disclosure`) has been added.
  This query finds uses of APIs that leak potentially sensitive information to other local users via the system temporary directory.
  This query was originally [submitted as query by @JLLeitschuh](https://github.com/github/codeql/pull/4388).

## 0.0.9

### New Queries

* A new query "Cleartext storage of sensitive information using a local database on Android" (`java/android/cleartext-storage-database`) has been added. This query finds instances of sensitive data being stored in local databases without encryption, which may expose it to attackers or malicious applications.

## 0.0.8

### New Queries

* A new query "Use of implicit PendingIntents" (`java/android/pending-intents`) has been added.
This query finds implicit and mutable `PendingIntents` sent to an unspecified third party
component, which may provide an attacker with access to internal components of the application
or cause other unintended effects.
* Two new queries, "Android fragment injection" (`java/android/fragment-injection`) and "Android fragment injection in PreferenceActivity" (`java/android/fragment-injection-preference-activity`) have been added.
These queries find exported Android activities that instantiate and host fragments created from user-provided data. Such activities are vulnerable to access control bypass and expose the Android application to unintended effects.
* The query "`TrustManager` that accepts all certificates" (`java/insecure-trustmanager`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @intrigus-lgtm](https://github.com/github/codeql/pull/4879).
* The query "Log Injection" (`java/log-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. The query was originally [submitted as an experimental query by @porcupineyhairs and @dellalibera](https://github.com/github/codeql/pull/5099).
* A new query "Intent URI permission manipulation" (`java/android/intent-uri-permission-manipulation`) has been added.
This query finds Android components that return unmodified, received Intents to the calling applications, which
can provide unintended access to internal content providers of the victim application.
* A new query "Cleartext storage of sensitive information in the Android filesystem" (`java/android/cleartext-storage-filesystem`) has been added. This query finds instances of sensitive data being stored in local files without encryption, which may expose it to attackers or malicious applications.
* The query "Cleartext storage of sensitive information using `SharedPreferences` on Android" (`java/android/cleartext-storage-shared-prefs`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @luchua-bc](https://github.com/github/codeql/pull/4675).
* The query "Unsafe certificate trust" (`java/unsafe-cert-trust`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @luchua-bc](https://github.com/github/codeql/pull/3550).

### Query Metadata Changes

* The "Random used only once" (`java/random-used-once`) query no longer has a `security-severity` score. This has been causing some tools to categorise it as a security query, when it is more useful as a code-quality query.

## 0.0.7

## 0.0.6

## 0.0.5

### Minor Analysis Improvements

* The `java/constant-comparison` query no longer raises false alerts regarding comparisons with Unicode surrogate character literals.

## 0.0.4
