.. _codeql-cli-2.24.0:

==========================
CodeQL 2.24.0 (2026-01-26)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.24.0 runs a total of 491 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE).

CodeQL CLI
----------

Miscellaneous
~~~~~~~~~~~~~

*   The OWASP Java HTML Sanitizer library used by the CodeQL CLI for internal documentation generation commands has been updated to version
    \ `20260102.1 <https://github.com/OWASP/java-html-sanitizer/releases/tag/release-20260102.1>`__.
*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.9.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   JavaScript files with an average line length greater than 200 are now considered minified and will no longer be analyzed.
    For use-cases where minified files should be analyzed, the original behavior can be restored by setting the environment variable
    :code:`CODEQL_EXTRACTOR_JAVASCRIPT_ALLOW_MINIFIED_FILES=true`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/constant-comparison` query has been updated to not produce false positives for constants that are now represented by their unfolded expression trees.

C#
""

*   Added :code:`NHibernate.ISession.CreateSQLQuery`, :code:`NHibernate.IStatelessSession.CreateSQLQuery` and :code:`NHibernate.Impl.AbstractSessionImpl.CreateSQLQuery` as SQL injection sinks.
*   The :code:`Missing cross-site request forgery token validation` query was extended to support ASP.NET Core.

Java/Kotlin
"""""""""""

*   Added sink models for :code:`com.couchbase` supporting SQL Injection and Hardcoded Credentials queries.
*   Java thread safety analysis now understands initialization to thread safe classes inside constructors.

JavaScript/TypeScript
"""""""""""""""""""""

*   The model of :code:`vue-router` now properly detects taint sources in cases where the :code:`props` property is a callback.
*   Fixed a bug in the Next.js model that would cause the analysis to miss server-side taint sources in files named :code:`route` or :code:`page` appearing outside :code:`api` and :code:`pages` folders.
*   :code:`new Response(x)` is no longer seen as a reflected XSS sink when no :code:`content-type` header is set, since the content type defaults to :code:`text/plain`.

Rust
""""

*   Fixed common false positives for the :code:`rust/unused-variable` and :code:`rust/unused-value` queries.
*   Fixed false positives from the :code:`rust/access-invalid-pointer` query, by only considering dereferences of raw pointers as sinks.
*   Fixed false positives from the :code:`rust/access-after-lifetime-ended` query, involving calls to trait methods.
*   The :code:`rust/hard-coded-cryptographic-value` query has been extended with new heuristic sinks identifying passwords, initialization vectors, nonces and salts.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Updated the :code:`name`, :code:`description`, and alert message of :code:`cs/path-combine` to have more details about why it's a problem.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Fixed a bug in the :code:`DataFlow::BarrierGuard<...>::getABarrierNode` predicate which caused the predicate to return :code:`DataFlow::Node`\ s with incorrect indirections. If you use :code:`getABarrierNode` to implement barriers in a dataflow/taint-tracking query it may result in more query results. You can use :code:`DataFlow::BarrierGuard<...>::getAnIndirectBarrierNode` to remove those query results.

C#
""

*   Fixed two issues affecting build mode :code:`none`\ :

    *   Corrected version sorting logic when detecting the newest .NET framework to use.
    *   Improved stability for .NET 10 compatibility.
    
*   Fixed an issue where compiler-generated files were not being extracted. The extractor now runs after compilation completes to ensure all generated files are properly analyzed.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`_Decimal32`, :code:`_Decimal64`, and :code:`_Decimal128` types are no longer exposed as builtin types. Support for these gcc-specific types was incomplete, and are generally not used in C/C++ codebases.

Golang
""""""

*   The query :code:`go/unexpected-frontend-error` has been moved from the :code:`codeql/go-queries` query to the :code:`codeql-go-consistency-queries` query pack.

Python
""""""

*   All modules that depend on the points-to analysis have now been removed from the top level :code:`python.qll` module. To access the points-to functionality, import the new :code:`LegacyPointsTo` module. This also means that some predicates have been removed from various classes, for instance :code:`Function.getFunctionObject()`. To access these predicates, import the :code:`LegacyPointsTo` module and use the :code:`FunctionWithPointsTo` class instead. Most cases follow this pattern, but there are a few exceptions:

    *   The :code:`getLiteralObject` method on :code:`ImmutableLiteral` subclasses has been replaced with a predicate :code:`getLiteralObject(ImmutableLiteral l)` in the :code:`LegacyPointsTo` module.
    *   The :code:`getMetrics` method on :code:`Function`, :code:`Class`, and :code:`Module` has been removed. To access metrics, import :code:`LegacyPointsTo` and use the classes :code:`FunctionMetrics`, etc. instead.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.2.3.
*   Upgraded to allow analysis of Swift 6.2.2.

GitHub Actions
""""""""""""""

*   The query :code:`actions/code-injection/medium` has been updated to include results which were incorrectly excluded while filtering out results that are reported by :code:`actions/code-injection/critical`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Some constants will now be represented by their unfolded expression trees. The :code:`isConstant` predicate of :code:`Expr` will no longer yield a result for those constants.

C#
""

*   When a code-scanning configuration specifies the :code:`paths:` and/or :code:`paths-ignore:` settings, these are now taken into account by the C# extractor's search for :code:`.config`, :code:`.props`, XML and project files.
*   Updated the generated .NET “models as data” runtime models to cover .NET 10.
*   C# 14: Support for *implicit* span conversions in the QL library.
*   Basic extractor support for .NET 10 is now available. Extraction is supported for .NET 10 projects in both traced mode and :code:`build mode: none`. However, code that uses language features new to C# 14 is not yet fully supported for extraction and analysis.
*   Added autobuilder and :code:`build-mode: none` support for :code:`.slnx` solution files.
*   In :code:`build mode: none`, .NET 10 is now used by default unless a specific .NET version is specified elsewhere.
*   Added implicit reads of :code:`System.Collections.Generic.KeyValuePair.Value` at taint-tracking sinks and at inputs to additional taint steps. As a result, taint-tracking queries will now produce more results when a container is tainted.

Golang
""""""

*   When a code-scanning configuration specifies the :code:`paths:` and/or :code:`paths-ignore:` settings, these are now taken into account by the Go extractor's search for :code:`.vue` and HTML files.

Java/Kotlin
"""""""""""

*   When a code-scanning configuration specifies the :code:`paths:` and/or :code:`paths-ignore:` settings, these are now taken into account by the Java extractor's search for XML and properties files.
*   Additional remote flow sources from the :code:`org.springframework.web.socket` package have been modeled.
*   A sanitizer has been added to :code:`java/ssrf` to remove alerts when a regular expression check is used to verify that the value is safe.
*   URI template variables of all Spring :code:`RestTemplate` methods are now considered as request forgery sinks. Previously only the :code:`getForObject` method was considered. This may lead to more alerts for the query :code:`java/ssrf`.
*   Added more dataflow models of :code:`org.apache.commons.fileupload.FileItem`, :code:`javax/jakarta.servlet.http.Part` and  :code:`org.apache.commons.fileupload.util.Streams`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Support :code:`use cache` directives for Next.js 16.
*   Added :code:`PreCallGraphStep` flow model for React's :code:`useRef` hook.
*   Added a :code:`DomValueSource` that uses the :code:`current` property off the object returned by React's :code:`useRef` hook.

Python
""""""

*   When a code-scanning configuration specifies the :code:`paths:` and/or :code:`paths-ignore:` settings, these are now taken into account by the Python extractor's search for YAML files.
*   The :code:`compression.zstd` library (added in Python 3.14) is now supported by the :code:`py/decompression-bomb` query.
*   Added taint flow model and type model for :code:`urllib.parse`.
*   Remote flow sources for the :code:`python-socketio` package have been modeled.
*   Additional models for remote flow sources for :code:`tornado.websocket.WebSocketHandler` have been added.

Rust
""""

*   The :code:`Deref` trait is now considered during method resolution. This means that method calls on receivers implementing the :code:`Deref` trait will correctly resolve to methods defined on the target type. This may result in additional query results, especially for data flow queries.
*   Renamed the :code:`Adt` class to :code:`TypeItem` and moved common predicates from :code:`Struct`, :code:`Enum`, and :code:`Union` to :code:`TypeItem`.
*   Added models for the Axum web application framework.
*   Reading content of a value now carries taint if the value itself is tainted. For instance, if :code:`s` is tainted then :code:`s.field` is also tainted. This generally improves taint flow.
*   The call graph is now more precise for calls that target a trait function with a default implementation. This reduces the number of false positives for data flow queries.
*   Improved type inference for raw pointers (:code:`*const` and :code:`*mut`). This includes type inference for the raw borrow operators (:code:`&raw const` and :code:`&raw mut`) and dereferencing of raw pointers.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`OverloadedArrayExpr::getArrayOffset/0` predicate has been deprecated. Use :code:`OverloadedArrayExpr::getArrayOffset/1` and :code:`OverloadedArrayExpr::getAnArrayOffset` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added subclasses of :code:`BuiltInOperations` for the :code:`__is_bitwise_cloneable`, :code:`__is_invocable`, and :code:`__is_nothrow_invocable` builtin operations.
*   Added a :code:`isThisAccess` predicate to :code:`ParamAccessForType` that holds when the access is to the implicit object parameter.
*   Predicates :code:`getArrayOffset/1` and :code:`getAnArrayOffset` have been added to the :code:`OverloadedArrayExpr` class to support C++23 multidimensional subscript operators.

Python
""""""

*   The extractor now supports the new, relaxed syntax :code:`except A, B, C: ...` (which would previously have to be written as :code:`except (A, B, C): ...`) as defined in `PEP-758 <https://peps.python.org/pep-0758/>`__. This may cause changes in results for code that uses Python 2-style exception binding (:code:`except Foo, e: ...`). The more modern format, :code:`except Foo as e: ...` (available since Python 2.6) is unaffected.
*   The Python extractor now supports template strings as defined in `PEP-750 <https://peps.python.org/pep-0750/>`__, through the classes :code:`TemplateString` and :code:`JoinedTemplateString`.
