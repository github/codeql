## 1.3.4

No user-facing changes.

## 1.3.3

No user-facing changes.

## 1.3.2

No user-facing changes.

## 1.3.1

### Minor Analysis Improvements

* Explicitly added summary models for all overloads of `System.Xml.XmlDictionaryReader.CreateBinaryReader`. Added models for some of the methods and properties in `System.Runtime.Serialization.SerializationInfo` and `System.Runtime.Serialization.SerializationInfoEnumerator`. Updated models for `System.Text.Encoding.GetBytes`, `System.Text.Encoding.GetChars` and the constructor for `System.IO.MemoryStream`. This generally improves the library modelling and thus reduces the number of false negatives.
* Added explicit SQL injection Models as Data models for `Microsoft.Data.SqlClient.SqlCommand` and `Microsoft.Data.SqlClient.SqlDataAdapter`. This reduces false negatives for the query `cs/sql-injection`.

### Bug Fixes

* `web.config` and `web.release.config` files are now recognized regardless of case. This means queries `cs/web/debug-binary` and `cs/web/missing-x-frame-options` may produce more results than before.

## 1.3.0

### Query Metadata Changes

* Query metadata tags have been systematically updated for many C# queries. Primary categorization as either `reliability` or `maintainability`, and relevant sub-category tags such as `readability`, `useless-code`, `complexity`, `performance`, `correctness`, `error-handling`, and `concurrency`. Aligns with the established [Query file metadata and alert message style guide](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags).
* Adjusts the `@security-severity` from 9.3 to 7.3 for `cs/uncontrolled-format-string` to align `CWE-134` severity for memory safe languages to better reflect their impact.

### Minor Analysis Improvements

* The queries `cs/dereferenced-value-is-always-null` and `cs/dereferenced-value-may-be-null` have been improved to reduce false positives. The queries no longer assume that expressions are dereferenced when passed as the receiver (`this` parameter) to extension methods where that parameter is a nullable type.

## 1.2.2

No user-facing changes.

## 1.2.1

### Minor Analysis Improvements

* The precision of the query `cs/missed-readonly-modifier` has been improved. Some false positives related to static fields and struct type fields have been removed.
* The queries `cs/password-in-configuration`, `cs/hardcoded-credentials` and `cs/hardcoded-connection-string-credentials` have been removed from all query suites.
* The precision of the query `cs/gethashcode-is-not-defined` has been improved (false negative reduction). Calls to more methods (and indexers) that rely on the invariant `e1.Equals(e2)` implies `e1.GetHashCode() == e2.GetHashCode()` are taken into account.
* The precision of the query `cs/uncontrolled-format-string` has been improved (false negative reduction). Calls to `System.Text.CompositeFormat.Parse` are now considered a format like method call.

## 1.2.0

### Query Metadata Changes

