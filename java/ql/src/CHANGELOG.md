## 0.5.1

### New Queries

* Added a new query `java/android/websettings-allow-content-access` to detect Android WebViews which do not disable access to `content://` urls.

### Minor Analysis Improvements

* The name, description and alert message for the query `java/concatenated-sql-query` have been altered to emphasize that the query flags the use of string concatenation to construct SQL queries, not the lack of appropriate escaping. The query's files have been renamed from `SqlUnescaped.ql` and `SqlUnescapedLib.qll` to `SqlConcatenated.ql` and `SqlConcatenatedLib.qll` respectively; in the unlikely event your custom configuration or queries refer to either of these files by name, those references will need to be adjusted. The query id remains `java/concatenated-sql-query`, so alerts should not be re-raised as a result of this change.

## 0.5.0

### New Queries

* Added a new query, `java/summary/generated-vs-manual-coverage`, to expose metrics for the number of API endpoints covered by generated versus manual MaD models.
* Added a new query, `java/telemetry/supported-external-api`, to detect supported 3rd party APIs used in a codebase.
* Added a new query, `java/android/missing-certificate-pinning`, to find network calls where certificate pinning is not implemented.
* Added a new query, `java/android-webview-addjavascriptinterface`, to detect the use of `addJavascriptInterface`, which can lead to cross-site scripting.
* Added a new query, `java/android-websettings-file-access`, to detect configurations that enable file system access in Android WebViews.
* Added a new query, `java/android-websettings-javascript-enabled`, to detect if JavaScript execution is enabled in an Android WebView.
* The query `java/regex-injection` has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @edvraa](https://github.com/github/codeql/pull/5704).

### Minor Analysis Improvements

* The `AlertSuppression.ql` query has been updated to support the new `// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `// lgtm` and `// lgtm[query-id]` comments can now also be placed on the line before an alert.
* The extensible predicates for Models as Data have been renamed (the `ext` prefix has been removed). As an example, `extSummaryModel` has been renamed to `summaryModel`.
* The query `java/misnamed-type` is now enabled for Kotlin.
* The query `java/non-serializable-field` is now enabled for Kotlin.
* Fixed an issue in the query `java/android/implicit-pendingintents` by which an implicit Pending Intent marked as immutable was not correctly recognized as such.
* The query `java/maven/non-https-url` no longer alerts about disabled repositories.

## 0.4.6

### Minor Analysis Improvements

* Kotlin extraction will now fail if the Kotlin version in use is at least 1.7.30. This is to ensure using an as-yet-unsupported version is noticable, rather than silently failing to extract Kotlin code and therefore producing false-negative results.

## 0.4.5

No user-facing changes.

## 0.4.4

### New Queries

* The query `java/insufficient-key-size` has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @luchua-bc](https://github.com/github/codeql/pull/4926).
* Added a new query, `java/android/sensitive-keyboard-cache`, to detect instances of sensitive information possibly being saved to the Android keyboard cache.

## 0.4.3

No user-facing changes.

## 0.4.2

### New Queries

* Added a new query, `java/android/incomplete-provider-permissions`, to detect if an Android ContentProvider is not protected with a correct set of permissions.
* A new query "Uncontrolled data used in content resolution" (`java/androd/unsafe-content-uri-resolution`) has been added. This query finds paths from user-provided data to URI resolution operations in Android's `ContentResolver` without previous validation or sanitization.

## 0.4.1

### New Queries

* Added a new query, `java/android/webview-debugging-enabled`, to detect instances of WebView debugging being enabled in production builds.

### Minor Analysis Improvements

* The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.
* `PathSanitizer.qll` has been promoted from experimental to the main query pack. This sanitizer was originally [submitted as part of an experimental query by @luchua-bc](https://github.com/github/codeql/pull/7286).
* The queries `java/path-injection`, `java/path-injection-local` and `java/zipslip` now use the sanitizers provided by `PathSanitizer.qll`.

## 0.4.0

### New Queries

* The query "Server-side template injection" (`java/server-side-template-injection`) has been promoted from experimental to the main query pack. This query was originally [submitted as an experimental query by @porcupineyhairs](https://github.com/github/codeql/pull/5935).
* Added a new query, `java/android/backup-enabled`, to detect if Android applications allow backups.

### Query Metadata Changes

* Removed the `@security-severity` tag from several queries not in the `Security/` folder that also had missing `security` tags.

### Minor Analysis Improvements

* The Java extractor now populates the `Method` relating to a `MethodAccess` consistently for calls using an explicit and implicit `this` qualifier. Previously if the method `foo` was inherited from a specialised generic type `ParentType<String>`, then an explicit call `this.foo()` would yield a `MethodAccess` whose `getMethod()` accessor returned the bound method `ParentType<String>.foo`, whereas an implicitly-qualified `foo()` `MethodAccess`'s `getMethod()` would return the unbound method `ParentType.foo`. Now both scenarios produce a bound method. This means that all data-flow queries may return more results where a relevant path transits a call to such an implicitly-qualified call to a member method with a bound generic type, while queries that inspect the result of `MethodAccess.getMethod()` may need to tolerate bound generic methods in more circumstances. The queries `java/iterator-remove-failure`, `java/non-static-nested-class`, `java/internal-representation-exposure`, `java/subtle-inherited-call` and `java/deprecated-call` have been amended to properly handle calls to bound generic methods, and in some instances may now produce more results in the explicit-`this` case as well.
* Added taint model for arguments of `java.net.URI` constructors to the queries `java/path-injection` and `java/path-injection-local`.
* Added new sinks related to Android's `AlarmManager` to the query `java/android/implicit-pendingintents`.
* The alert message of many queries have been changed to make the message consistent with other languages.

## 0.3.4

## 0.3.3

### New Queries

* Added a new query, `java/android/implicitly-exported-component`, to detect if components are implicitly exported in the Android manifest.
* A new query "Use of RSA algorithm without OAEP" (`java/rsa-without-oaep`) has been added. This query finds uses of RSA encryption that don't use the OAEP scheme.
* Added a new query, `java/android/debuggable-attribute-enabled`, to detect if the `android:debuggable` attribute is enabled in the Android manifest.
* The query "Using a static initialization vector for encryption" (`java/static-initialization-vector`) has been promoted from experimental to the main query pack. This query was originally [submitted as an experimental query by @artem-smotrakov](https://github.com/github/codeql/pull/6357).
* A new query `java/partial-path-traversal` finds partial path traversal vulnerabilities resulting from incorrectly using 
`String#startsWith` to compare canonical paths. 
* Added a new query, `java/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match 
  too many characters.

### Query Metadata Changes

* The queries `java/redos` and `java/polynomial-redos` now have a tag for CWE-1333. 

### Minor Analysis Improvements

* The query `java/static-initialization-vector` no longer requires a `Cipher` object to be initialized with `ENCRYPT_MODE` to be considered a valid sink. Also, several new sanitizers were added.
* Improved sanitizers for `java/sensitive-log`, which removes some false positives and improves performance a bit.

## 0.3.2

### New Queries

* A new query "Android `WebView` that accepts all certificates" (`java/improper-webview-certificate-validation`) has been added. This query finds implementations of `WebViewClient`s that accept all certificates in the case of an SSL error.

### Major Analysis Improvements

* The query `java/sensitive-log` has been improved to no longer report results that are effectively duplicates due to one source flowing to another source.

### Minor Analysis Improvements

* The query `java/path-injection` now recognises vulnerable APIs defined using the `SinkModelCsv` class with the `create-file` type. Out of the box this includes Apache Commons-IO functions, as well as any user-defined sinks.

## 0.3.1

## 0.3.0

### Breaking Changes

* Contextual queries and the query libraries they depend on have been moved to the `codeql/java-all` package.

### New Queries

* A new query "Improper verification of intent by broadcast receiver" (`java/improper-intent-verification`) has been added. 
  This query finds instances of Android `BroadcastReceiver`s that don't verify the action string of received intents when registered
  to receive system intents.

## 0.2.0

### Minor Analysis Improvements

* The query `java/log-injection` now reports problems at the source (user-controlled data) instead of at the ultimate logging call. This was changed because user functions that wrap the ultimate logging call could result in most alerts being reported in an uninformative location.

## 0.1.4

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
  Support additional classes:
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
