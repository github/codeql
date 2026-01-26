.. _codeql-cli-2.23.9:

==========================
CodeQL 2.23.9 (2026-01-09)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.9 runs a total of 491 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE).

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   Support for Kotlin version 1.6 and 1.7 has been deprecated and will be removed from CodeQL version 2.24.1. Starting with version 2.24.1, users will need to use Kotlin version >= 1.8 to extract Kotlin databases.
