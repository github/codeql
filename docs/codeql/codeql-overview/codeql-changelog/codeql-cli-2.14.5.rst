.. _codeql-cli-2.14.5:

==========================
CodeQL 2.14.5 (2023-09-14)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.14.5 runs a total of 394 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 129 queries (covering 35 more CWE). A list of queries for each suite and language `is available here <https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/codeql-query-suites#queries-included-in-the-default-and-security-extended-query-suites>`__.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a JavaScript extractor crash that was introduced in 2.14.4.
