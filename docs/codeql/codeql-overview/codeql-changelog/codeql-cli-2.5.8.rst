.. _codeql-cli-2.5.8:

=========================
CodeQL 2.5.8 (2021-07-26)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.5.8 runs a total of 268 security queries when configured with the Default suite (covering 114 CWE). The Extended suite enables an additional 79 queries (covering 28 more CWE). 23 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The QL compiler now verifies that :code:`@security-severity` query metadata is numeric. You can disable this verification by passing the :code:`--no-metadata-verification` flag.

New Features
~~~~~~~~~~~~

*   The :code:`database index-files` and :code:`database trace-command` CLI commands now support :code:`--threads` and :code:`--ram` options, which are passed to extractors as suggestions.
    
*   The :code:`database finalize` CLI command now supports the :code:`--ram` option,
    which controls memory usage for finalization.
    
*   The :code:`database create` CLI command now supports the :code:`--ram` option,
    which controls memory usage for database creation.  - The :code:`generate query-help` CLI command now support rendering query help in SARIF format.
    
