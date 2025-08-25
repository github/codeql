.. _codeql-cli-2.10.5:

==========================
CodeQL 2.10.5 (2022-09-13)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.10.5 runs a total of 352 security queries when configured with the Default suite (covering 146 CWE). The Extended suite enables an additional 106 queries (covering 30 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   You can now define which registries should be used for downloading and publishing CodeQL packs on a per-workspace basis by creating a :code:`codeql-workspace.yml` file and adding a :code:`registries` block. For more infomation, see `About CodeQL Workspaces <https://codeql.github.com/docs/codeql-cli/about-codeql-workspaces/>`__.
