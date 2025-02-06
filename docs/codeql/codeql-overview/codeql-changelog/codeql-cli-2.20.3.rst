.. _codeql-cli-2.20.3:

==========================
CodeQL 2.20.3 (2025-01-24)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.20.3 runs a total of 454 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE).

CodeQL CLI
----------

Security Updates
~~~~~~~~~~~~~~~~

*   Resolves a security vulnerability where CodeQL databases or logs produced by the CodeQL CLI may contain the environment variables from the time of database creation. This includes any secrets stored in an environment variables. For more information, see the
    \ `CodeQL CLI security advisory <https://github.com/github/codeql-cli-binaries/security/advisories/GHSA-gqh3-9prg-j95m>`__.
    
    All users of CodeQL should follow the advice in the CodeQL advisory mentioned above or upgrade to this version or a later version of CodeQL.
    
    If you are using the CodeQL Action, also see the related `CodeQL Action security advisory <https://github.com/github/codeql-action/security/advisories/GHSA-vqf5-2xx6-9wfm>`__.
    
