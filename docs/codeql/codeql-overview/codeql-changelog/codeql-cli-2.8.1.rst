.. _codeql-cli-2.8.1:

=========================
CodeQL 2.8.1 (2022-02-15)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.8.1 runs a total of 306 security queries when configured with the Default suite (covering 137 CWE). The Extended suite enables an additional 95 queries (covering 30 more CWE). 10 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug that would sometimes lead to query evaluation on M1-based Macs to crash with :code:`Did not preallocate enough memory` error.

New Features
~~~~~~~~~~~~

*   Commands that find or run queries now allow you to refer to queries within a named CodeQL pack. For example:

    ..  code-block:: sh
    
        # Analyze a database using all queries in the experimental/Security folder within the codeql/cpp-queries
        # CodeQL query pack.
        codeql database analyze --format=sarif-latest --output=results <db> \
            codeql/cpp-queries:experimental/Security
        
        # Analyse using only the RedundantNullCheckParam.ql query in the codeql/cpp-queries CodeQL query pack.
        codeql database analyze --format=sarif-latest --output=results <db> \
            'codeql/cpp-queries:experimental/Likely Bugs/RedundantNullCheckParam.ql'
        
        # Analyse using the cpp-security-and-quality.qls query suite in the codeql/cpp-queries CodeQL query pack.
        codeql database analyze --format=sarif-latest --output=results <db> \
            'codeql/cpp-queries:codeql-suites/cpp-security-and-quality.qls'
        
        # Analyse using the cpp-security-and-quality.qls query suite from a version of the codeql/cpp-queries pack
        # that is >= 0.0.3 and < 0.1.0 (the highest compatible version will be chosen).
        # All valid semver ranges are allowed. See https://docs.npmjs.com/cli/v6/using-npm/semver#ranges
        codeql database analyze --format=sarif-latest --output=results <db> \
            'codeql/cpp-queries@~0.0.3:codeql-suites/cpp-security-and-quality.qls'
        
    The complete way to specify a set of queries is in the form
    :code:`scope/name@range:path`, where:

    *   :code:`scope/name` is the qualified name of a CodeQL pack.
        
    *   :code:`range` is a `semver range <https://docs.npmjs.com/cli/v6/using-npm/semver#ranges>`__.
        
    *   :code:`path` is a file system path
        
        If a :code:`scope/name` is specified, the :code:`range` and :code:`path` are optional. A missing :code:`range` implies the latest version of the specified pack. A missing :code:`path` implies the default query suite of the specified pack.
        
        The :code:`path` can be one of a :code:`*.ql` query file, a directory containing one or more queries, or a :code:`.qls` query suite file. If there is no pack name specified, then a :code:`path` must be provided,
        and will be interpreted relative to the current working directory of the current process.
        
        If a :code:`scope/name` and :code:`path` are specified, then the :code:`path` cannot be absolute. It is considered relative to the root of the CodeQL pack.
        
        The relevant commands are:

        *   :code:`codeql database analyze`
        *   :code:`codeql database run-queries`
        *   :code:`codeql execute queries`
        *   :code:`codeql resolve queries`

Query Packs
-----------

Bug Fixes
~~~~~~~~~

Python
""""""

*   The `View AST functionality <https://docs.github.com/en/code-security/codeql-for-vs-code/using-the-advanced-functionality-of-the-codeql-for-vs-code-extension/exploring-the-structure-of-your-source-code>`__ no longer prints detailed information about regular expressions, greatly improving performance.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Cleartext transmission of sensitive information" (:code:`cpp/cleartext-transmission`) query has been further improved to reduce false positive results, and upgraded from :code:`medium` to :code:`high` precision.
*   The "Cleartext transmission of sensitive information" (:code:`cpp/cleartext-transmission`) query now finds more results, where a password is stored in a struct field or class member variable.
*   The :code:`cpp/cleartext-storage-file` query has been improved, removing false positives where data is written to a standard output stream.
*   The :code:`cpp/cleartext-storage-buffer` query has been updated to use the :code:`semmle.code.cpp.dataflow.TaintTracking` library.
*   The :code:`cpp/world-writable-file-creation` query now only detects :code:`open` and :code:`openat` calls with the :code:`O_CREAT` or :code:`O_TMPFILE` flag.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new query, :code:`cpp/open-call-with-mode-argument`, to detect when :code:`open` or :code:`openat` is called with the :code:`O_CREAT` or :code:`O_TMPFILE` flag but when the :code:`mode` argument is omitted.

Java/Kotlin
"""""""""""

*   A new query "Cleartext storage of sensitive information using a local database on Android" (:code:`java/android/cleartext-storage-database`) has been added. This query finds instances of sensitive data being stored in local databases without encryption, which may expose it to attackers or malicious applications.

JavaScript/TypeScript
"""""""""""""""""""""

*   A new query, :code:`js/unsafe-code-construction`, has been added to the query suite, highlighting libraries that may leave clients vulnerable to arbitrary code execution.
    The query is not run by default.
*   A new query :code:`js/file-system-race` has been added. The query detects when there is time between a file being checked and used. The query is not run by default.
*   A new query :code:`js/jwt-missing-verification` has been added. The query detects applications that don't verify JWT tokens.
*   The :code:`js/insecure-dependency` query has been added. It detects dependencies that are downloaded using an unencrypted connection.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added support for C# 10 lambda improvements

    *   Explicit return types on lambda expressions.
    *   Lambda expression can be tagged with method and return value attributes.
    
*   Added support for C# 10 `Extended property patterns <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#extended-property-patterns>`__.
*   Return value attributes are extracted.
*   The QL :code:`Attribute` class now has subclasses for each kind of attribute.
