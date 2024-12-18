.. _codeql-cli-2.15.0:

==========================
CodeQL 2.15.0 (2023-10-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.15.0 runs a total of 397 security queries when configured with the Default suite (covering 157 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed an issue with analyzing Python projects using Python 3.12.

Deprecations
~~~~~~~~~~~~

*   :code:`pragma[assume_small_delta]` is now deprecated. The pragma has no effect and should be removed.
    
*   Missing override annotations on class fields now raise errors rather than warnings. This is to avoid confusion with the shadowing behavior in the presence of final fields.
    
*   The CodeQL CLI no longer supports ML-powered alerts. For more information,
    including details of our work in the AI-powered security technology space,
    see
    "\ `CodeQL code scanning deprecates ML-powered alerts <https://github.blog/changelog/2023-09-29-codeql-code-scanning-deprecates-ml-powered-alerts/>`__."

New Features
~~~~~~~~~~~~

*   The output of :code:`codeql version --format json` now includes a :code:`features` property. Each key in the map identifies a feature of the CodeQL CLI. The value for a key is always :code:`true`. Going forward, whenever a significant new feature is added to the CodeQL CLI, a corresponding entry will be added to the
    :code:`features` map. This is intended to make it easier for tools that invoke the CodeQL CLI to know if the particular version of the CLI they are invoking supports a given feature, without having to know exactly what CLI version introduced that feature.

Improvements
~~~~~~~~~~~~

*   You can now specify the CodeQL languages C/C++, Java/Kotlin, and JavaScript/TypeScript using :code:`--language c-cpp`, :code:`--language java-kotlin`, and
    :code:`--language javascript-typescript` respectively. These new CodeQL language names convey more clearly what languages each CodeQL language will analyze.
    
    You can also reference these CodeQL languages via their secondary language names (C/C++ via :code:`--language c` or :code:`--language cpp`, Java/Kotlin via
    :code:`--language java` or :code:`--language kotlin`, and JavaScript/TypeScript via
    :code:`--language javascript` or :code:`--language typescript`), however we recommend you refer to them via the new primary CodeQL language names for improved clarity.
    
*   CodeQL now respects custom home directories set by the :code:`$HOME` environment variable on MacOS and Linux and :code:`%USERPROFILE%` on Windows. When set, CodeQL will use the variable's value to change the default location of downloaded packages and the global compilation cache.
    
*   This release improves the quality of
    \ `file coverage information <https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/about-the-tool-status-page#using-the-tool-status-page>`__ for repositories that vendor their dependencies. This is currently supported for Go and JavaScript projects.

QL Language
~~~~~~~~~~~

*   The QL language now has two new methods :code:`codePointAt` and :code:`codePointCount` on the :code:`string` type. The methods both return integers and act the same as the similarly named Java methods on strings. For example, :code:`"abc".codePointAt(2)` is :code:`99` and :code:`("a" + 128512.toUnicode() + "c").codePointAt(1)` is a :code:`128512`.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The queries :code:`cpp/double-free` and :code:`cpp/use-after-free` find fewer false positives in cases where a non-returning function is called.
*   The number of duplicated dataflow paths reported by queries has been significantly reduced.

Python
""""""

*   Improved *URL redirection from remote source* (:code:`py/url-redirection`) query to not alert when URL has been checked with :code:`django.utils.http. url_has_allowed_host_and_scheme`.
*   Extended the :code:`py/command-line-injection` query with sinks from Python's :code:`asyncio` module.

Ruby
""""

*   Built-in Ruby queries now use the new DataFlow API.

Swift
"""""

*   Adder barriers for numeric type values to the injection-like queries, to reduce false positive results where the user input that can be injected is constrainted to a numerical value. The queries updated by this change are: "Predicate built from user-controlled sources" (:code:`swift/predicate-injection`), "Database query built from user-controlled sources" (:code:`swift/sql-injection`), "Uncontrolled format string" (:code:`swift/uncontrolled-format-string`), "JavaScript Injection" (:code:`swift/unsafe-js-eval`) and "Regular expression injection" (:code:`swift/regex-injection`).
*   Added additional taint steps to the :code:`swift/cleartext-transmission`, :code:`swift/cleartext-logging` and :code:`swift/cleartext-storage-preferences` queries to identify data within sensitive containers. This is similar to an existing additional taint step in the :code:`swift/cleartext-storage-database` query.
*   Added new logging sinks to the :code:`swift/cleartext-logging` query.
*   Added sqlite3 and SQLite.swift path injection sinks for the :code:`swift/path-injection` query.

New Queries
~~~~~~~~~~~

C#
""

*   Added a new query, :code:`cs/web/insecure-direct-object-reference`, to find instances of missing authorization checks for resources selected by an ID parameter.

Python
""""""

*   The query :code:`py/nosql-injection` for finding NoSQL injection vulnerabilities is now available in the default security suite.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/double-free` query has been further improved to reduce false positives and its precision has been increased from :code:`medium` to :code:`high`.
*   The :code:`cpp/use-after-free` query has been further improved to reduce false positives and its precision has been increased from :code:`medium` to :code:`high`.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Java/Kotlin
"""""""""""

*   The regular expressions library no longer incorrectly matches mode flag characters against the input.

Python
""""""

*   Subterms of regular expressions encoded as single-line string literals now have better source-location information.

Swift
"""""

*   The regular expressions library no longer incorrectly matches mode flag characters against the input.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ruby
""""

*   Improved support for flow through captured variables that properly adheres to inter-procedural control flow.

Swift
"""""

*   The predicates :code:`getABaseType`, :code:`getABaseTypeDecl`, :code:`getADerivedType` and :code:`getADerivedTypeDecl` on :code:`Type` and :code:`TypeDecl` now behave more usefully and consistently. They now explore through type aliases used in base class declarations, and include protocols added in extensions.
    
    To examine base class declarations at a low level without these enhancements, use :code:`TypeDecl.getInheritedType`.
    
    :code:`Type.getABaseType` (only) previously resolved a type alias it was called directly on. This behaviour no longer exists. To find any base type of a type that could be an alias, the construct :code:`Type.getUnderlyingType().getABaseType*()` is recommended.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Functions that do not return due to calling functions that don't return (e.g. :code:`exit`) are now detected as non-returning in the IR and dataflow.
*   Treat functions that reach the end of the function as returning in the IR.
    They used to be treated as unreachable but it is allowed in C.
*   The :code:`DataFlow::asDefiningArgument` predicate now takes its argument from the range starting at :code:`1` instead of :code:`2`. Queries that depend on the single-parameter version of :code:`DataFlow::asDefiningArgument` should have their arguments updated accordingly.

Golang
""""""

*   Added Numeric and Boolean types to SQL injection sanitzers.

Java/Kotlin
"""""""""""

*   Fixed a control-flow bug where case rule statements would incorrectly include a fall-through edge.
*   Added support for default cases as proper guards in switch expressions to match switch statements.
*   Improved the class :code:`ArithExpr` of the :code:`Overflow.qll` module to also include compound operators. Because of this, new alerts may be raised in queries related to overflows/underflows.
*   Added new dataflow models for the Apache CXF framework.
*   Regular expressions containing multiple parse mode flags are now interpretted correctly. For example :code:`"(?is)abc.*"` with both the :code:`i` and :code:`s` flags.

Python
""""""

*   Django Rest Framework better handles custom :code:`ModelViewSet` classes functions
*   Regular expression fragments residing inside implicitly concatenated strings now have better location information.

Swift
"""""

*   Modelled varargs function in :code:`NSString` more accurately.
*   Modelled :code:`CustomStringConvertible.description` and :code:`CustomDebugStringConvertible.debugDescription`, replacing ad-hoc models of these properties on derived classes.
*   The regular expressions library now accepts a wider range of mode flags in a regular expression mode flag group (such as :code:`(?u)`). The :code:`(?w`) flag has been renamed from "UNICODE" to "UNICODEBOUNDARY", and the :code:`(?u)` flag is called "UNICODE" in the libraries.
*   Renamed :code:`TypeDecl.getBaseType/1` to :code:`getInheritedType`.
*   Flow through writes via keypaths is now supported by the data flow library.
*   Added flow through variadic arguments, and the :code:`getVaList` function.
*   Added flow steps through :code:`Dictionary` keys and values.
*   Added taint models for :code:`Numeric` conversions.

Deprecated APIs
~~~~~~~~~~~~~~~

Swift
"""""

*   The :code:`ArrayContent` type in the data flow library has been deprecated and made an alias for the :code:`CollectionContent` type, to better reflect the hierarchy of the Swift standard library. Uses of :code:`ArrayElement` in model files will be interpreted as referring to :code:`CollectionContent`.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Kotlin versions up to 1.9.20 are now supported.

Shared Libraries
----------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   Added support for type-based call edge pruning. This removes data flow call edges that are incompatible with the set of flow paths that reach it based on type information. This improves dispatch precision for constructs like lambdas, :code:`Object.toString()` calls, and the visitor pattern. For now this is only enabled for Java and C#.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The :code:`isBarrierIn` and :code:`isBarrierOut` predicates in :code:`DataFlow::StateConfigSig` now have overloaded variants that block a specific :code:`FlowState`.
