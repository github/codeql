.. _codeql-cli-2.16.5:

==========================
CodeQL 2.16.5 (2024-03-21)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.16.5 runs a total of 409 security queries when configured with the Default suite (covering 160 CWE). The Extended suite enables an additional 132 queries (covering 34 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Beta support has been added for analyzing Java codebases without needing a working build. To enable this, pass the :code:`--build-mode none` option to :code:`codeql database create`.
