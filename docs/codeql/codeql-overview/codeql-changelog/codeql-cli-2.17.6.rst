.. _codeql-cli-2.17.6:

==========================
CodeQL 2.17.6 (2024-06-27)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.17.6 runs a total of 414 security queries when configured with the Default suite (covering 161 CWE). The Extended suite enables an additional 131 queries (covering 35 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Beta support is now available for analyzing C# codebases without needing a working build. To use this, pass the :code:`--build-mode none` option to :code:`codeql database create`.

Improvements
~~~~~~~~~~~~

*   The :code:`--model-packs` option is now publicly available. This option allows commands like :code:`codeql database analyze` to accept a list of model packs that are used to augment the analysis of all queries involved in the analysis.
