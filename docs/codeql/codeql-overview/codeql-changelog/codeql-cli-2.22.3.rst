.. _codeql-cli-2.22.3:

==========================
CodeQL 2.22.3 (2025-08-06)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.22.3 runs a total of 476 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 130 queries (covering 32 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   The :code:`codeql database cleanup` command now takes the :code:`--cache-cleanup=overlay` option, which trims the cache to just the data that will be useful when evaluating against an overlay.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Initialization code not run" query (:code:`cpp/initialization-not-run`) no longer reports an alert on static global variables that have no dereference.

Rust
""""

*   Type inference now supports closures, calls to closures, and trait bounds using the :code:`FnOnce` trait.
*   Type inference now supports trait objects, i.e., :code:`dyn Trait` types.
*   Type inference now supports tuple types.

New Queries
~~~~~~~~~~~

Rust
""""

*   Added a new query, :code:`rust/hard-coded-cryptographic-value`, for detecting use of hardcoded keys, passwords, salts and initialization vectors.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/overrun-write` query now recognizes more bound checks and thus produces fewer false positives.

JavaScript/TypeScript
"""""""""""""""""""""

*   The regular expressions in :code:`SensitiveDataHeuristics.qll` have been extended to find more instances of sensitive data such as secrets used in authentication, finance and health information, and device data. The heuristics have also been refined to find fewer false positive matches. This will improve results for queries related to sensitive information.

Python
""""""

*   The regular expressions in :code:`SensitiveDataHeuristics.qll` have been extended to find more instances of sensitive data such as secrets used in authentication, finance and health information, and device data. The heuristics have also been refined to find fewer false positive matches. This will improve results for queries related to sensitive information.

Ruby
""""

*   The regular expressions in :code:`SensitiveDataHeuristics.qll` have been extended to find more instances of sensitive data such as secrets used in authentication, finance and health information, and device data. The heuristics have also been refined to find fewer false positive matches. This will improve results for queries related to sensitive information.

Swift
"""""

*   The regular expressions in :code:`SensitiveDataHeuristics.qll` have been extended to find more instances of sensitive data such as secrets used in authentication, finance and health information, and device data. The heuristics have also been refined to find fewer false positive matches. This will improve results for queries related to sensitive information.

Rust
""""

*   Removed deprecated dataflow extensible predicates :code:`sourceModelDeprecated`, :code:`sinkModelDeprecated`, and :code:`summaryModelDeprecated`, along with their associated classes.
*   The regular expressions in :code:`SensitiveDataHeuristics.qll` have been extended to find more instances of sensitive data such as secrets used in authentication, finance and health information, and device data. The heuristics have also been refined to find fewer false positive matches. This will improve results for queries related to sensitive information.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Exposed various SSA-related classes (:code:`Definition`, :code:`PhiNode`, :code:`ExplicitDefinition`, :code:`DirectExplicitDefinition`, and :code:`IndirectExplicitDefinition`) which were previously only usable inside the internal dataflow directory.

Java/Kotlin
"""""""""""

*   Kotlin versions up to 2.2.2\ *x* are now supported.
