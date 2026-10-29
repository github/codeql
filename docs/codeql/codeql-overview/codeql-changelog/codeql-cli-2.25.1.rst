.. _codeql-cli-2.25.1:

==========================
CodeQL 2.25.1 (2026-03-27)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.25.1 runs a total of 491 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug where extraction could fail on YAML files containing emoji.

Miscellaneous
~~~~~~~~~~~~~

*   Upgraded snakeyaml (which is a dependency of jackson-dataformat-yaml) from 2.3 to 2.6.
