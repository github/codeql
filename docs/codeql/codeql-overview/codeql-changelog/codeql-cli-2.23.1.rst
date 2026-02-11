.. _codeql-cli-2.23.1:

==========================
CodeQL 2.23.1 (2025-09-23)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.1 runs a total of 478 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   CodeQL now adds the sources and sinks of path alerts to the :code:`relatedLocations` property of SARIF results if they are not included as the primary location or within the alert message. This means that path alerts will show on PRs if a source or sink is added or modified, even for queries that don't follow the common convention of selecting the sink as the primary location and mentioning the source in the alert message.
    
*   CodeQL now populates file coverage information for GitHub Actions on
    \ `the tool status page for code scanning <https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/about-the-tool-status-page#viewing-the-tool-status-page-for-a-repository>`__.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   The predicate :code:`occurenceCount` in the file module :code:`MagicConstants` has been deprecated. Use :code:`occurrenceCount` instead.
*   The predicate :code:`additionalAdditionOrSubstractionCheckForLeapYear` in the file module :code:`LeapYear` has been deprecated. Use :code:`additionalAdditionOrSubtractionCheckForLeapYear` instead.

C#
""

*   The message for :code:`csharp/diagnostic/database-quality` has been updated to include detailed database health metrics. Additionally, the threshold for reporting database health issues has been lowered from 95% to 85% (if any metric falls below this percentage). These changes are visible on the tool status page.

Java/Kotlin
"""""""""""

*   The message for :code:`java/diagnostic/database-quality` has been updated to include detailed database health metrics. Additionally, the threshold for reporting database health issues has been lowered from 95% to 85% (if any metric falls below this percentage). These changes are visible on the tool status page.

Rust
""""

*   The message for :code:`rust/diagnostic/database-quality` has been updated to include detailed database health metrics. These changes are visible on the tool status page.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The queries :code:`cpp/wrong-type-format-argument`, :code:`cpp/comparison-with-wider-type`, :code:`cpp/integer-multiplication-cast-to-long`, :code:`cpp/implicit-function-declaration` and :code:`cpp/suspicious-add-sizeof` have had their precisions reduced from :code:`high` to :code:`medium`. They will also now give alerts for projects built with :code:`build-mode: none`.
*   The queries :code:`cpp/wrong-type-format-argument`, :code:`cpp/comparison-with-wider-type`, :code:`cpp/integer-multiplication-cast-to-long` and :code:`cpp/suspicious-add-sizeof` are no longer included in the :code:`code-scanning` suite.

Java/Kotlin
"""""""""""

*   The implementation of :code:`java/dereferenced-value-may-be-null` has been completely replaced with a new general control-flow reachability library. This improves precision by reducing false positives. However, since the entire calculation has been reworked, there can be small corner cases where precision regressions might occur and new false positives may occur, but these cases should be rare.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 5.9
*   Added support for :code:`import defer` syntax in JavaScript and TypeScript.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The query :code:`cs/call-to-object-tostring` has been improved to remove false positives for enum types.

JavaScript/TypeScript
"""""""""""""""""""""

*   Data flow is now tracked through the :code:`Promise.try` and :code:`Array.prototype.with` functions.
*   Query :code:`js/index-out-of-bounds` no longer produces a false-positive when a strictly-less-than check overrides a previous less-than-or-equal test.
*   The query :code:`js/remote-property-injection` now detects property injection vulnerabilities through object enumeration patterns such as :code:`Object.keys()`.
*   The query "Permissive CORS configuration" (:code:`js/cors-permissive-configuration`) has been promoted from experimental and is now part of the default security suite. Thank you to @maikypedia who `submitted the original experimental query <https://github.com/github/codeql/pull/14342>`__!

Python
""""""

*   The queries :code:`py/missing-call-to-init`, :code:`py/missing-calls-to-del`, :code:`py/multiple-calls-to-init`, and :code:`py/multiple-calls-to-del` queries have been modernized; no longer relying on outdated libraries, producing more precise results with more descriptive alert messages, and improved documentation.

GitHub Actions
""""""""""""""

*   Actions analysis now reports file coverage information on the CodeQL status page.

Deprecated Queries
~~~~~~~~~~~~~~~~~~

C#
""

*   The query :code:`cs/captured-foreach-variable` has been deprecated as the semantics of capturing a 'foreach' variable and using it outside the loop has been stable since C# version 5.

New Queries
~~~~~~~~~~~

Rust
""""

*   Added a new query, :code:`rust/request-forgery`, for detecting server-side request forgery vulnerabilities.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The second argument of the :code:`CreateTemp` function, from the :code:`os` package, is no longer a path-injection sink due to proper sanitization by Go.
*   The query "Uncontrolled data used in path expression" (:code:`go/path-injection`) now detects sanitizing a path by adding :code:`os.PathSeparator` or ``\`` to the beginning.

Java/Kotlin
"""""""""""

*   Improved support for various assertion libraries, in particular JUnit. This affects the control-flow graph slightly, and in turn affects several queries (mainly quality queries). Most queries should see improved precision (new true positives and fewer false positives), in particular :code:`java/constant-comparison`, :code:`java/index-out-of-bounds`, :code:`java/dereferenced-value-may-be-null`, and :code:`java/useless-null-check`. Some medium precision queries like :code:`java/toctou-race-condition` and :code:`java/unreleased-lock` may see mixed result changes (both slight improvements and slight regressions).
*   Added taint flow model for :code:`java.crypto.KDF`.
*   Added taint flow model for :code:`java.lang.ScopedValue`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added modeling for promisification libraries :code:`@gar/promisify`, :code:`es6-promisify`, :code:`util.promisify`, :code:`thenify-all`, :code:`call-me-maybe`, :code:`@google-cloud/promisify`, and :code:`util-promisify`.
*   Data flow is now tracked through promisified user-defined functions.

Swift
"""""

*   Updated to allow analysis of Swift 6.1.3.

Rust
""""

*   Added cryptography related models for the :code:`cookie` and :code:`biscotti` crates.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The predicate :code:`getAContructorCall` in the class :code:`SslContextClass` has been deprecated. Use :code:`getAConstructorCall` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added predicates :code:`getTransitiveNumberOfVlaDimensionStmts`, :code:`getTransitiveVlaDimensionStmt`, and :code:`getParentVlaDecl` to :code:`VlaDeclStmt` for handling :code:`VlaDeclStmt`\ s whose base type is defined in terms of another :code:`VlaDeclStmt` via a :code:`typedef`.

Java/Kotlin
"""""""""""

*   The Java extractor and QL libraries now support Java 25.
*   Added support for Java 25 compact source files (JEP 512). The new predicate :code:`Class.isImplicit()` identifies classes that are implicitly declared when using compact source files, and the new predicate :code:`CompilationUnit.isCompactSourceFile()` identifies compilation units that contain compact source files.
*   Added support for Java 25 module import declarations.
*   Add :code:`ModuleImportDeclaration` class.
