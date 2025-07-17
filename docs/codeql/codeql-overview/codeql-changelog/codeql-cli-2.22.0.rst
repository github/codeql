.. _codeql-cli-2.22.0:

==========================
CodeQL 2.22.0 (2025-06-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.22.0 runs a total of 450 security queries when configured with the Default suite (covering 165 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   A number of breaking changes have been made to the C and C++ CodeQL test environment as used by :code:`codeql test run`\ :

    *   Options starting with a :code:`/` are no longer supported by
        :code:`semmle-extractor-options`. Any option starting with a :code:`/` should be replaced by the equivalent option starting with a :code:`-`, e.g., :code:`/D` should be replaced by :code:`-D`.
    *   Preprocessor command line options of the form :code:`-D<macro>#<def>` are no longer supported by :code:`semmle-extractor-options`. :code:`-D<macro>=<def>` should be used instead.
    *   The :code:`/Fp` and :code:`-o` options are no longer supported by
        :code:`semmle-extractor-options`. The options should be omitted.
    *   The :code:`-emit-pch`, :code:`-include-pch`, :code:`/Yc`, and :code:`/Yu` options, and the
        :code:`--preinclude` option taking a pre-compiled header as its argument, are no longer supported by :code:`semmle-extractor-options`. Any test that makes use of this should be replaced by a test that invokes the CodeQL CLI with the
        :code:`create database` option and that runs the relevant queries on the created database.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Added SQL injection models from the :code:`pandas` PyPI package.

New Queries
~~~~~~~~~~~

Golang
""""""

*   Query (:code:`go/html-template-escaping-bypass-xss`) has been promoted to the main query suite. This query finds potential cross-site scripting (XSS) vulnerabilities when using the :code:`html/template` package, caused by user input being cast to a type which bypasses the HTML autoescaping. It was originally contributed to the experimental query pack by @gagliardetto in `https://github.com/github/codeql-go/pull/493 <https://github.com/github/codeql-go/pull/493>`_.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The first argument of :code:`Client.Query` in :code:`cloud.google.com/go/bigquery` is now recognized as a SQL injection sink.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added taint flow through the :code:`URL` constructor from the :code:`url` package, improving the identification of SSRF vulnerabilities.

Swift
"""""

*   Updated to allow analysis of Swift 6.1.2.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a predicate :code:`getReferencedMember` to :code:`UsingDeclarationEntry`, which yields a member depending on a type template parameter.
