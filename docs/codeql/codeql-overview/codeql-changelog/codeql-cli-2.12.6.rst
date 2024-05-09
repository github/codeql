.. _codeql-cli-2.12.6:

==========================
CodeQL 2.12.6 (2023-04-04)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.6 runs a total of 386 security queries when configured with the Default suite (covering 154 CWE). The Extended suite enables an additional 124 queries (covering 31 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug in :code:`codeql database analyze` and related commands where the :code:`--max-paths` option was not respected correctly when multiple alerts with the same primary code location were grouped together.
    (This grouping is the default behavior unless the :code:`--no-group-alerts` option is passed.)
    This bug caused some SARIF files produced by CodeQL to exceed the limits on the number of paths (:code:`threadFlows`) accepted by code scanning,
    leading to errors when uploading results.

New Features
~~~~~~~~~~~~

*   Several experimental subcommands have been added in support of the new `code scanning tool status page <https://github.blog/changelog/2023-03-28-code-scanning-shows-the-health-of-tools-enabled-on-a-repository/>`__.
    These include :code:`codeql database add-diagnostic`,
    :code:`codeql database export-diagnostics`, and the
    :code:`codeql diagnostic add` and :code:`codeql diagnostic export` plumbing subcommands.

Known Issues
~~~~~~~~~~~~

*   We recommend that customers using the CodeQL CLI in a third party CI system do not upgrade to this release, due to an issue with :code:`codeql github upload-results`. Instead, please use CodeQL 2.12.5, or, when available, CodeQL 2.12.7 or 2.13.1.
    
    This issue occurs when uploading certain kinds of diagnostic information and causes the subcommand to fail with "A fatal error occurred: Invalid SARIF.", reporting an :code:`InvalidDefinitionException`.
    
    Customers who wish to use CodeQL 2.12.6 or 2.13.0 can work around the problem by passing :code:`--no-sarif-include-diagnostics` to any invocations of :code:`codeql database analyze` or :code:`codeql database interpret-results`.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ruby
""""

*   :code:`rb/sensitive-get-query` no longer reports flow paths from input parameters to sensitive use nodes. This avoids cases where many flow paths could be generated for a single parameter, which caused excessive paths to be generated.
