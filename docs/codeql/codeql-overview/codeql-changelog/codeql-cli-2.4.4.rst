.. _codeql-cli-2.4.4:

=========================
CodeQL 2.4.4 (2021-02-12)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.4.4 runs a total of 235 security queries when configured with the Default suite (covering 106 CWE). The Extended suite enables an additional 79 queries (covering 26 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The :code:`name` property in :code:`qlpack.yml` must now meet the following requirements:

    *   Only lowercase ASCII letters, ASCII digits, and hyphens (:code:`-`) are allowed.
    *   A hyphen is not allowed as the first or last character of the name.
    *   The name must be at least one character long, and no longer than 128 characters.

Bug Fixes
~~~~~~~~~

*   The default value of the :code:`--working-dir` options for the
    :code:`index-files` and :code:`trace-command` subcommands of :code:`codeql database` has been fixed to match the documentation; previously, it would erroneously use the process' current working directory rather than the database source root.
    
*   :code:`codeql test run` will not crash if database extraction in a test directory fails. Instead only the tests in that directory will be marked as failing, and tests in other directories will continue executing.

New Features
~~~~~~~~~~~~

*   Alert and path queries can now give a score to each alert they produce. You can incorporate alert scores in an alert or path query by first adding the :code:`@scored` property to the query metadata. You can then introduce a new numeric column at the end of the :code:`select` statement structure to represent the score of each alert.
    Alert scores are exposed in the SARIF output of commands like
    :code:`codeql database analyze` as the :code:`score` property in the property bags of result objects.
