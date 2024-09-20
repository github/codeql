.. _codeql-cli-2.8.2:

=========================
CodeQL 2.8.2 (2022-02-28)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.8.2 runs a total of 308 security queries when configured with the Default suite (covering 139 CWE). The Extended suite enables an additional 99 queries (covering 30 more CWE). 6 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The support for the output formats SARIF v1.0.0 and SARIF v2.0.0
    (Committee Specification Draft 1) that were deprecated in 2.7.1 has been removed. If you need this functionality, please file a public issue against https://github.com/github/codeql-cli-binaries, or open a private ticket with GitHub Support and request an escalation to engineering.

New Features
~~~~~~~~~~~~

*   The CodeQL CLI is now compatible with Windows 11 and Windows Server 2022, including building databases for compiled languages.

Query Packs
-----------

Breaking Changes
~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Add more classes to Netty request/response splitting. Change identification to :code:`java/netty-http-request-or-response-splitting`.
    Identify request splitting differently from response splitting in query results.
    Support additional classes:

    *   :code:`io.netty.handler.codec.http.CombinedHttpHeaders`
    *   :code:`io.netty.handler.codec.http.DefaultHttpRequest`
    *   :code:`io.netty.handler.codec.http.DefaultFullHttpRequest`

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added dataflow through the |link-code-snapdragon-1|_ library.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   A new query titled "Local information disclosure in a temporary directory" (:code:`java/local-temp-file-or-directory-information-disclosure`) has been added.
    This query finds uses of APIs that leak potentially sensitive information to other local users via the system temporary directory.
    This query was originally `submitted as query by @JLLeitschuh <https://github.com/github/codeql/pull/4388>`__.

JavaScript/TypeScript
"""""""""""""""""""""

*   A new query, :code:`js/functionality-from-untrusted-source`, has been added to the query suite. It finds DOM elements that load functionality from untrusted sources, like :code:`script` or :code:`iframe` elements using :code:`http` links.
    The query is run by default.

Python
""""""

*   The query "LDAP query built from user-controlled sources" (:code:`py/ldap-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @jorgectf <https://github.com/github/codeql/pull/5443>`__.
*   The query "Log Injection" (:code:`py/log-injection`) has been promoted from experimental to the main query pack. Its results will now appear when :code:`security-extended` is used. This query was originally `submitted as an experimental query by @haby0 <https://github.com/github/codeql/pull/6182>`__.

Ruby
""""

*   Added a new query, :code:`rb/clear-text-logging-sensitive-data`. The query finds cases where sensitive information, such as user credentials, are logged as cleartext.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The precision of hardcoded credentials queries (:code:`cs/hardcoded-credentials` and
    :code:`cs/hardcoded-connection-string-credentials`) have been downgraded to medium.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/request-forgery` query previously flagged both server-side and client-side request forgery,
    but these are now handled by two different queries:

    *   :code:`js/request-forgery` is now specific to server-side request forgery. Its precision has been raised to
        :code:`high` and is now shown by default (it was previously in the :code:`security-extended` suite).
    *   :code:`js/client-side-request-forgery` is specific to client-side request forgery. This is technically a new query but simply flags a subset of what the old query did.
        This has precision :code:`medium` and is part of the :code:`security-extended` suite.

Deprecated Classes
~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`CodeDuplication.Copy`, :code:`CodeDuplication.DuplicateBlock`, and :code:`CodeDuplication.SimilarBlock` classes have been deprecated.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ruby
""""

*   Added :code:`FileSystemWriteAccess` concept to model data written to the filesystem.

Deprecated APIs
~~~~~~~~~~~~~~~

Python
""""""

*   The old points-to based modeling has been deprecated. Use the new type-tracking/API-graphs based modeling instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a :code:`isStructuredBinding` predicate to the :code:`Variable` class which holds when the variable is declared as part of a structured binding declaration.

Java/Kotlin
"""""""""""

*   Added predicates :code:`ClassOrInterface.getAPermittedSubtype` and :code:`isSealed` exposing information about sealed classes.

.. |link-code-snapdragon-1| replace:: :code:`snapdragon`\ 
.. _link-code-snapdragon-1: https://npmjs.com/package/snapdragon

