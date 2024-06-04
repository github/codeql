## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

## 0.8.16

No user-facing changes.

## 0.8.15

No user-facing changes.

## 0.8.14

No user-facing changes.

## 0.8.13

### Major Analysis Improvements

* The `Stored` variants of some queries (`cs/stored-command-line-injection`, `cs/web/stored-xss`, `cs/stored-ldap-injection`, `cs/xml/stored-xpath-injection`, `cs/second-order-sql-injection`) have been removed. If you were using these queries, their results can be restored by enabling the `file` and `database` threat models in your threat model configuration.

### Minor Analysis Improvements

* The alert message of `cs/wrong-compareto-signature` has been changed to remove unnecessary element references.
* Data flow queries that track flow from *local* flow sources now use the current *threat model* configuration instead. This may lead to changes in the produced alerts if the threat model configuration only uses *remote* flow sources. The changed queries are `cs/code-injection`, `cs/resource-injection`, `cs/sql-injection`, and `cs/uncontrolled-format-string`.

## 0.8.12

No user-facing changes.

## 0.8.11

No user-facing changes.

## 0.8.10

### Minor Analysis Improvements

* Most data flow queries that track flow from *remote* flow sources now use the current *threat model* configuration instead. This doesn't lead to any changes in the produced alerts (as the default configuration is *remote* flow sources) unless the threat model configuration is changed. The changed queries are `cs/code-injection`, `cs/command-line-injection`, `cs/user-controlled-bypass`, `cs/count-untrusted-data-external-api`, `cs/untrusted-data-to-external-api`, `cs/ldap-injection`, `cs/log-forging`, `cs/xml/missing-validation`, `cs/redos`, `cs/regex-injection`, `cs/resource-injection`, `cs/sql-injection`, `cs/path-injection`, `cs/unsafe-deserialization-untrusted-input`, `cs/web/unvalidated-url-redirection`, `cs/xml/insecure-dtd-handling`, `cs/xml/xpath-injection`, `cs/web/xss`, and `cs/uncontrolled-format-string`.

## 0.8.9

### Minor Analysis Improvements

* Added sanitizers for relative URLs, `List.Contains()`, and checking the `.Host` property on an URI to the `cs/web/unvalidated-url-redirection` query.

## 0.8.8

### Minor Analysis Improvements

* Added string interpolation expressions and `string.Format` as possible sanitizers for the `cs/web/unvalidated-url-redirection` query.

## 0.8.7

### Minor Analysis Improvements

* Modelled additional flow steps to track flow from handler methods of a `PageModel` class to the corresponding Razor Page (`.cshtml`) file, which may result in additional results for queries such as `cs/web/xss`.

## 0.8.6

### Minor Analysis Improvements

* Fixed a Log forging false positive when using `String.Replace` to sanitize the input.    
* Fixed a URL redirection from remote source false positive when guarding a redirect with `HttpRequestBase.IsUrlLocalToHost()`

## 0.8.5

No user-facing changes.

## 0.8.4

### Minor Analysis Improvements

* Modelled additional flow steps to track flow from a `View` call in an MVC controller to the corresponding Razor View (`.cshtml`) file, which may result in additional results for queries such as `cs/web/xss`.

## 0.8.3

### Minor Analysis Improvements

* CIL extraction is now disabled by default. It is still possible to turn on CIL extraction by setting the `cil` extractor option to `true` or by setting the environment variable `$CODEQL_EXTRACTOR_CSHARP_OPTION_CIL` to `true`. This is the first step towards sun-setting the CIL extractor entirely.

## 0.8.2

No user-facing changes.

## 0.8.1

### Minor Analysis Improvements

* The `cs/web/insecure-direct-object-reference` and `cs/web/missing-function-level-access-control` have been improved to better recognize attributes on generic classes.

## 0.8.0

### New Queries

* Added a new query, `cs/web/insecure-direct-object-reference`, to find instances of missing authorization checks for resources selected by an ID parameter.

## 0.7.5

No user-facing changes.

## 0.7.4

No user-facing changes.

## 0.7.3

No user-facing changes.

## 0.7.2

No user-facing changes.

## 0.7.1

No user-facing changes.

## 0.7.0

### New Queries

* Added a new query, `cs/web/missing-function-level-access-control`, to find instances of missing authorization checks.

### Bug Fixes

