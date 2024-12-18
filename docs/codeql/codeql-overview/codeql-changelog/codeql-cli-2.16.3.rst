.. _codeql-cli-2.16.3:

==========================
CodeQL 2.16.3 (2024-02-22)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.16.3 runs a total of 408 security queries when configured with the Default suite (covering 160 CWE). The Extended suite enables an additional 131 queries (covering 34 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug where CodeQL may produce an invalid database when it exhausts all available ID numbers. Now it detects the condition and reports an error instead.

New Features
~~~~~~~~~~~~

*   A new extractor option has been added to the Python extractor:
    :code:`python_executable_name`. You can use this option to override the default process the extractor uses to find and select a Python executable. Pass one of
    :code:`--extractor-option python_executable_name=py` or :code:`--extractor-option python_executable_name=python` or :code:`--extractor-option python_executable_name=python3` to commands that run the extractor, for example: :code:`codeql database create`.
    
    On Windows machines, the Python extractor will expect to find :code:`py.exe` on the system :code:`PATH` by default. If the Python executable has a different name, you can set the new extractor option to override this value and look for
    :code:`python.exe` or :code:`python3.exe`.
    
    For more information about using the extractor option with the CodeQL CLI, see
    \ `Extractor options <https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/extractor-options>`__.

Security Updates
~~~~~~~~~~~~~~~~

*   Fixes CVE-2024-25129, a limited data exfiltration vulnerability that could be triggered by untrusted databases or QL packs.  See the
    \ `security advisory <https://github.com/github/codeql-cli-binaries/security/advisories/GHSA-gf8p-v3g3-3wph>`__ for more information.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The left operand of the :code:`&&` operator no longer propagates data flow by default.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The query "Use of a hardcoded key for signing JWT" (:code:`go/hardcoded-key`) has been promoted from experimental to the main query pack. Its results will now appear by default as part of :code:`go/hardcoded-credentials`. This query was originally `submitted as an experimental query by @porcupineyhairs <https://github.com/github/codeql/pull/9378>`__.

Java/Kotlin
"""""""""""

*   The sinks of the queries :code:`java/path-injection` and :code:`java/path-injection-local` have been reworked. Path creation sinks have been converted to summaries instead, while sinks now are actual file read/write operations only. This has reduced the false positive ratio of both queries.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "non-constant format string" query (:code:`cpp/non-constant-format`) has been updated to produce fewer false positives.
*   Added dataflow models for the :code:`gettext` function variants.

C#
""

*   Added sanitizers for relative URLs, :code:`List.Contains()`, and checking the :code:`.Host` property on an URI to the :code:`cs/web/unvalidated-url-redirection` query.

Java/Kotlin
"""""""""""

*   The sanitizer for the path injection queries has been improved to handle more cases where :code:`equals` is used to check an exact path match.
*   The query :code:`java/unvalidated-url-redirection` now sanitizes results following the same logic as the query :code:`java/ssrf`. URLs where the destination cannot be controlled externally are no longer reported.

New Queries
~~~~~~~~~~~

Golang
""""""

*   The query "Missing JWT signature check" (:code:`go/missing-jwt-signature-check`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @am0o0 <https://github.com/github/codeql/pull/14075>`__.

Java/Kotlin
"""""""""""

*   Added a new query :code:`java/android/insecure-local-authentication` for finding uses of biometric authentication APIs that do not make use of a :code:`KeyStore`\ -backed key and thus may be bypassed.

Swift
"""""

*   Added a new experimental query, :code:`swift/unsafe-unpacking`, that detects unpacking user controlled zips without validating the destination file path is within the destination directory.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`security-severity` score of the query :code:`java/relative-path-command` has been reduced to better adjust it to the specific conditions needed for exploitation.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   C# 12: The QL and data flow library now support primary constructors.
*   Added a new database relation to store key-value pairs corresponding to compilations. The new relation is used in buildless mode to surface information related to dependency fetching.

Java/Kotlin
"""""""""""

*   An extension point for sanitizers of the query :code:`java/unvalidated-url-redirection` has been added.
    
*   Added models for the following packages:

    *   java.io
    *   java.lang
    *   java.net
    *   java.net.http
    *   java.nio.file
    *   java.util.zip
    *   javax.servlet
    *   org.apache.commons.io
    *   org.apache.hadoop.fs
    *   org.apache.hadoop.fs.s3a
    *   org.eclipse.jetty.client
    *   org.gradle.api.file

JavaScript/TypeScript
"""""""""""""""""""""

*   The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.

Python
""""""

*   The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.
*   Added modeling of the :code:`psycopg` PyPI package as a SQL database library.

Ruby
""""

*   Raw output ERB tags of the form :code:`<%== ... %>` are now recognised as cross-site scripting sinks.
*   The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.

Swift
"""""

*   The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`PathCreation` class in :code:`PathCreation.qll` has been deprecated.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   A :code:`getInitialization` predicate was added to the :code:`RangeBasedForStmt` class that yields the C++20-style initializer of the range-based :code:`for` statement when it exists.

Shared Libraries
----------------

Breaking Changes
~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The :code:`edges` predicate contained in :code:`PathGraph` now contains two additional columns for propagating model provenance information. This is primarily an internal change without any impact on any APIs, except for specialised queries making use of :code:`MergePathGraph` in conjunction with custom :code:`PathGraph` implementations. Such queries will need to be updated to reference the two new columns. This is expected to be very rare, as :code:`MergePathGraph` is an advanced feature, but it is a breaking change for any such affected queries.