* The tag `external/cwe/cwe-13` has been removed from `cs/password-in-configuration` and the tag `external/cwe/cwe-013` has been added.
* The tag `external/cwe/cwe-11` has been removed from `cs/web/debug-binary` and the tag `external/cwe/cwe-011` has been added.
* The tag `external/cwe/cwe-16` has been removed from `cs/web/large-max-request-length` and the tag `external/cwe/cwe-016` has been added.
* The tag `external/cwe/cwe-16` has been removed from `cs/web/request-validation-disabled` and the tag `external/cwe/cwe-016` has been added.
* The tag `external/cwe/cwe-20` has been removed from `cs/count-untrusted-data-external-api` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `cs/serialization-check-bypass` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `cs/untrusted-data-to-external-api` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-12` has been removed from `cs/web/missing-global-error-handler` and the tag `external/cwe/cwe-012` has been added.

### Minor Analysis Improvements

* Changed the precision of the `cs/equality-on-floats` query from medium to high.

## 1.1.2

### Minor Analysis Improvements

* Changes to the MaD model generation infrastructure:
  * Changed the query `cs/utils/modelgenerator/summary-models` to use the implementation from `cs/utils/modelgenerator/mixed-summary-models`.
  * Removed the now-redundant `cs/utils/modelgenerator/mixed-summary-models` query.
  * A similar replacement was made for `cs/utils/modelgenerator/neutral-models`. That is, if `GenerateFlowModel.py` is provided with `--with-summaries`, combined/mixed models are now generated instead of heuristic models (and similar for `--with-neutrals`).
* Improved detection of authorization checks in the `cs/web/missing-function-level-access-control` query. The query now recognizes authorization attributes inherited from base classes and interfaces.
* The precision of the query `cs/invalid-string-formatting` has been improved. More methods and more overloads of existing format like methods are taken into account by the query.

## 1.1.1

### Minor Analysis Improvements

* Enums and `System.DateTimeOffset` are now treated as *simple* types, which means that they are considered to have a sanitizing effect. This impacts many queries, among others the `cs/log-forging` query.
* The MaD models for the .NET 9 Runtime have been re-generated after a fix related to `out`/`ref` parameters.

## 1.1.0

### New Queries

* Added a new query, `csharp/path-combine`, to recommend against the `Path.Combine` method due to it silently discarding its earlier parameters if later parameters are rooted.

### Minor Analysis Improvements

* Improved dependency resolution in `build-mode: none` extraction to handle failing `dotnet restore` processes that managed to download a subset of the dependencies before the failure.
* Increase query precision for `cs/useless-gethashcode-call` by not flagging calls to `GetHashCode` on `uint`, `long` and `ulong`.
* Increase query precision for `cs/constant-condition` and allow the use of discards in switch/case statements and also take the condition (if any) into account.
* The `cs/local-not-disposed` query no longer flags un-disposed tasks as this is often not needed (explained [here](https://devblogs.microsoft.com/pfxteam/do-i-need-to-dispose-of-tasks/)).
* Increase query precision for `cs/useless-assignment-to-local` and `cs/constant-condition` when *unknown* types are involved (mostly relevant for `build-mode: none` databases).
* Don't consider an if-statement to be *useless* in `cs/useless-if-statement` if there is at least a comment.

## 1.0.19

No user-facing changes.

## 1.0.18

### Minor Analysis Improvements

* C#: Improve precision of the query `cs/call-to-object-tostring` for value tuples.

## 1.0.17

No user-facing changes.

## 1.0.16

### Minor Analysis Improvements

* All *experimental* queries have been deprecated. The queries are instead available as part of the *default* query suite in [CodeQL-Community-Packs](https://github.com/GitHubSecurityLab/CodeQL-Community-Packs).

## 1.0.15

No user-facing changes.

## 1.0.14

### Minor Analysis Improvements

* The `ExternalApi` and `TestLibrary` modules have been moved to the library pack.

## 1.0.13

### Minor Analysis Improvements

* `csharp/diagnostic/database-quality` has been changed to exclude various property access expressions from database quality evaluation. The excluded property access expressions are expected to have no target callables even in manual or autobuilt databases.

## 1.0.12

No user-facing changes.

## 1.0.11

### Minor Analysis Improvements

* C#: The method `string.ReplaceLineEndings(string)` is now considered a sanitizer for the `cs/log-forging` query. 

## 1.0.10

No user-facing changes.

## 1.0.9

### Minor Analysis Improvements

* C#: The indexer and `Add` method on `System.Web.UI.AttributeCollection` is no longer considered an HTML sink.

## 1.0.8

No user-facing changes.

## 1.0.7

No user-facing changes.

## 1.0.6

### Minor Analysis Improvements

* Attributes in the `System.Runtime.CompilerServices` namespace are ignored when checking if a declaration requires documentation comments.
* C# build-mode `none` analyses now report a warning on the CodeQL status page when there are significant analysis problems -- defined as 5% of expressions lacking a type, or 5% of call targets being unknown. Other messages reported on the status page are downgraded from warnings to notes and so are less prominent, but are still available for review.

## 1.0.5

No user-facing changes.

## 1.0.4

No user-facing changes.

## 1.0.3

No user-facing changes.

## 1.0.2

No user-facing changes.

## 1.0.1

### Minor Analysis Improvements

* .NET 8 Runtime models have been updated based on the newest version of the model generator. Furthermore, the database sources have been changed slightly to reduce result multiplicity.

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
