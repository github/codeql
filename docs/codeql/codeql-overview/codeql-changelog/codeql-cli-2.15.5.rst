.. _codeql-cli-2.15.5:

==========================
CodeQL 2.15.5 (2023-12-20)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.15.5 runs a total of 401 security queries when configured with the Default suite (covering 159 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed an issue where CodeQL would sometimes incorrectly report that no files were scanned when running on Windows.
    This affected the human-readable summary produced by :code:`codeql database analyze` and :code:`codeql database interpret-results`, but did not impact the file coverage information produced in the SARIF output and displayed on the tool status page.
*   When analyzing Swift codebases, CodeQL build tracing will now ignore the
    :code:`codesign` tool. This prevents errors in build commands or workflows on macOS that include both CodeQL and code signing.

New Features
~~~~~~~~~~~~

*   A new extractor option has been added to the JavaScript/TypeScript extractor.
    Set the environment variable :code:`CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_SKIP_TYPES` to :code:`true` to skip the extraction of types in TypeScript files.
    Use this to speed up extraction if your codebase has a high volume of TypeScript type information that causes a noticeable bottleneck for TypeScript extraction. The majority of analysis results should be preserved even when no types are extracted.
