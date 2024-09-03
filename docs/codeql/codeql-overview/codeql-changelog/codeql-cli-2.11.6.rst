.. _codeql-cli-2.11.6:

==========================
CodeQL 2.11.6 (2022-12-13)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.11.6 runs a total of 361 security queries when configured with the Default suite (covering 150 CWE). The Extended suite enables an additional 112 queries (covering 32 more CWE).

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   Java and Kotlin analyses in this release of the CLI and all earlier releases are incompatible with Kotlin 1.7.30 and later. To prevent code scanning alerts being spuriously dismissed, Java and Kotlin analyses will now fail when using Kotlin 1.7.30 or later.
    
    If you are unable to use Kotlin 1.7.29 or earlier, you can disable Kotlin support by setting
    :code:`CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN` to :code:`true` in the environment.

Bug Fixes
~~~~~~~~~

*   Fixed a bug where it was not possible to run queries in CodeQL query packs for C# that use the legacy :code:`libraryPathDependencies` property in their :code:`qlpack.yml` file. The associated error message complained about undefined extensional predicates.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Kotlin extraction will now fail if the Kotlin version in use is at least 1.7.30. This is to ensure using an as-yet-unsupported version is noticable, rather than silently failing to extract Kotlin code and therefore producing false-negative results.
