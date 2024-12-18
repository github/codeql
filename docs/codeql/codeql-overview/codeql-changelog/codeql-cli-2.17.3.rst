.. _codeql-cli-2.17.3:

==========================
CodeQL 2.17.3 (2024-05-17)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.17.3 runs a total of 414 security queries when configured with the Default suite (covering 161 CWE). The Extended suite enables an additional 131 queries (covering 35 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   The language server that our IDE integration is built on now defaults to fine-grained dependency tracking for incremental error-checking after file changes. This slightly improves the latency of refreshing errors after local source code edits and will enable significant speedups in the future.
*   We now properly handle globs (such as :code:`folder/**/*.py`) in :code:`paths` configuration to specify what files to include for Python analysis (see https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#specifying-directories-to-scan).
*   TRAP import (a part of :code:`codeql database create` and :code:`codeql database finalize`)
    now supports allocating 2^32 IDs during the import process. The previous limit was 2^31 IDs.

Query Packs
-----------

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new query, :code:`cpp/iterator-to-expired-container`, to detect the creation of iterators owned by a temporary objects that are about to be destroyed.

Python
""""""

*   The :code:`py/header-injection` query, originally contributed to the experimental query pack by @jorgectf, has been promoted to the main query pack and renamed to :code:`py/http-response-splitting`. This query finds instances of http header injection / response splitting vulnerabilities.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The Java extractor no longer supports the :code:`ODASA_JAVA_LAYOUT`, :code:`ODASA_TOOLS` and :code:`ODASA_HOME` legacy environment variables.
*   The Java extractor no longer supports the :code:`ODASA_BUILD_ERROR_DIR` legacy environment variable.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Added modeling of the :code:`pyramid` framework, leading to new remote flow sources and sinks.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Fixed a bug that stopped built-in functions from being referenced using the predicate :code:`hasQualifiedName` because technically they do not belong to any package. Now you can use the empty string as the package, e.g. :code:`f.hasQualifiedName("", "len")`.
*   Fixed a bug that stopped data flow models for built-in functions from having any effect because the package "" was not parsed correctly.
*   Fixed a bug that stopped data flow from being followed through variadic arguments to built-in functions or to functions called using a variable.
