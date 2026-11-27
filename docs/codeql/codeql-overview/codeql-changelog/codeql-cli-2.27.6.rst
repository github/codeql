.. _codeql-cli-2.27.6:

==========================
CodeQL 2.27.6 (2026-11-24)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.27.6 runs a total of 499 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Security Updates
~~~~~~~~~~~~~~~~

*   To mitigate Java4Shell (CVE-2026-114938), the JDK bundled with the CodeQL CLI has been updated to Temurin jdk-25.0.5.1+2. The Java extractor now disables HotSpot Base64 intrinsics when it launches with its bundled JDK.
