.. _codeql-cli-2.12.1:

==========================
CodeQL 2.12.1 (2023-01-23)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.1 runs a total of 384 security queries when configured with the Default suite (covering 154 CWE). The Extended suite enables an additional 120 queries (covering 31 more CWE). 23 security queries have been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Added a new command-line flag :code:`--expect-discarded-cache`, which gives a hint to the evaluator that the evaluation cache will be discarded after analysis completes. This allows it to avoid some unnecessary writes to the cache, for predicates that aren't needed by the query/suite being evaluated.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/no-space-for-terminator` and :code:`cpp/uncontrolled-allocation-size` queries have been enhanced with heuristic detection of allocations. These queries now find more results.

Golang
""""""

*   Replacing "\r" or "\n" using the functions :code:`strings.ReplaceAll`, :code:`strings.Replace`, :code:`strings.Replacer.Replace` and :code:`strings.Replacer.WriteString` has been added as a sanitizer for the queries "Log entries created from user input".
*   The functions :code:`strings.Replacer.Replace` and :code:`strings.Replacer.WriteString` have been added as sanitizers for the query "Potentially unsafe quoting".

Java/Kotlin
"""""""""""

*   The name, description and alert message for the query :code:`java/concatenated-sql-query` have been altered to emphasize that the query flags the use of string concatenation to construct SQL queries, not the lack of appropriate escaping. The query's files have been renamed from :code:`SqlUnescaped.ql` and :code:`SqlUnescapedLib.qll` to :code:`SqlConcatenated.ql` and :code:`SqlConcatenatedLib.qll` respectively; in the unlikely event your custom configuration or queries refer to either of these files by name, those references will need to be adjusted. The query id remains :code:`java/concatenated-sql-query`, so alerts should not be re-raised as a result of this change.

Ruby
""""

*   The :code:`rb/unsafe-deserialization` query now recognizes input from STDIN as a source.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query :code:`java/android/websettings-allow-content-access` to detect Android WebViews which do not disable access to :code:`content://` urls.

Ruby
""""

*   Added a new query, :code:`rb/unsafe-code-construction`, to detect libraries that unsafely construct code from their inputs.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added library support for generic attributes (also for CIL extracted attributes).
*   :code:`cil.ConstructedType::getName` was changed to include printing of the type arguments.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Attributes on methods in CIL are now extracted (Bugfix).
*   Support for :code:`static virtual` and :code:`static abstract` interface members.
*   Support for *operators* in interface definitions.
*   C# 11: Added support for the unsigned right shift :code:`>>>` and unsigned right shift assignment :code:`>>>=` operators.
*   Query id's have been aligned such that they are prefixed with :code:`cs` instead of :code:`csharp`.

Java/Kotlin
"""""""""""

*   Added sink models for the constructors of :code:`org.springframework.jdbc.object.MappingSqlQuery` and :code:`org.springframework.jdbc.object.MappingSqlQueryWithParameters`.
*   Added more dataflow models for frequently-used JDK APIs.
*   Removed summary model for :code:`java.lang.String#endsWith(String)` and added neutral model for this API.
*   Added additional taint step for :code:`java.lang.String#endsWith(String)` to :code:`ConditionalBypassFlowConfig`.
*   Added :code:`AllowContentAccessMethod` to represent the :code:`setAllowContentAccess` method of the :code:`android.webkit.WebSettings` class.
*   Added an external flow source for the parameters of methods annotated with :code:`android.webkit.JavascriptInterface`.
