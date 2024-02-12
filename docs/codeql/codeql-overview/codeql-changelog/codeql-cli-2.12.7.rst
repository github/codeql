.. _codeql-cli-2.12.7:

==========================
CodeQL 2.12.7 (2023-04-18)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.7 runs a total of 386 security queries when configured with the Default suite (covering 154 CWE). The Extended suite enables an additional 124 queries (covering 31 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug in :code:`codeql database upload-results` where the subcommand would fail with "A fatal error occurred: Invalid SARIF.", reporting an :code:`InvalidDefinitionException`. This issue occurred when the SARIF file contained certain kinds of diagnostic information.
