.. _codeql-cli-2.7.6:

=========================
CodeQL 2.7.6 (2022-01-24)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.7.6 runs a total of 289 security queries when configured with the Default suite (covering 127 CWE). The Extended suite enables an additional 88 queries (covering 31 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   A bug where creation of a CodeQL database could sometimes fail with a :code:`NegativeArraySizeException` has now been fixed.

New Features
~~~~~~~~~~~~

*   The CLI and evaluator contain a number of new features in support of internal machine learning experiments. This includes an experimental
    :code:`resolve ml-models` subcommand and new :code:`mlModels` metadata in pack definition files. As these new features are not yet ready for general use, they should be ignored by external CodeQL users.
