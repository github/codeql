.. _codeql-cli-2.7.3:

=========================
CodeQL 2.7.3 (2021-12-06)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.7.3 runs a total of 288 security queries when configured with the Default suite (covering 124 CWE). The Extended suite enables an additional 85 queries (covering 32 more CWE). 10 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The experimental command-line option :code:`--ml-model-path` that was introduced to support internal experiments has been removed.

Bug Fixes
~~~~~~~~~

*   Editing support (content assist, code navigation, etc.) in files under the :code:`.github` directory will now work properly. This is because files under the :code:`.github` directory will now be indexed and processed by the CodeQL language server. Other hidden directories that start with :code:`.` will remain un-indexed. This affects the vscode-codeql extension and any other IDE extension that uses the CodeQL language server.
    
*   Fixed authentication with GitHub package registries via the
    :code:`GITHUB_TOKEN` environment variable and the :code:`--github-auth-stdin` flag when downloading and publishing packs.
    
*   Fixed an incompatibility with glibc version 2.34 on Linux, where build tracing failed with an error message.
    
*   Fixed a bug where :code:`codeql generate log-summary` could sometimes fail with a :code:`JsonMappingException`.

New Features
~~~~~~~~~~~~

*   The CodeQL CLI for Mac OS now ships with a native Java virtual machine for M1 Macs,
    and this will be used by default where applicable to run the CodeQL engine, thus improving performance.
    \ `Rosetta 2 <https://support.apple.com/en-us/HT211861>`__ is still required as not all components of the CodeQL CLI are natively compiled.
    
*   Commands that execute queries will now exit with status code 34 if certain errors that prevent the evaluation of one or more individual queries are detected. Previously some of these errors would crash the evaluator and exit with status code 100.
    
    (This is currently used for "external predicate not found" errors).

Query Packs
-----------

New Queries
~~~~~~~~~~~

C/C++
"""""

*   A new query :code:`cpp/non-https-url` has been added for C/C++. The query flags uses of :code:`http` URLs that might be better replaced with :code:`https`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/sensitive-get-query` query has been added. It highlights GET requests that read sensitive information from the query string.
*   The :code:`js/insufficient-key-size` query has been added. It highlights the creation of cryptographic keys with a short key size.
*   The :code:`js/session-fixation` query has been added. It highlights servers that reuse a session after a user has logged in.

Ruby
""""

*   A new query (:code:`rb/request-forgery`) has been added. The query finds HTTP requests made with user-controlled URLs.
*   A new query (:code:`rb/csrf-protection-disabled`) has been added. The query finds cases where cross-site forgery protection is explicitly disabled.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Fixed the query ids of two queries that are meant for manual exploration: :code:`python/count-untrusted-data-external-api` and :code:`python/untrusted-data-to-external-api` have been changed to :code:`py/count-untrusted-data-external-api` and :code:`py/untrusted-data-to-external-api`.

Ruby
""""

*   The precision of "Hard-coded credentials" (:code:`rb/hardcoded-credentials`) has been decreased from "high" to "medium". This query will no longer be run and displayed by default on Code Scanning and LGTM.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Java/Kotlin
"""""""""""

*   :code:`CharacterLiteral`\ 's :code:`getCodePointValue` predicate now returns the correct value for UTF-16 surrogates.
*   The :code:`RangeAnalysis` module and the :code:`java/constant-comparison` queries no longer raise false alerts regarding comparisons with Unicode surrogate character literals.
*   The predicate :code:`Method.overrides(Method)` was accidentally transitive. This has been fixed. This fix also affects :code:`Method.overridesOrInstantiates(Method)` and :code:`Method.getASourceOverriddenMethod()`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Added modeling of :code:`os.stat`, :code:`os.lstat`, :code:`os.statvfs`, :code:`os.fstat`, and :code:`os.fstatvfs`, which are new sinks for the *Uncontrolled data used in path expression* (:code:`py/path-injection`) query.
*   Added modeling of the :code:`posixpath`, :code:`ntpath`, and :code:`genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks for the *Uncontrolled data used in path expression* (:code:`py/path-injection`) query.
*   Added modeling of :code:`wsgiref.simple_server` applications, leading to new remote flow sources.
*   Added modeling of :code:`aiopg` for sinks executing SQL.
*   Added modeling of HTTP requests and responses when using :code:`flask_admin` (:code:`Flask-Admin` PyPI package), which leads to additional remote flow sources.
*   Added modeling of the PyPI package :code:`toml`, which provides encoding/decoding of TOML documents, leading to new taint-tracking steps.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   The QL library :code:`semmle.code.cpp.commons.Exclusions` now contains a predicate
    :code:`isFromSystemMacroDefinition` for identifying code that originates from a macro outside the project being analyzed.
