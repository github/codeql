.. _codeql-cli-2.13.5:

==========================
CodeQL 2.13.5 (2023-07-05)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.13.5 runs a total of 390 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 125 queries (covering 32 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   The Swift extractor now supports Swift 5.8.1.
