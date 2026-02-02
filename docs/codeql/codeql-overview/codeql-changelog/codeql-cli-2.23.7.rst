.. _codeql-cli-2.23.7:

==========================
CodeQL 2.23.7 (2025-12-05)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.7 runs a total of 491 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE). 6 security queries have been added with this release.

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   The :code:`--save-cache` flag to :code:`codeql database run-queries` and other commands that execute queries has been deprecated. This flag previously instructed the evaluator to aggressively write intermediate results to the disk cache, but now has no effect.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Operations that extract only a fixed-length prefix or suffix of a string (for example, :code:`substring` in Java or :code:`take` in Kotlin), when limited to a length of at most 7 characters, are now treated as sanitizers for the :code:`java/sensitive-log` query.

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug in the Next.js model that would cause the analysis to miss server-side taint sources in the :code:`app/pages` folder.

Rust
""""

*   The :code:`rust/access-invalid-pointer` query has been improved with new flow sources and barriers.

New Queries
~~~~~~~~~~~

Golang
""""""

*   The :code:`go/cookie-http-only-not-set` query has been promoted from the experimental query pack. This query was originally contributed to the experimental query pack by @edvraa.
*   A new query :code:`go/cookie-secure-not-set` has been added to detect cookies without the :code:`Secure` flag set.
*   Added a new query, :code:`go/weak-crypto-algorithm`, to detect the use of a broken or weak cryptographic algorithm. A very simple version of this query was originally contributed as an `experimental query by @dilanbhalla <https://github.com/github/codeql-go/pull/284>`__.
*   Added a new query, :code:`go/weak-sensitive-data-hashing`, to detect the use of a broken or weak cryptographic hash algorithm on sensitive data.

Rust
""""

*   Added a new query :code:`rust/xss`, to detect cross-site scripting security vulnerabilities.
*   Added a new query :code:`rust/disabled-certificate-check`, to detect disabled TLS certificate checks.
*   Added three example queries (:code:`rust/examples/empty-if`, :code:`rust/examples/simple-sql-injection` and :code:`rust/examples/simple-constant-password`) to help developers learn to write CodeQL queries for Rust.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Python
""""""

*   Fixed a bug in the Python extractor's import handling where failing to find an import in :code:`find_module` would cause a :code:`KeyError` to be raised. (Contributed by @akoeplinger.)

Breaking Changes
~~~~~~~~~~~~~~~~

Rust
""""

*   The type :code:`DataFlow::Node` is now based directly on the AST instead of the CFG, which means that predicates like :code:`asExpr()` return AST nodes instead of CFG nodes.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The class :code:`DataFlow::FieldContent` now covers both :code:`union` and :code:`struct`\ /\ :code:`class` types. A new predicate :code:`FieldContent.getAField` has been added to access the union members associated with the :code:`FieldContent`. The old :code:`FieldContent` has been renamed to :code:`NonUnionFieldContent`.

C#
""

*   Improved stability when downloading .NET versions by setting appropriate environment variables for :code:`dotnet` commands. The correct architecture-specific version of .NET is now downloaded on ARM runners.
*   Compilation errors are now included in the debug log when using build-mode none.
*   Added a new extractor option to specify a custom directory for dependency downloads in buildless mode. Use :code:`-O buildless_dependency_dir=<path>` to configure the target directory.

JavaScript/TypeScript
"""""""""""""""""""""

*   JavaScript :code:`DataFlow::globalVarRef` now recognizes :code:`document.defaultView` as an alias of :code:`window`, allowing flows such as :code:`document.defaultView.history.pushState(...)` to be modeled and found by queries relying on :code:`globalVarRef("history")`.

Rust
""""

*   Added more detailed models for :code:`std::fs` and :code:`std::path`.

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The SSA interface has been updated and all classes and several predicates have been renamed. See the qldoc for more specific migration information.
