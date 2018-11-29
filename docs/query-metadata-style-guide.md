# Query file metadata and alert message style-guide


## Introduction

This document outlines the structure of Semmle query files. You should adopt this structure when contributing custom queries to this repository, in order to ensure that new queries are consistent with the standard Semmle queries.

## Query files (.ql extension)

Query files have the extension `.ql`. Each file has two distinct areas:

*   Metadata area–displayed at the top of the file, contains the metadata that defines how results for the query are interpreted and gives a brief description of the purpose of the query.
*   Query definition–defined using QL. The query includes a select statement, which defines the content and format of the results. For further information about writing QL, see the following topics:
    *   [Learning QL](https://help.semmle.com/wiki/display/QL/Learning+QL)
    *   [QL language handbook](https://help.semmle.com/QL/ql-handbook/index.html)
    *   [QL language specification](https://help.semmle.com/QL/QLLanguageSpecification.html)
    *   [QL style Guide](https://github.com/Semmle/ql/blob/master/docs/ql-style-guide.md) 

For examples of query files for the language supported by Semmle, see the following pages: 

*   [C/C++ queries](https://wiki.semmle.com/pages/viewpage.action?pageId=19334052)
*   [C# queries](https://wiki.semmle.com/display/CSHARP/C%23+queries)
*   [COBOL queries](https://wiki.semmle.com/display/COBOL/COBOL+queries)
*   [Java queries](https://wiki.semmle.com/display/JAVA/Java+queries)
*   [JavaScript queries](https://wiki.semmle.com/display/JS/JavaScript+queries)
*   [Python queries](https://wiki.semmle.com/display/PYTHON/Python+queries)

## Metadata area

Query file metadata contains important information which defines the name and purpose of the query. In order to help others use your query, and to ensure that the query works correctly on LGTM.com, you should include all of the required information outlined below in the metadata, and as much of the optional information as as possible. For further information on query metadata see [Query file requirements](https://help.semmle.com/wiki/display/SD/Query+file+requirements).

### Query name `@name`

You must specify an `@name` property for your query. This property defines the display name for the query. Query names should use sentence capitalization, but not include a full stop. Filter queries should specify the results that are excluded when you run the query. See the following examples for more detail:

*   `@name Access to variable in enclosing class`
*   `@name Array argument size mismatch`
*   `@name Reference equality test on strings`
*   `@name Return statement outside function`


### Query descriptions `@description`

You must define an `@description` property for your query. This property defines a short help message. Query descriptions should be written as a sentence or short-paragraph of plain prose, with sentence capitalization and full stop. The preferred pattern for alert queries is  `Syntax X causes behavior Y.` Any code elements included in the description should be enclosed in single quotes. For example:


*   `@description Using a format string with an incorrect format causes a 'System.FormatException'.`
*   `@description Commented-out code makes the remaining code more difficult to read.`

### Query ID `@id`

You must specify an `@id` property for your query. It must be unique in the Semmle namespace and should follow the standard Semmle convention. That is, it should begin with the 'language code' for the language that the query analyzes followed by a forward slash. The following language codes are supported:

*   C and C++: `cpp`
*   C#: `cs`
*   COBOL: `cobol`
*   Java: `java`
*   JavaScript and TypeScript: `js`
*   Python: `py`

The `@id` should consist of a short noun phrase that identifies the issue that the query highlights. For example:



*   `@id cs/command-line-injection`
*   `@id java/string-concatenation-in-loop`

Note, `@id` properties should be consistent for queries that highlight the same issue for different languages. For example, the following queries identify format strings which contain unsanitized input in Java and C++ code respectively:



*   `@id java/tainted-format-string`
*   `@id cpp/tainted-format-string`


### Query type `@kind`

`@kind` is a required property that defines the type of query. The main query types are:



*   alerts (`@kind problem`)
*   alerts containing path information (`@kind path-problem`)

These `@kind` properties support two further mandatory properties which are added by Semmle after the query has been tested, prior to deployment to LGTM. The following information is for reference:



*   `@precision`–broadly indicates the proportion of query results that are true positives, while also considering their context and relevance:
    *   `low `
    *   `medium `
    *   `high `
    *   `very high`
*   `@problem.severity`–defines the level of severity of the alert: 
    *   `error`–an issue that is likely to cause incorrect program behavior, for example a crash or vulnerability.
    *   `warning`–an issue that indicates a potential problem in the code, or makes the code fragile if another (unrelated) part of code is changed.
    *   `recommendation`–an issue that results in code that is hard to read, but is otherwise correct.

The values of `@precision` and `@problem.severity` assigned to a query that is part of the standard set determine how the results are displayed by LGTM. See [About alerts](https://help.semmle.com/lgtm-enterprise/user/help/about-alerts.html) and [Alert interest](https://lgtm.com/help/lgtm/alert-interest) for further information. For information about using custom queries in LGTM on a 'per-project' basis, see [Writing custom queries to include in LGTM analysis](https://lgtm.com/help/lgtm/writing-custom-queries) and [About adding custom queries](https://help.semmle.com/lgtm-enterprise/admin/help/about-adding-custom-queries.html). 

## Query tags `@tags`

The `@tags` property is used to define categories that the query relates to. Each query should belong to one (or more, if necessary) of the following four top-level categories:

*   `@tags correctness`–for queries that detect common coding mistakes.
*   `@tags maintainability`–for queries that detect opportunities for structural improvement.
*   `@tags readability`–for queries that detect confusing or dangerous patterns that make it harder for developers to make correct changes to code.
*   `@tags security`–for queries that detect security weaknesses. See below for further information.

There are also more specific `@tags` that can be specified. See, the following pages for more information on the low-level tags:

*   [C/C++ queries](https://wiki.semmle.com/pages/viewpage.action?pageId=19334052)
*   [C# queries](https://wiki.semmle.com/display/CSHARP/C%23+queries)
*   [COBOL queries](https://wiki.semmle.com/display/COBOL/COBOL+queries)
*   [Java queries](https://wiki.semmle.com/display/JAVA/Java+queries)
*   [JavaScript queries](https://wiki.semmle.com/display/JS/JavaScript+queries)
*   [Python queries](https://wiki.semmle.com/display/PYTHON/Python+queries)

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

When you tag a query like this, the associated CWE pages from [MITRE.org](http://cwe.mitre.org/index.html) will automatically appear in the reference section of its associated qhelp file. For more information on qhelp files, see [Query help style guide](https://docs.google.com/document/d/14E-bne3sO3boo0jbmD68XMdTZknN5dXSTXBGQeAfj6A/edit#).

## QL area

### Alert  messages

You must define an message in the select clause of an alert query to display with your results. Alert messages are strings that concisely describe the problem that the alert is highlighting and, if possible, also provide some context. For consistency, alert messages should adhere to the following guidelines:

*   Each message should be a complete, standalone sentence. That is, it should be capitalized and have proper punctuation, including a full stop.
*   The message should factually describe the problem that is being highlighted–they should not contain recommendations about how to fix the problem or value judgements.
*   Program element references should be in 'single quotes' to distinguish them from ordinary words. Quotes are not needed around substitutions ($@).
*   Avoid constant alert message strings and include some context, if possible. For example, `The class 'Foo' is duplicated as 'Bar'.` is preferable to `This class is duplicated here.`
*   Where you reference another program element, link to it if possible using a substitution (`$@`). Links should be used inline in the sentence, rather than as parenthesised lists or appositions.
*   When a message contains multiple links, construct a sentence that has the most variable link (that is, the link with most targets) last.

See the query homepages for examples of alert messages.

For further information on query writing, see  [Writing QL queries](https://lgtm.com/help/ql/writing-queries/writing-queries). For more information on learning QL, see [Learning QL](https://lgtm.com/help/lgtm/ql/learning-ql).
