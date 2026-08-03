.. _codeql-cli-2.26.2:

==========================
CodeQL 2.26.2 (2026-07-23)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.26.2 runs a total of 497 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   Removed support for parsing :code:`[[`\ -style links in alert messages. This was an undocumented legacy feature that allowed query authors to embed links inline in select clause message strings using :code:`[["text"|"url"]]` syntax. Queries should use :code:`$@` placeholder pairs instead.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   :code:`System.Web.HttpRequest.RawUrl` is no longer treated as a sanitizer for :code:`cs/web/unvalidated-url-redirection`, since it contains the un-normalized request line. This may lead to more results.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added the tag :code:`external/cwe/cwe-762` to :code:`cpp/new-free-mismatch`, and removed the tag :code:`external/cwe/cwe-401`. This better matches the behavior of the query.

C#
""

*   The query :code:`cs/useless-assignment-to-local` has been removed from the :code:`code-quality` suite, but it remains in the :code:`code-quality-extended` suite.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.3.3.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The function :code:`Rel` in :code:`path/filepath` was incorrectly considered a sanitizer for :code:`go/path-injection` and :code:`go/zipslip`. This has now been fixed, which may lead to more results for those queries.

Java/Kotlin
"""""""""""

*   Kotlin versions up to 2.4.10 are now supported.
*   :code:`java.io.File.getName()` is no longer treated as a complete sanitizer for :code:`java/path-injection`, since it does not remove a :code:`..` path component (for example :code:`new File("..").getName()` returns :code:`".."`). It is now only recognized as a sanitizer when combined with a subsequent check for :code:`..` components, which may result in new alerts.

GitHub Actions
""""""""""""""

*   Altered the logic of :code:`EnvironmentCheck` to make sure it is a check that protects only for non-toctou. This change will result in more results being found by the queries: :code:`actions/untrusted-checkout-toctou/high` and :code:`actions/untrusted-checkout-toctou/critical`.
