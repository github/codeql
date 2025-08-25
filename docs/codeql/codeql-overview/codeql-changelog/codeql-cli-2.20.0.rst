.. _codeql-cli-2.20.0:

==========================
CodeQL 2.20.0 (2024-12-09)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.20.0 runs a total of 432 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   The |link-code-QlBuiltins-BigInt-type-1|_ of arbitrary precision integers is generally available and no longer hidden behind the
    :code:`--allow-experimental=bigint` CLI feature flag.

Known Issues
~~~~~~~~~~~~

*   The Windows executable for this release is labeled with an incorrect version number within its properties: the version number should be 2.20.0 rather than 2.19.4.
    :code:`codeql version` reports the correct version number.

Miscellaneous
~~~~~~~~~~~~~

*   Backslashes are now escaped when writing output in the Graphviz DOT format (:code:`--format=dot`).
*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.5.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Call to function with fewer arguments than declared parameters" query (:code:`cpp/too-few-arguments`) no longer produces results if the function has been implicitly declared.

C#
""

*   :code:`csharp/diagnostic/database-quality` has been changed to exclude various property access expressions from database quality evaluation. The excluded property access expressions are expected to have no target callables even in manual or autobuilt databases.

Golang
""""""

*   Added value flow models for functions in the :code:`slices` package which do not involve the :code:`iter` package.

Java/Kotlin
"""""""""""

*   Added SHA-384 to the list of secure hashing algorithms. As a result the :code:`java/potentially-weak-cryptographic-algorithm` query should no longer flag up uses of SHA-384.
*   Added SHA3 to the list of secure hashing algorithms. As a result the :code:`java/potentially-weak-cryptographic-algorithm` query should no longer flag up uses of SHA3.
*   The :code:`java/weak-cryptographic-algorithm` query has been updated to no longer report uses of hash functions such as :code:`MD5` and :code:`SHA1` even if they are known to be weak. These hash algorithms are used very often in non-sensitive contexts, making the query too imprecise in practice. The :code:`java/potentially-weak-cryptographic-algorithm` query has been updated to report these uses instead.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new high-precision quality query, :code:`cpp/guarded-free`, which detects useless NULL pointer checks before calls to :code:`free`. A variation of this query was originally contributed as an `experimental query by @mario-campos <https://github.com/github/codeql/pull/16331>`__.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   Fixed a bug which meant that promoted fields and methods were missing when the embedded parent was not promoted due to a name clash.

Python
""""""

*   Fixed a problem with the control-flow graph construction, where writing :code:`case True:` or :code:`case False:` would cause parts of the graph to be pruned by mistake.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

C#
""

*   Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

Golang
""""""

*   Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

Java/Kotlin
"""""""""""

*   Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

Python
""""""

*   Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

Ruby
""""

*   Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

Swift
"""""

*   Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/incomplete-sanitization` query now also checks regular expressions constructed using :code:`new RegExp(..)`. Previously it only checked regular expression literals.
*   Regular expression-based sanitisers implemented with :code:`new RegExp(..)` are now detected in more cases.
*   Regular expression related queries now account for unknown flags.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added support for data-flow through member accesses of objects with :code:`dynamic` types.
*   Only extract *public* and *protected* members from reference assemblies. This yields an approximate average speed-up of around 10% for extraction and query execution. Custom MaD rows using :code:`Field`\ -based summaries may need to be changed to :code:`SyntheticField`\ -based flows if they reference private fields.
*   Added :code:`Microsoft.AspNetCore.Components.NagivationManager::Uri` as a remote flow source, since this value may contain user-specified values.
*   Added the following URI-parsing methods as summaries, as they may be tainted with user-specified values:

    *   :code:`System.Web.HttpUtility::ParseQueryString`
    *   :code:`Microsoft.AspNetCore.WebUtilities.QueryHelpers::ParseQuery`
    *   :code:`Microsoft.AspNetCore.WebUtilities.QueryHelpers::ParseNullableQuery`
    
*   Added :code:`js-interop` sinks for the :code:`InvokeAsync` and :code:`InvokeVoidAsync` methods of :code:`Microsoft.JSInterop.IJSRuntime`, which can run arbitrary JavaScript.

Golang
""""""

*   A call to a method whose name starts with "Debug", "Error", "Fatal", "Info", "Log", "Output", "Panic", "Print", "Trace", "Warn" or "With" defined on an interface whose name ends in "logger" or "Logger" is now considered a LoggerCall. In particular, it is a sink for :code:`go/clear-text-logging` and :code:`go/log-injection`. This may lead to some more alerts in those queries.

Java/Kotlin
"""""""""""

*   Calling :code:`coll.contains(x)` is now a taint sanitizer (for any query) for the value :code:`x`, where :code:`coll` is a collection of constants.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added taint-steps for :code:`String.prototype.toWellFormed`.
*   Added taint-steps for :code:`Map.groupBy` and :code:`Object.groupBy`.
*   Added taint-steps for :code:`Array.prototype.findLast`.
*   Added taint-steps for :code:`Array.prototype.findLastIndex`.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`NonThrowingFunction` class (:code:`semmle.code.cpp.models.interfaces.NonThrowing.NonThrowingFunction`) has been deprecated. Please use the :code:`NonCppThrowingFunction` class instead.

Shared Libraries
----------------

Breaking Changes
~~~~~~~~~~~~~~~~

Utility Classes
"""""""""""""""

*   Deleted the old deprecated inline expectation test API that was based on the :code:`InlineExpectationsTest` class.

.. |link-code-QlBuiltins-BigInt-type-1| replace:: :code:`QlBuiltins::BigInt` type
.. _link-code-QlBuiltins-BigInt-type-1: https://codeql.github.com/docs/ql-language-reference/modules/#bigint

