.. _codeql-cli-2.23.6:

==========================
CodeQL 2.23.6 (2025-11-24)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.6 runs a total of 485 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The LGTM results format for uploading to LGTM has been removed.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   An improvement to the Guards library for recognizing disjunctions means improved precision for :code:`cs/constant-condition`, :code:`cs/inefficient-containskey`, and :code:`cs/dereferenced-value-may-be-null`. The two former can have additional findings, and the latter will have fewer false positives.

Rust
""""

*   Taint flow barriers have been added to the :code:`rust/regex-injection`, :code:`rust/sql-injection` and :code:`rust/log-injection`, reducing the frequency of false positive results for these queries.

New Queries
~~~~~~~~~~~

C#
""

*   The :code:`cs/web/cookie-secure-not-set` and :code:`cs/web/cookie-httponly-not-set` queries have been promoted from experimental to the main query pack.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Reduced the :code:`security-severity` score of the :code:`java/overly-large-range` query from 5.0 to 4.0 to better reflect its impact.
*   Reduced the :code:`security-severity` score of the :code:`java/insecure-cookie` query from 5.0 to 4.0 to better reflect its impact.

JavaScript/TypeScript
"""""""""""""""""""""

*   Increased the :code:`security-severity` score of the :code:`js/xss-through-dom` query from 6.1 to 7.8 to align with other XSS queries.
*   Reduced the :code:`security-severity` score of the :code:`js/overly-large-range` query from 5.0 to 4.0 to better reflect its impact.

Python
""""""

*   Reduced the :code:`security-severity` score of the :code:`py/overly-large-range` query from 5.0 to 4.0 to better reflect its impact.

Ruby
""""

*   Reduced the :code:`security-severity` score of the :code:`rb/overly-large-range` query from 5.0 to 4.0 to better reflect its impact.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Improve performance of the range analysis in cases where it would otherwise take an exorbitant amount of time.

Golang
""""""

*   Some fixes relating to use of path transformers when extracting a database:

    *   Fixed a problem where the path transformer would be ignored when extracting older codebases that predate the use of Go modules.
    *   The environment variable :code:`CODEQL_PATH_TRANSFORMER` is now recognized, in addition to :code:`SEMMLE_PATH_TRANSFORMER`.
    *   Fixed some cases where the extractor emitted paths without applying the path transformer.

Breaking Changes
~~~~~~~~~~~~~~~~

Python
""""""

*   The classes :code:`ControlFlowNode`, :code:`Expr`, and :code:`Module` no longer expose predicates that invoke the points-to analysis. To access these predicates, import the module :code:`LegacyPointsTo` and follow the instructions given therein.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.2.1.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Updated *roslyn* and *binlog* dependencies in the extractor, which may improve database and analysis quality.

Rust
""""

*   Added models for cookie methods in the :code:`poem` crate.

Deprecated APIs
~~~~~~~~~~~~~~~

C#
""

*   :code:`ControlFlowElement.controlsBlock` has been deprecated in favor of the Guards library.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   New predicates :code:`getAnExpandedArgument` and :code:`getExpandedArgument` were added to the :code:`Compilation` class, yielding compilation arguments after expansion of response files.

C#
""

*   Initial support for incremental C# databases via :code:`codeql database create --overlay-base`\ /\ :code:`--overlay-changes`.
