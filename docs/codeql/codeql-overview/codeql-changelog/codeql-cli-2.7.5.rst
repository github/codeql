.. _codeql-cli-2.7.5:

=========================
CodeQL 2.7.5 (2022-01-17)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.7.5 runs a total of 289 security queries when configured with the Default suite (covering 127 CWE). The Extended suite enables an additional 88 queries (covering 31 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   The CodeQL Action versions up to and including version 1.0.22 are now deprecated for use with CodeQL CLI 2.7.5 and later.  The CLI will emit a warning if it detects that it is being used by a deprecated version of the codeql-action.  This warning will become a fatal error with version 2.8.0 of the CLI.

Documentation
~~~~~~~~~~~~~

*   The documentation for the :code:`--trace-process-level` flag of :code:`codeql database init` (which is used with indirect build tracing on Windows) was erroneous.
    
    The help text previously claimed that :code:`--trace-process-level=1` would inject CodeQL's build tracer into the calling process. This is actually what :code:`--trace-process-level=0` achieves. The help text has now been corrected to match the actual (unchanged) behavior.
    
    Also, some log messages incorrectly stated which process CodeQL was injected into. These have also been corrected.

New Features
~~~~~~~~~~~~

*   The :code:`codeql github upload-results` command will now print the API response body in JSON format if a :code:`--format=json` flag is given. Otherwise the command will print the URL of the SARIF upload. This URL can be used to get status information for the upload.
    
    See also: https://docs.github.com/en/rest/reference/code-scanning

Miscellaneous
~~~~~~~~~~~~~

*   For commands that run queries, the :code:`--timeout` option now controls the maximal time it may take to evaluate a "layer" of a query rather than a "stage".  There are usually many "layers" in each "stage",
    but it is usually a single one of the layers in a stage that uses most of the time, so there is no need to reduce existing timeout values as a result of this change.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   TypeScript 4.5 is now supported.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`java/constant-comparison` query no longer raises false alerts regarding comparisons with Unicode surrogate character literals.

JavaScript/TypeScript
"""""""""""""""""""""

*   Support for handlebars templates has improved. Raw interpolation tags of the form :code:`{{& ... }}` are now recognized,
    as well as whitespace-trimming tags like :code:`{{~ ... }}`.
*   Data flow is now tracked across middleware functions in more cases, leading to more security results in general. Affected packages are :code:`express` and :code:`fastify`.
*   :code:`js/missing-token-validation` has been made more precise, yielding both fewer false positives and more true positives.

Python
""""""

*   Added modeling of many functions from the :code:`os` module that uses file system paths, such as :code:`os.stat`, :code:`os.chdir`, :code:`os.mkdir`, and so on. All of these are new sinks for the *Uncontrolled data used in path expression* (:code:`py/path-injection`) query.
*   Added modeling of the :code:`tempfile` module for creating temporary files and directories, such as the functions :code:`tempfile.NamedTemporaryFile` and :code:`tempfile.TemporaryDirectory`. The :code:`suffix`, :code:`prefix`, and :code:`dir` arguments are all vulnerable to path-injection, and these are new sinks for the *Uncontrolled data used in path expression* (:code:`py/path-injection`) query.
*   Extended the modeling of FastAPI such that :code:`fastapi.responses.FileResponse` are considered :code:`FileSystemAccess`, making them sinks for the *Uncontrolled data used in path expression* (:code:`py/path-injection`) query.
*   Added modeling of the :code:`posixpath`, :code:`ntpath`, and :code:`genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks for the *Uncontrolled data used in path expression* (:code:`py/path-injection`) query.
*   Added modeling of :code:`wsgiref.simple_server` applications, leading to new remote flow sources.
*   To support the new SSRF queries, the PyPI package :code:`requests` has been modeled, along with :code:`http.client.HTTP[S]Connection` from the standard library.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   A new query :code:`cpp/certificate-not-checked` has been added for C/C++. The query flags unsafe use of OpenSSL and similar libraries.
*   A new query :code:`cpp/certificate-result-conflation` has been added for C/C++. The query flags unsafe use of OpenSSL and similar libraries.

Python
""""""

*   Two new queries have been added for detecting Server-side request forgery (SSRF). *Full server-side request forgery* (:code:`py/full-ssrf`) will only alert when the URL is fully user-controlled, and *Partial server-side request forgery* (:code:`py/partial-ssrf`) will alert when any part of the URL is user-controlled. Only :code:`py/full-ssrf` will be run by default.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Java/Kotlin
"""""""""""

*   :code:`CharacterLiteral`\ 's :code:`getCodePointValue` predicate now returns the correct value for UTF-16 surrogates.
*   The :code:`RangeAnalysis` module now properly handles comparisons with Unicode surrogate character literals.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Data flow now propagates taint from remote source :code:`Parameter` types to read steps of their fields (e.g. :code:`tainted.publicField` or :code:`tainted.getField()`). This also applies to their subtypes and the types of their fields, recursively.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Added modeling of many functions from the :code:`os` module that uses file system paths, such as :code:`os.stat`, :code:`os.chdir`, :code:`os.mkdir`, and so on.
*   Added modeling of the :code:`tempfile` module for creating temporary files and directories, such as the functions :code:`tempfile.NamedTemporaryFile` and :code:`tempfile.TemporaryDirectory`.
*   Extended the modeling of FastAPI such that custom subclasses of :code:`fastapi.APIRouter` are recognized.
*   Extended the modeling of FastAPI such that :code:`fastapi.responses.FileResponse` are considered :code:`FileSystemAccess`.
*   Added modeling of the :code:`posixpath`, :code:`ntpath`, and :code:`genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks.
*   Added modeling of :code:`wsgiref.simple_server` applications, leading to new remote flow sources.

Deprecated APIs
~~~~~~~~~~~~~~~

Ruby
""""

*   :code:`ConstantWriteAccess.getQualifiedName()` has been deprecated in favor of :code:`getAQualifiedName()` which can return multiple possible qualified names for a given constant write access.

New Features
~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   TypeScript 4.5 is now supported.

Ruby
""""

*   A new library, :code:`Customizations.qll`, has been added, which allows for global customizations that affect all queries.
