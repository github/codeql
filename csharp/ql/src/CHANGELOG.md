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
