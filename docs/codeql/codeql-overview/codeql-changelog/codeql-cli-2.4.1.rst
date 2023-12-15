.. _codeql-cli-2.4.1:

=========================
CodeQL 2.4.1 (2020-12-19)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.4.1 runs a total of 231 security queries when configured with the Default suite (covering 105 CWE). The Extended suite enables an additional 77 queries (covering 26 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   :code:`codeql query format` now checks all files rather than stopping after the first failure when the :code:`--check-only` option is given.
    
*   :code:`codeql resolve database` will produce a :code:`languages` key giving the language the database was created for. This can be useful in IDEs to help describe the database and suggest default actions or queries.
    For databases created by earlier versions, the result will be a best-effort guess.
    
*   :code:`codeql database interpret-results` can now produce Graphviz :code:`.dot` files from queries with :code:`@kind graph`.

Removed Features
~~~~~~~~~~~~~~~~

*   :code:`codeql test run` had some special compatibility support for running unit tests for the "code duplication" extractor features of certain discontinued Semmle products. Those tests have since been removed from the `public QL repository <https://github.com/github/codeql>`__,
    so the compatibility support for them has been removed. This should not affect any external users (since the extractor feature in question was never supported by :code:`codeql database create` anyway),
    but if you run :code:`codeql test run` against the unit tests belonging to an *old* checkout of the repository, you may now see some failures among :code:`Metrics` tests.
