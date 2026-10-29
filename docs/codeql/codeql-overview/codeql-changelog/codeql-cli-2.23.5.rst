.. _codeql-cli-2.23.5:

==========================
CodeQL 2.23.5 (2025-11-13)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.5 runs a total of 483 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   In order to make a :code:`@kind path-problem` query diff-informed, the :code:`getASelectedSourceLocation` and :code:`getASelectedSinkLocation` predicates in the dataflow configuration now need to be overridden to always return the location of the source/sink *in addition to* any other locations that are selected by the query. See the `QLdoc <https://github.com/github/codeql/blob/d122534398c5eb9182a23a9ad65caa5937d627b5/shared/dataflow/codeql/dataflow/DataFlow.qll#L474>`__ for more details.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`cs/web/missing-x-frame-options` query now correctly handles configuration nested in root :code:`<location>` elements.

Java/Kotlin
"""""""""""

*   Calls to :code:`String.matches` are now treated as sanitizers for the :code:`java/ssrf` query.

Python
""""""

*   The :code:`py/insecure-cookie` query has been split into multiple queries; with :code:`py/insecure-cookie` checking for cases in which :code:`Secure` flag is not set, :code:`py/client-exposed-cookie` checking for cases in which the :code:`HttpOnly` flag is not set, and the :code:`py/samesite-none` query checking for cases in which the :code:`SameSite` attribute is set to :code:`None`. These queries also now only alert for cases in which the cookie is detected to contain sensitive data.

Rust
""""

*   The "Low Rust analysis quality" query (:code:`rust/diagnostic/database-quality`), used by the tool status page, has been extended with a measure of successful type inference.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`java/sensitive-cookie-not-httponly` query has been promoted from experimental to the main query pack.
*   Added a new query, :code:`java/escaping`, to detect values escaping from classes marked as :code:`@ThreadSafe`.
*   Added a new query, :code:`java/not-threadsafe`, to detect data races in classes marked as :code:`@ThreadSafe`.
*   Added a new query, :code:`java/safe-publication`, to detect unsafe publication in classes marked as :code:`@ThreadSafe`.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Swift
"""""

*   The :code:`OpenedArchetypeType` class has been renamed as :code:`ExistentialArchetypeType`.
*   The :code:`OtherAvailabilitySpec` class has been removed. Use :code:`AvailabilitySpec::isWildcard` instead.
*   The :code:`PlatformVersionAvailabilitySpec` has been removed. Use :code:`AvailabilitySpec::getPlatform` and :code:`AvailabilitySpec::getVersion` instead.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The representation of the C# control-flow graph has been significantly changed. This has minor effects on a wide range of queries including both minor improvements and minor regressions. For example, improved precision has been observed for :code:`cs/inefficient-containskey` and :code:`cs/stringbuilder-creation-in-loop`. Two queries stand out as being significantly affected with great improvements: :code:`cs/dereferenced-value-may-be-null` has been completely rewritten which removes a very significant number of false positives. Furthermore, :code:`cs/constant-condition` has been updated to report many new results - these new results are primarily expected to be true positives, but a few new false positives are expected as well. As part of these changes, :code:`cs/dereferenced-value-may-be-null` has been changed from a :code:`path-problem` query to a :code:`problem` query, so paths are no longer reported for this query.

Swift
"""""

*   Upgraded to allow analysis of Swift 6.2.
*   Support for experimental Embedded Swift has been dropped.

Rust
""""

*   Resolution of calls to functions has been improved in a number of ways, to make it more aligned with the behavior of the Rust compiler. This may impact queries that rely on call resolution, such as data flow queries.
*   Added basic models for the :code:`actix-web` web framework.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added tracer support for macOS and Linux when the .NET CLI (:code:`dotnet`) directly invokes the C# compiler (:code:`csc`). This enhancement provides basic tracing and extraction capabilities for .NET 10 RC2 on these platforms.
*   The extraction of location information for source code entities has been updated to use star IDs (:code:`*` IDs). This change should be transparent to end-users but may improve extraction performance in some cases by reducing TRAP file size and eliminating overhead from location de-duplication.

Rust
""""

*   Added :code:`ExtractedFile::hasSemantics` and :code:`ExtractedFile::isSkippedByCompilation` predicates.
*   Generalized some existing models to improve data flow.
*   Added models for the :code:`mysql` and :code:`mysql_async` libraries.

Deprecated APIs
~~~~~~~~~~~~~~~

C#
""

*   The class :code:`AbstractValue` in the :code:`Guards` library has been deprecated and replaced with the class :code:`GuardValue`.

New Features
~~~~~~~~~~~~

Python
""""""

*   Initial support for incremental Python databases via :code:`codeql database create --overlay-base`\ /\ :code:`--overlay-changes`.

Swift
"""""

*   Added AST nodes :code:`UsingDecl`, :code:`UnsafeExpr`, and :code:`InlineArrayType` that correspond to new nodes in Swift 6.2.
*   Added new predicates :code:`isDistributedGet`, :code:`isRead2`, :code:`isModify2`, and :code:`isInit` to the :code:`Accessor` class that correspond to new accessors in Swift 6.2.
*   Added a new predicate :code:`isApply` to the :code:`KeyPathComponent` class that corresponds to method and initializer key path components in Swift 6.2.
