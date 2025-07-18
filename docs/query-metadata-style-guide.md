# Query file metadata and alert message style guide

## Introduction

This document outlines the structure of CodeQL query files. You should adopt this structure when contributing custom queries to this repository, in order to ensure that new queries are consistent with the standard CodeQL queries.

## Query files (.ql extension)

Query files have the extension `.ql`. Each file has two distinct areas:

* Metadata area–displayed at the top of the file, contains the metadata that defines how results for the query are interpreted and gives a brief description of the purpose of the query.
* Query definition–defined using QL. The query includes a select statement, which defines the content and format of the results. For further information about writing QL, see the following topics:
  * [CodeQL documentation](https://codeql.github.com/docs/)
  * [QL language reference](https://codeql.github.com/docs/ql-language-reference/)
  * [CodeQL style guide](ql-style-guide.md)


For examples of query files for the languages supported by CodeQL, visit the following links:

* [C/C++ queries](https://codeql.github.com/codeql-query-help/cpp/)
* [C# queries](https://codeql.github.com/codeql-query-help/csharp/)
* [GitHub Actions queries](https://codeql.github.com/codeql-query-help/actions/)
* [Go queries](https://codeql.github.com/codeql-query-help/go/)
* [Java/Kotlin queries](https://codeql.github.com/codeql-query-help/java/)
* [JavaScript queries](https://codeql.github.com/codeql-query-help/javascript/)
* [Python queries](https://codeql.github.com/codeql-query-help/python/)
* [Ruby queries](https://codeql.github.com/codeql-query-help/ruby/)
* [Rust queries](https://codeql.github.com/codeql-query-help/rust/)
* [Swift queries](https://codeql.github.com/codeql-query-help/swift/)

## Metadata area

Query file metadata contains important information that defines the identifier and purpose of the query. The metadata is included as the content of a valid [QLDoc](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#qldoc) comment, on lines with leading whitespace followed by `*`, between an initial `/**` and a trailing `*/`. For example:

```ql
/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id cs/useless-assignment-to-local
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision very-high
 * @security-severity 6.1
 */
 ```

To help others use your query, you should include all of the required information outlined below in the metadata, and as much of the optional information as possible. For further information on query metadata see [Metadata for CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/metadata-for-codeql-queries/) on codeql.github.com.

### Query name `@name`

You must specify an `@name` property for your query. This property defines the display name for the query. Query names should use sentence capitalization, but not include a full stop. For example:

* `@name Access to variable in enclosing class`
* `@name Array argument size mismatch`
* `@name Reference equality test on strings`
* `@name Return statement outside function`


### Query descriptions `@description`

You must define an `@description` property for your query. This property defines a short help message. Query descriptions should be written as a sentence or short-paragraph of plain prose, with sentence capitalization and full stop. The preferred pattern for alert queries is  "Syntax X causes behavior Y." Any code elements included in the description should be enclosed in single quotes. For example:


* `@description Using a format string with an incorrect format causes a 'System.FormatException'.`
* `@description Commented-out code makes the remaining code more difficult to read.`

### Query ID `@id`

You must specify an `@id` property for your query. It must be unique and should follow the standard CodeQL convention. That is, it should begin with the 'language code' for the language that the query analyzes followed by a forward slash. The following language codes are supported:

* C and C++: `cpp`
* C#: `cs`
* Go: `go`
* Java and Kotlin: `java`
* JavaScript and TypeScript: `js`
* Python: `py`

The `@id` should consist of a short noun phrase that identifies the issue that the query highlights. For example:



* `@id cs/command-line-injection`
* `@id java/string-concatenation-in-loop`

Further terms can be added to the `@id` to group queries that, for example, highlight similar issues or are of particular relevance to a certain framework. For example:

* `@id js/angular-js/missing-explicit-injection`
* `@id js/angular-js/duplicate-dependency`

Note, `@id` properties should be consistent for queries that highlight the same issue for different languages. For example, the following queries identify format strings that contain unsanitized input in Java and C++ code respectively:



* `@id java/tainted-format-string`
* `@id cpp/tainted-format-string`

#### Query previous ID `@previous-id`

Queries with alerts that used to be reported on a different query should also have an `@previous-id` property to refer back to the query where the alerts were originally reported. For example, if alerts from `java/query-one` are now reported on `java/query-two`, then the metadata for `java/query-two` should contain: `@previous-id java/query-one`.


### Query type `@kind`

`@kind` is a required property that defines the type of query. The main query types are:



* alerts (`@kind problem`)
* alerts containing path information (`@kind path-problem`)
* metrics (`@kind metric`)

Alert queries (`@kind problem` or `path-problem`) support two further properties. These are added by GitHub staff after the query has been tested. The following information is for reference:



* `@precision`–broadly indicates the proportion of query results that are true positives, while also considering their context and relevance:
  * `low`
  * `medium`
  * `high`
  * `very-high`
* `@problem.severity`–defines the likelihood that an alert, either security-related or not, causes an actual problem such as incorrect program behavior:
  * `error`–an issue that is likely to cause incorrect program behavior, for example a crash or vulnerability.
  * `warning`–an issue that indicates a potential problem in the code, or makes the code fragile if another (unrelated) part of code is changed.
  * `recommendation`–an issue where the code behaves correctly, but it could be improved.
* `@security-severity`-defines the level of severity, between 0.0 and 10.0, for queries with `@tags security`. For more information about how this value is calculated and then used in code scanning analysis, see [About alert severity and security severity levels](https://docs.github.com/code-security/code-scanning/managing-code-scanning-alerts/about-code-scanning-alerts#about-alert-severity-and-security-severity-levels) in the GitHub user documentation.

## Query tags `@tags`

The `@tags` property is used to define the high level category of problem that the query relates to.  Each alert query should belong to one of the following two top-level categories, with additional sub-categories:

### High level category `@tags`
* `@tags security`–for queries that detect security weaknesses. See below for further information.
* `@tags quality`–for queries that detect code quality issues. See below for further information.

#### Security query `@tags`

If your query is a security query, use one or more `@tags` to associate it with the relevant CWEs. Add `@tags` for the most specific Base Weakness or Class Weakness in [View 1000](https://cwe.mitre.org/data/definitions/1000.html), using the parent/child relationship. For example:

| `@tags security` | `external/cwe/cwe-022`|
|-|-|
||`external/cwe/cwe-023` |
||`external/cwe/cwe-036` |
||`external/cwe/cwe-073` |

When you tag a query like this, the associated CWE pages from [MITRE.org](https://cwe.mitre.org/index.html) will automatically appear in the references section of its associated qhelp file.

> [!NOTE]
> The automatic addition of CWE reference links works only if the qhelp file already contains a `<references>` section.

#### Quality query sub-category `@tags`

Each code quality related query should have **one** of these two "top-level" categories as a tag:

* `@tags maintainability`–for queries that detect patterns that make it harder for developers to make changes to the code.
* `@tags reliability`–for queries that detect issues that affect whether the code will perform as expected during execution.

In addition to the "top-level" categories, we may also add sub-categories to further group code quality related queries:

* `@tags maintainability`–for queries that detect patterns that make it harder for developers to make changes to the code.
  * `@tags readability`–for queries that detect confusing patterns that make it harder for developers to read the code.
  * `@tags useless-code`-for queries that detect functions that are never used and other instances of unused code
  * `@tags complexity`-for queries that detect patterns in the code that lead to unnecesary complexity such as unclear control flow, or high cyclomatic complexity


* `@tags reliability`–for queries that detect issues that affect whether the code will perform as expected during execution.
  * `@tags correctness`–for queries that detect incorrect program behavior or couse result in unintended outcomes.
  * `@tags performance`-for queries that detect code that could impact performance through inefficient algorithms, unnecessary computation, etc
  * `@tags concurrency`-for queries that detect concurrency related issues such as race conditions, deadlocks, thread safety, etc
  * `@tags error-handling`-for queries that detect issues related to unsafe error handling such as uncaught exceptions, etc

You may use sub-categories from both top-level categories on the same query. However, if you only use sub-categories from a single top-level category, then you must also tag the query with that top-level category.

There are also more specific `@tags` that can be added. See, the following pages for examples of the low-level tags:

* [C/C++ queries](https://codeql.github.com/codeql-query-help/cpp/)
* [C# queries](https://codeql.github.com/codeql-query-help/csharp/)
* [Go queries](https://codeql.github.com/codeql-query-help/go/)
* [Java queries](https://codeql.github.com/codeql-query-help/java/)
* [JavaScript queries](https://codeql.github.com/codeql-query-help/javascript/)
* [Python queries](https://codeql.github.com/codeql-query-help/python/)

> [!NOTE]
> There is a limit of 10 tags per query!

### Severities

Maintainers are expected to add a `@security-severity` tag to security relevant queries that will be run on Code Scanning.  There is a documented internal process for generating these `@security-severity` values.

We will use the `problem.severity` attribute to handle the severity for quality-related queries.

### Metric/summary `@tags`

Code Scanning may use tags to identify queries with specific meanings across languages. Currently, there is only one such tag: `lines-of-code`. The sum of the results for queries with this tag that return a single number column ([example for JavaScript](https://github.com/github/codeql/blob/c47d680d65f09a851e41d4edad58ffa7486b5431/java/ql/src/Metrics/Summaries/LinesOfCode.ql)) is interpreted by Code Scanning as the lines of code under the source root present in the database. Each language should have exactly one query of this form.

Metric queries (`@kind metric`) may have the `summary` tag. If SARIF output is used, the results of these queries can be found at `run[].properties.metricResults`.


### Customizing tags

If necessary, you can also define your own low-level tags to categorize the queries specific to your project or organization, but if possible, please try to follow the above standards (or propose changes to this style guide). When creating your own tags, you should:

* Use all lower-case letters, including for acronyms and proper nouns, with no spaces. All characters apart from * and @ are accepted.
* Use a forward slash / to indicate a hierarchical relationship between tags if necessary. For example, a query with tag `foo/bar` is also interpreted as also having tag `foo`, but not `bar`.
* Use a single-word `@tags` name. Multiple words, separated with hyphens, can be used for clarity if necessary.

## QL area

### Alert messages

The select clause of each alert query defines the alert message that is displayed for each result found by the query. Alert messages are strings that concisely describe the problem that the alert is highlighting and, if possible, also provide some context. For consistency, alert messages should adhere to the following guidelines:

* Each message should be a complete, standalone sentence. That is, it should be capitalized and have proper punctuation, including a full stop.
* The message should factually describe the problem that is being highlighted–it should not contain recommendations about how to fix the problem or value judgements.
* Program element references should be in 'single quotes' to distinguish them from ordinary words. Quotes are not needed around substitutions (`$@`).
* Avoid constant alert message strings and include some context, if possible. For example, `The class 'Foo' is duplicated as 'Bar'.` is preferable to `This class is duplicated here.`
* If a reference to the current location can't be avoided use "this location" instead of "here". For example, `Bad thing at this location.` is preferable to `Bad thing here.`. This avoids the "click here" anti-pattern.
* For path queries, if possible, try to follow the template: `This path depends on a [user-provided value].`, or alternatively (if the first option doesn't work) `[User-provided value] flows to this location and is used in a path.`.
* Taint tracking queries generally have a sink that "depends on" the source, and dataflow queries generally have a source that "flows to" the sink.

### Links in alert messages

* Where you reference another program element, link to it if possible using a substitution (`$@`). Links should be used inline in the sentence, rather than as parenthesised lists or appositions.
* Avoid using link texts that don't describe what they link to. For example, rewrite `This sensitive data is written to a logfile unescaped [here]` to `This sensitive data is [written to a logfile unescaped]`.
* Make link text as concise and precise as possible. For example, avoid starting a link text with an indefinite article (a, an). `Path construction depends on a [user-provided value]` is preferable to `Path construction depends on [a user-provided value]`. (Where the square brackets indicate a link.) See [the W3C guide on link texts](https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html) for further information.
* When a message contains multiple links, construct a sentence that has the most variable link (that is, the link with most targets) last. For further information, see [Defining the results of a query](https://codeql.github.com/docs/writing-codeql-queries/defining-the-results-of-a-query/).

For examples of select clauses and alert messages, see the query source files at the following pages:

* [C/C++ queries](https://codeql.github.com/codeql-query-help/cpp/)
* [C# queries](https://codeql.github.com/codeql-query-help/csharp/)
* [Go queries](https://codeql.github.com/codeql-query-help/go/)
* [Java queries](https://codeql.github.com/codeql-query-help/java/)
* [JavaScript queries](https://codeql.github.com/codeql-query-help/javascript/)
* [Python queries](https://codeql.github.com/codeql-query-help/python/)

For further information on query writing, see [CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/codeql-queries/). For more information on learning CodeQL, see [CodeQL documentation](https://codeql.github.com/docs/).

## Metric results

The `select` clause of a summary metric query must have one of the following result patterns:
- Just a `number`
  - This indicates a metric without a specific location in the codebase, for example the total lines of code in a codebase.
- A code `entity` followed by a `number`
  - This indicates a metric with a specific location in the codebase, for example the lines of code within a file. The `entity` here must have a valid location in the source code.