* The query "Arbitrary file write during zip extraction ("Zip Slip")" (`cs/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

## 0.6.4

No user-facing changes.

## 0.6.3

No user-facing changes.

## 0.6.2

No user-facing changes.

## 0.6.1

### Minor Analysis Improvements

* Additional sinks modelling writes to unencrypted local files have been added to `ExternalLocationSink`, used by the `cs/cleartext-storage` and `cs/exposure-of-sensitive-information` queries.

## 0.6.0

### Minor Analysis Improvements

* The query `cs/web/debug-binary` now disregards the `debug` attribute in case there is a transformation that removes it.

## 0.5.6

No user-facing changes.

## 0.5.5

No user-facing changes.

## 0.5.4

No user-facing changes.

## 0.5.3

No user-facing changes.

## 0.5.2

No user-facing changes.

## 0.5.1

No user-facing changes.

## 0.5.0

### New Queries

* Added a new query, `csharp/telemetry/supported-external-api`, to detect supported 3rd party APIs used in a codebase.

### Minor Analysis Improvements

* The `AlertSuppression.ql` query has been updated to support the new `// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `// lgtm` and `// lgtm[query-id]` comments can now also be placed on the line before an alert.
* The extensible predicates for Models as Data have been renamed (the `ext` prefix has been removed). As an example, `extSummaryModel` has been renamed to `summaryModel`.

### Bug Fixes

* Fixes a bug where the Owin.qll framework library will look for "URI" instead of "Uri" in the OwinRequest class.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

No user-facing changes.

## 0.4.3

No user-facing changes.

## 0.4.2

No user-facing changes.

## 0.4.1

### Minor Analysis Improvements

* The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.

## 0.4.0

### Minor Analysis Improvements

* A new extractor option has been introduced for disabling CIL extraction. Either pass `-Ocil=false` to the `codeql` CLI or set the environment variable `CODEQL_EXTRACTOR_CSHARP_OPTION_CIL=false`.
* The alert message of many queries have been changed to make the message consistent with other languages.

## 0.3.4

## 0.3.3

### Minor Analysis Improvements

* Parameters of delegates passed to routing endpoint calls like `MapGet` in ASP.NET Core are now considered remote flow sources.
* The query `cs/unsafe-deserialization-untrusted-input` is not reporting on all calls of `JsonConvert.DeserializeObject` any longer, it only covers cases that explicitly use unsafe serialization settings.
* Added better support for the SQLite framework in the SQL injection query.
* File streams are now considered stored flow sources. For example, reading query elements from a file can lead to a Second Order SQL injection alert.

## 0.3.2

## 0.3.1

## 0.3.0

### Breaking Changes

* Contextual queries and the query libraries they depend on have been moved to the `codeql/csharp-all` package.

## 0.2.0

### Query Metadata Changes

* The `kind` query metadata was changed to `diagnostic` on `cs/compilation-error`, `cs/compilation-message`, `cs/extraction-error`, and `cs/extraction-message`.

### Minor Analysis Improvements

* The syntax of the (source|sink|summary)model CSV format has been changed slightly for Java and C#. A new column called `provenance` has been introduced, where the allowed values are `manual` and `generated`. The value used to indicate whether a model as been written by hand (`manual`) or create by the CSV model generator (`generated`).
* All auto implemented public properties with public getters and setters on ASP.NET Core remote flow sources are now also considered to be tainted.

## 0.1.4

## 0.1.3

## 0.1.2

## 0.1.1

## 0.1.0

## 0.0.13

## 0.0.12

## 0.0.11

### Minor Analysis Improvements

* Casts to `dynamic` are excluded from the useless upcasts check (`cs/useless-upcast`).
* The C# extractor now accepts an extractor option `buildless`, which is used to decide what type of extraction that should be performed. If `true` then buildless (standalone) extraction will be performed. Otherwise tracing extraction will be performed (default).
The option is added via `codeql database create --language=csharp -Obuildless=true ...`.
* The C# extractor now accepts an extractor option `trap.compression`, which is used to decide the compression format for TRAP files. The legal values are `brotli` (default), `gzip` or `none`.
The option is added via `codeql database create --language=csharp -Otrap.compression=value ...`.

## 0.0.10

### Query Metadata Changes

* The precision of hardcoded credentials queries (`cs/hardcoded-credentials` and
`cs/hardcoded-connection-string-credentials`) have been downgraded to medium.

## 0.0.9

## 0.0.8

## 0.0.7

## 0.0.6

## 0.0.5

## 0.0.4
