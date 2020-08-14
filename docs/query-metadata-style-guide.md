# Query file metadata and alert message style guide

## Introduction

This document outlines the structure of CodeQL query files. You should adopt this structure when contributing custom queries to this repository, in order to ensure that new queries are consistent with the standard CodeQL queries.

## Query files (.ql extension)

Query files have the extension `.ql`. Each file has two distinct areas:

*   Metadata area–displayed at the top of the file, contains the metadata that defines how results for the query are interpreted and gives a brief description of the purpose of the query.
*   Query definition–defined using QL. The query includes a select statement, which defines the content and format of the results. For further information about writing QL, see the following topics:
    *   [Learning CodeQL](https://help.semmle.com/QL/learn-ql/index.html)
    *   [QL language reference](https://help.semmle.com/QL/ql-handbook/index.html)
    *   [CodeQL style guide](https://github.com/github/codeql/blob/main/docs/ql-style-guide.md) 


For examples of query files for the languages supported by CodeQL, visit the following links: 

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Go queries](https://help.semmle.com/wiki/display/GO/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

## Metadata area

Query file metadata contains important information that defines the identifier and purpose of the query. The metadata is included as the content of a valid [QLDoc](https://help.semmle.com/QL/ql-handbook/qldoc.html) comment, on lines with leading whitespace followed by `*`, between an initial `/**` and a trailing `*/`. For example:

```
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
 */
 ```

To help others use your query, and to ensure that the query works correctly on LGTM, you should include all of the required information outlined below in the metadata, and as much of the optional information as possible. For further information on query metadata see [Metadata for CodeQL queries](https://help.semmle.com/QL/learn-ql/ql/writing-queries/query-metadata.html) on help.semmle.com.




### Query name `@name`

You must specify an `@name` property for your query. This property defines the display name for the query. Query names should use sentence capitalization, but not include a full stop. For example:

*   `@name Access to variable in enclosing class`
*   `@name Array argument size mismatch`
*   `@name Reference equality test on strings`
*   `@name Return statement outside function`


### Query descriptions `@description`

You must define an `@description` property for your query. This property defines a short help message. Query descriptions should be written as a sentence or short-paragraph of plain prose, with sentence capitalization and full stop. The preferred pattern for alert queries is  "Syntax X causes behavior Y." Any code elements included in the description should be enclosed in single quotes. For example:


*   `@description Using a format string with an incorrect format causes a 'System.FormatException'.`
*   `@description Commented-out code makes the remaining code more difficult to read.`

### Query ID `@id`

You must specify an `@id` property for your query. It must be unique and should follow the standard CodeQL convention. That is, it should begin with the 'language code' for the language that the query analyzes followed by a forward slash. The following language codes are supported:

*   C and C++: `cpp`
*   C#: `cs`
*   Go: `go`
*   Java: `java`
*   JavaScript and TypeScript: `js`
*   Python: `py`

The `@id` should consist of a short noun phrase that identifies the issue that the query highlights. For example:



*   `@id cs/command-line-injection`
*   `@id java/string-concatenation-in-loop`

Further terms can be added to the `@id` to group queries that, for example, highlight similar issues or are of particular relevance to a certain framework. For example:

*   `@id js/angular-js/missing-explicit-injection`
*   `@id js/angular-js/duplicate-dependency`

Note, `@id` properties should be consistent for queries that highlight the same issue for different languages. For example, the following queries identify format strings that contain unsanitized input in Java and C++ code respectively:



*   `@id java/tainted-format-string`
*   `@id cpp/tainted-format-string`


### Query type `@kind`

`@kind` is a required property that defines the type of query. The main query types are:



*   alerts (`@kind problem`)
*   alerts containing path information (`@kind path-problem`)

Alert queries (`@kind problem` or `path-problem`) support two further properties. These are added by GitHub staff after the query has been tested, prior to deployment to LGTM. The following information is for reference:



*   `@precision`–broadly indicates the proportion of query results that are true positives, while also considering their context and relevance:
    *   `low `
    *   `medium `
    *   `high `
    *   `very-high`
*   `@problem.severity`–defines the level of severity of the alert: 
    *   `error`–an issue that is likely to cause incorrect program behavior, for example a crash or vulnerability.
    *   `warning`–an issue that indicates a potential problem in the code, or makes the code fragile if another (unrelated) part of code is changed.
    *   `recommendation`–an issue where the code behaves correctly, but it could be improved.

The values of `@precision` and `@problem.severity` assigned to a query that is part of the standard set determine how the results are displayed by LGTM. See [About alerts](https://help.semmle.com/lgtm-enterprise/user/help/about-alerts.html) and [Alert interest](https://lgtm.com/help/lgtm/alert-interest) for further information. For information about using custom queries in LGTM on a 'per-project' basis, see [Writing custom queries to include in LGTM analysis](https://lgtm.com/help/lgtm/writing-custom-queries) and [About adding custom queries](https://help.semmle.com/lgtm-enterprise/admin/help/about-adding-custom-queries.html). 

## Query tags `@tags`

The `@tags` property is used to define categories that the query relates to. Each query should belong to one (or more, if necessary) of the following four top-level categories:

*   `@tags correctness`–for queries that detect incorrect program behavior.
*   `@tags maintainability`–for queries that detect patterns that make it harder for developers to make changes to the code.
*   `@tags readability`–for queries that detect confusing patterns that make it harder for developers to read the code.
*   `@tags security`–for queries that detect security weaknesses. See below for further information.

There are also more specific `@tags` that can be added. See, the following pages for examples of the low-level tags:

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Go queries](https://help.semmle.com/wiki/display/GO/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

If necessary, you can also define your own low-level tags to categorize the queries specific to your project or organization. When creating your own tags, you should:

*   Use all lower-case letters, including for acronyms and proper nouns, with no spaces. All characters apart from * and @ are accepted.
*   Use a forward slash / to indicate a hierarchical relationship between tags if necessary. For example, a query with tag `foo/bar` is also interpreted as also having tag `foo`, but not `bar`.
*   Use a single-word `@tags` name. Multiple words, separated with hyphens, can be used for clarity if necessary. 

#### Security query `@tags`

If your query is a security query, use one or more `@tags` to associate it with the relevant CWEs. Add `@tags` for the most specific Base Weakness or Class Weakness in [View 1000](https://cwe.mitre.org/data/definitions/1000.html), using the parent/child relationship. For example:

| `@tags security` | `external/cwe/cwe-022`|
|-|-|
||`external/cwe/cwe-023` |
||`external/cwe/cwe-036` |
||`external/cwe/cwe-073` |

When you tag a query like this, the associated CWE pages from [MITRE.org](http://cwe.mitre.org/index.html) will automatically appear in the reference section of its associated qhelp file.

## QL area

### Alert messages

The select clause of each alert query defines the alert message that is displayed for each result found by the query. Alert messages are strings that concisely describe the problem that the alert is highlighting and, if possible, also provide some context. For consistency, alert messages should adhere to the following guidelines:

*   Each message should be a complete, standalone sentence. That is, it should be capitalized and have proper punctuation, including a full stop.
*   The message should factually describe the problem that is being highlighted–it should not contain recommendations about how to fix the problem or value judgements.
*   Program element references should be in 'single quotes' to distinguish them from ordinary words. Quotes are not needed around substitutions ($@).
*   Avoid constant alert message strings and include some context, if possible. For example, `The class 'Foo' is duplicated as 'Bar'.` is preferable to `This class is duplicated here.`
*   Where you reference another program element, link to it if possible using a substitution (`$@`). Links should be used inline in the sentence, rather than as parenthesised lists or appositions. 
*   When a message contains multiple links, construct a sentence that has the most variable link (that is, the link with most targets) last. For further information, see [Defining the results of a query](https://help.semmle.com/QL/learn-ql/ql/writing-queries/select-statement.html).

For examples of select clauses and alert messages, see the query source files at the following pages:

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Go queries](https://help.semmle.com/wiki/display/GO/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

For further information on query writing, see [CodeQL queries](https://help.semmle.com/QL/learn-ql/ql/writing-queries/writing-queries.html). For more information on learning CodeQL, see [Learning CodeQL](https://help.semmle.com/QL/learn-ql/index.html).
