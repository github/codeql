## 1.1.12

### Bug Fixes

* Classes that define a `writeReplace` method are no longer flagged by the `java/missing-no-arg-constructor-on-serializable` query on the assumption they are unlikely to be deserialized using the default algorithm.
* The query "Use of a broken or risky cryptographic algorithm" (`java/weak-cryptographic-algorithm`) now gives the reason why the cryptographic algorithm is considered weak.

## 1.1.11

No user-facing changes.

## 1.1.10

### Minor Analysis Improvements

* Added SHA-384 to the list of secure hashing algorithms. As a result the `java/potentially-weak-cryptographic-algorithm` query should no longer flag up uses of SHA-384.
* Added SHA3 to the list of secure hashing algorithms. As a result the `java/potentially-weak-cryptographic-algorithm` query should no longer flag up uses of SHA3.
* The `java/weak-cryptographic-algorithm` query has been updated to no longer report uses of hash functions such as `MD5` and `SHA1` even if they are known to be weak. These hash algorithms are used very often in non-sensitive contexts, making the query too imprecise in practice. The `java/potentially-weak-cryptographic-algorithm` query has been updated to report these uses instead.

## 1.1.9

No user-facing changes.

## 1.1.8

No user-facing changes.

## 1.1.7

No user-facing changes.

## 1.1.6

### Minor Analysis Improvements

* Added taint summary model for `org.springframework.core.io.InputStreamSource#getInputStream()`.

## 1.1.5

No user-facing changes.

## 1.1.4

No user-facing changes.

## 1.1.3

No user-facing changes.

## 1.1.2

### Minor Analysis Improvements

* Variables names containing the string "tokenizer" (case-insensitively) are no longer sources for the `java/sensitive-log` query. They normally relate to things like `java.util.StringTokenizer`, which are not sensitive information. This should fix some false positive alerts.
* The query "Unused classes and interfaces" (`java/unused-reference-type`) now recognizes that if a method of a class has an annotation then it may be accessed reflectively. This should remove false positive alerts, especially for JUnit 4-style tests annotated with `@test`.
* Alerts about exposing `exception.getMessage()` in servlet responses are now split out of `java/stack-trace-exposure` into its own query `java/error-message-exposure`.
* Added the extensible abstract class `SensitiveLoggerSource`. Now this class can be extended to add more sources to the `java/sensitive-log` query or for customizations overrides.

## 1.1.1

### Minor Analysis Improvements

* The heuristic to enable certain Android queries has been improved. Now it ignores Android Manifests which don't define an activity, content provider or service. We also only consider files which are under a folder containing such an Android Manifest for these queries. This should remove some false positive alerts.

## 1.1.0

### Major Analysis Improvements

* The query `java/weak-cryptographic-algorithm` no longer alerts about `RSA/ECB` algorithm strings.

### Minor Analysis Improvements

* The query `java/tainted-permissions-check` now uses threat models. This means that `local` sources are no longer included by default for this query, but can be added by enabling the `local` threat model.
* Added more `org.apache.commons.io.FileUtils`-related sinks to the path injection query.

## 1.0.2

No user-facing changes.

## 1.0.1

### Minor Analysis Improvements

* The query `java/spring-disabled-csrf-protection` detects disabling CSRF via `ServerHttpSecurity$CsrfSpec::disable`.
* Added more `java.io.File`-related sinks to the path injection query.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.
* Removed `local` query variants. The results pertaining to local sources can be found using the non-local counterpart query. As an example, the results previously found by `java/unvalidated-url-redirection-local` can be found by `java/unvalidated-url-redirection`, if the `local` threat model is enabled. The removed queries are `java/path-injection-local`, `java/command-line-injection-local`, `java/xss-local`, `java/sql-injection-local`, `java/http-response-splitting-local`, `java/improper-validation-of-array-construction-local`, `java/improper-validation-of-array-index-local`, `java/tainted-format-string-local`, `java/tainted-arithmetic-local`, `java/unvalidated-url-redirection-local`, `java/xxe-local` and `java/tainted-numeric-cast-local`.

### Minor Analysis Improvements

* The alert message for the query "Trust boundary violation" (`java/trust-boundary-violation`) has been updated to include a link to the remote source.
* The sanitizer of the query `java/zipslip` has been improved to include nodes that are safe due to having certain safe types. This reduces false positives. 

## 0.8.16

No user-facing changes.

## 0.8.15

No user-facing changes.

## 0.8.14

### Minor Analysis Improvements

* The `java/unknown-javadoc-parameter` now accepts `@param` tags that apply to the parameters of a
  record.

## 0.8.13

### New Queries

* The query `java/unsafe-url-forward-dispatch-load` has been promoted from experimental to the main query pack as `java/unvalidated-url-forward`. Its results will now appear by default. This query was originally submitted as an experimental query [by @haby0](https://github.com/github/codeql/pull/6240) and [by @luchua-bc](https://github.com/github/codeql/pull/7286).

### Major Analysis Improvements

* The `java/missing-case-in-switch` query now gives only a single alert for each switch statement, giving some examples of the missing cases as well as a count of how many are missing.

### Minor Analysis Improvements

* Variables named `tokenImage` are no longer sources for  the `java/sensitive-log` query. This is because this variable name is used in parsing code generated by JavaCC, so it causes a large number of false positive alerts.
* Added sanitizers for relative URLs, `List.contains()`, and checking the host of a URI to the `java/ssrf` and `java/unvalidated-url-redirection` queries.

## 0.8.12

No user-facing changes.

## 0.8.11

No user-facing changes.

## 0.8.10

### New Queries

* Added a new query `java/android/insecure-local-key-gen` for finding instances of keys generated for biometric authentication in an insecure way.

### Minor Analysis Improvements

* To reduce the number of false positives in the query "Insertion of sensitive information into log files" (`java/sensitive-log`), variables with names that contain "null" (case-insensitively) are no longer considered sources of sensitive information.

## 0.8.9

### New Queries

* Added a new query `java/android/insecure-local-authentication` for finding uses of biometric authentication APIs that do not make use of a `KeyStore`-backed key and thus may be bypassed.

### Query Metadata Changes

* The `security-severity` score of the query `java/relative-path-command` has been reduced to better adjust it to the specific conditions needed for exploitation.

### Major Analysis Improvements

* The sinks of the queries `java/path-injection` and `java/path-injection-local` have been reworked. Path creation sinks have been converted to summaries instead, while sinks now are actual file read/write operations only. This has reduced the false positive ratio of both queries.

### Minor Analysis Improvements

* The sanitizer for the path injection queries has been improved to handle more cases where `equals` is used to check an exact path match.
* The query `java/unvalidated-url-redirection` now sanitizes results following the same logic as the query `java/ssrf`. URLs where the destination cannot be controlled externally are no longer reported.

## 0.8.8

### New Queries

* Added a new query `java/android/sensitive-text` to detect instances of sensitive data being exposed through text fields without being properly masked. 
* Added a new query `java/android/sensitive-notification` to detect instances of sensitive data being exposed through Android notifications. 

## 0.8.7

### New Queries

* Added the `java/exec-tainted-environment` query, to detect the injection of environment variables names or values from remote input.

### Minor Analysis Improvements

* A manual neutral summary model for a callable now blocks all generated summary models for that callable from having any effect.

## 0.8.6

### New Queries

* Added the `java/insecure-randomness` query to detect uses of weakly random values which an attacker may be able to predict. Also added the `crypto-parameter` sink kind for sinks which represent the parameters and keys of cryptographic operations. 

### Minor Analysis Improvements

* Modified the `java/potentially-weak-cryptographic-algorithm` query to include the use of weak cryptographic algorithms from configuration values specified in properties files.
* The query `java/android/missing-certificate-pinning` should no longer alert about requests pointing to the local filesystem.
* Removed some spurious sinks related to `com.opensymphony.xwork2.TextProvider.getText` from the query `java/ognl-injection`.

### Bug Fixes

* The three queries `java/insufficient-key-size`, `java/server-side-template-injection`, and `java/android/implicit-pendingintents` had accidentally general extension points allowing arbitrary string-based flow state. This has been fixed and the old extension points have been deprecated where possible, and otherwise updated.

## 0.8.5

No user-facing changes.

## 0.8.4

No user-facing changes.

## 0.8.3

### Minor Analysis Improvements

* The query `java/unsafe-deserialization` has been improved to detect insecure calls to `ObjectMessage.getObject` in JMS.

## 0.8.2

### Minor Analysis Improvements

* java/summary/lines-of-code now gives the total number of lines of Java and Kotlin code, and is the only query tagged `lines-of-code`. java/summary/lines-of-code-java and java/summary/lines-of-code-kotlin give the per-language counts.
* The query `java/spring-disabled-csrf-protection` has been improved to detect more ways of disabling CSRF in Spring.

## 0.8.1

### Minor Analysis Improvements

* Most data flow queries that track flow from *remote* flow sources now use the current *threat model* configuration instead. This doesn't lead to any changes in the produced alerts (as the default configuration is *remote* flow sources) unless the threat model configuration is changed.

## 0.8.0

No user-facing changes.

## 0.7.5

No user-facing changes.

## 0.7.4

### New Queries

* Added the `java/trust-boundary-violation` query to detect trust boundary violations between HTTP requests and the HTTP session. Also added the `trust-boundary-violation` sink kind for sinks which may cross a trust boundary, such as calls to the `HttpSession#setAttribute` method.

### Minor Analysis Improvements

* The queries "Resolving XML external entity in user-controlled data" (`java/xxe`) and "Resolving XML external entity in user-controlled data from local source" (`java/xxe-local`) now recognize sinks in the MDHT library.

## 0.7.3

No user-facing changes.

## 0.7.2

### Minor Analysis Improvements

* The sanitizer in `java/potentially-weak-cryptographic-algorithm` has been improved, so the query may yield additional results.

## 0.7.1

### Minor Analysis Improvements

* The query "Unsafe resource fetching in Android WebView" (`java/android/unsafe-android-webview-fetch`) now recognizes WebViews where `setJavascriptEnabled`, `setAllowFileAccess`, `setAllowUniversalAccessFromFileURLs`, and/or `setAllowFileAccessFromFileURLs` are set inside the function block of the Kotlin `apply` function.

## 0.7.0

### Minor Analysis Improvements

* New models have been added for `org.apache.commons.lang`.
* The query `java/unsafe-deserialization` has been updated to take into account `SerialKiller`, a library used to prevent deserialization of arbitrary classes.

### Bug Fixes

* The query "Arbitrary file write during archive extraction ("Zip Slip")" (`java/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

## 0.6.4

No user-facing changes.

## 0.6.3

### Minor Analysis Improvements

* The `java/summary/lines-of-code` query now only counts lines of Java code. The new `java/summary/lines-of-code-kotlin` counts lines of Kotlin code.

## 0.6.2

### Minor Analysis Improvements

* The query `java/groovy-injection` now recognizes `groovy.text.TemplateEngine.createTemplate` as a sink.
* The queries `java/xxe` and `java/xxe-local` now recognize the second argument of calls to `XPath.evaluate` as a sink.
* Experimental sinks for the query "Resolving XML external entity in user-controlled data" (`java/xxe`) have been promoted to the main query pack. These sinks were originally [submitted as part of an experimental query by @haby0](https://github.com/github/codeql/pull/6564).

## 0.6.1

No user-facing changes.

## 0.6.0

### New Queries

* The query `java/insecure-ldap-auth` has been promoted from experimental to the main query pack. This query detects transmission of cleartext credentials in LDAP authentication. Insecure LDAP authentication causes sensitive information to be vulnerable to remote attackers. This query was originally [submitted as an experimental query by @luchua-bc](https://github.com/github/codeql/pull/4854)

## 0.5.6

No user-facing changes.

## 0.5.5

### New Queries

* Added a new query, `java/android/arbitrary-apk-installation`, to detect installation of APKs from untrusted sources.

## 0.5.4

No user-facing changes.

## 0.5.3

### New Queries

* Added a new query, `java/xxe-local`, which is a version of the XXE query that uses local sources (for example, reads from a local file).

### Minor Analysis Improvements

* The `java/index-out-of-bounds` query has improved its handling of arrays of constant length, and may report additional results in those cases.

## 0.5.2

### New Queries

* Added a new query, `java/android/sensitive-result-receiver`, to find instances of sensitive data being leaked to an untrusted `ResultReceiver`.

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
