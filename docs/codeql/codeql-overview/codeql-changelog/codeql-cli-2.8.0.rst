.. _codeql-cli-2.8.0:

=========================
CodeQL 2.8.0 (2022-02-04)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.8.0 runs a total of 298 security queries when configured with the Default suite (covering 136 CWE). The Extended suite enables an additional 93 queries (covering 30 more CWE). 14 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The CodeQL Action versions up to and including version 1.0.22 are not compatible with the CodeQL CLI 2.8.0 and later. The CLI will emit an error if it detects that it is being used by an incompatible version of the codeql-action.

Bug Fixes
~~~~~~~~~

*   Fixed a bug where :code:`codeql resolve upgrades` ignores the
    :code:`--target-dbscheme` option.

New Features
~~~~~~~~~~~~

*   A new extractor option has been added to the Java extractor. The flag :code:`--extractor-option exclude='<glob>'` allows specifying a glob that describes which paths need to be excluded from extraction but still need to be compiled. This is useful when some files are necessary for a successful build but are uninteresting for analysis.
    
    See also: https://codeql.github.com/docs/codeql-cli/extractor-options/
    
*   Summary metrics can now associate messages with their results, for instance to report the name and number of uses of a particular API endpoint within a repository. To associate messages with summary metrics, define a query with :code:`@kind metric` and :code:`@tags summary` metadata and use either the :code:`location, message, value` or the :code:`message, value` results pattern.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   User names and other account information is no longer considered to be sensitive data for the queries :code:`py/clear-text-logging-sensitive-data` and :code:`py/clear-text-storage-sensitive-data`, since this lead to many false positives.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Fix an issue with the :code:`cpp/declaration-hides-variable` query where it would report variables that are unnamed in a database.
*   The :code:`cpp/cleartext-storage-file` query has been upgraded with non-local taint flow and has been converted to a :code:`path-problem` query.
*   The :code:`cpp/return-stack-allocated-memory` query has been improved to produce fewer false positives. The query has also been converted to a :code:`path-problem` query.
*   The "Cleartext transmission of sensitive information" (:code:`cpp/cleartext-transmission`) query has been improved in several ways to reduce false positive results.
*   The "Potential improper null termination" (:code:`cpp/improper-null-termination`) query now produces fewer false positive results around control flow branches and loops.
*   Added exception for GLib's gboolean to cpp/ambiguously-signed-bit-field.
    This change reduces the number of false positives in the query.

Ruby
""""

*   The query :code:`rb/csrf-protection-disabled` has been extended to find calls to the Rails method :code:`protect_from_forgery` that may weaken CSRF protection.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   The :code:`security` tag has been added to the :code:`cpp/return-stack-allocated-memory` query. As a result, its results will now appear by default.
*   The "Uncontrolled data in arithmetic expression" (cpp/uncontrolled-arithmetic) query has been enhanced to reduce false positive results and its @precision increased to high.
*   A new :code:`cpp/very-likely-overrunning-write` query has been added to the default query suite for C/C++. The query reports some results that were formerly flagged by :code:`cpp/overrunning-write`.

Java/Kotlin
"""""""""""

*   A new query "Use of implicit PendingIntents" (:code:`java/android/pending-intents`) has been added.
    This query finds implicit and mutable :code:`PendingIntents` sent to an unspecified third party component, which may provide an attacker with access to internal components of the application or cause other unintended effects.
*   Two new queries, "Android fragment injection" (:code:`java/android/fragment-injection`) and "Android fragment injection in PreferenceActivity" (:code:`java/android/fragment-injection-preference-activity`) have been added.
    These queries find exported Android activities that instantiate and host fragments created from user-provided data. Such activities are vulnerable to access control bypass and expose the Android application to unintended effects.
*   The query "\ :code:`TrustManager` that accepts all certificates" (:code:`java/insecure-trustmanager`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @intrigus-lgtm <https://github.com/github/codeql/pull/4879>`__.
*   The query "Log Injection" (:code:`java/log-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. The query was originally `submitted as an experimental query by @porcupineyhairs and @dellalibera <https://github.com/github/codeql/pull/5099>`__.
*   A new query "Intent URI permission manipulation" (:code:`java/android/intent-uri-permission-manipulation`) has been added.
    This query finds Android components that return unmodified, received Intents to the calling applications, which can provide unintended access to internal content providers of the victim application.
*   A new query "Cleartext storage of sensitive information in the Android filesystem" (:code:`java/android/cleartext-storage-filesystem`) has been added. This query finds instances of sensitive data being stored in local files without encryption, which may expose it to attackers or malicious applications.
*   The query "Cleartext storage of sensitive information using :code:`SharedPreferences` on Android" (:code:`java/android/cleartext-storage-shared-prefs`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @luchua-bc <https://github.com/github/codeql/pull/4675>`__.
*   The query "Unsafe certificate trust" (:code:`java/unsafe-cert-trust`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @luchua-bc <https://github.com/github/codeql/pull/3550>`__.

JavaScript/TypeScript
"""""""""""""""""""""

*   A new query :code:`js/samesite-none-cookie` has been added. The query detects when the SameSite attribute is set to None on a sensitive cookie.
*   A new query :code:`js/empty-password-in-configuration-file` has been added. The query detects empty passwords in configuration files. The query is not run by default.

Ruby
""""

*   Added a new query, :code:`rb/weak-cookie-configuration`. The query finds cases where cookie configuration options are set to values that may make an application more vulnerable to certain attacks.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The "Random used only once" (:code:`java/random-used-once`) query no longer has a :code:`security-severity` score. This has been causing some tools to categorise it as a security query, when it is more useful as a code-quality query.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added support for the following C# 10 features.
*   \ `Record structs <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#record-structs>`__.
*   \ `Improvements of structure types <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#improvements-of-structure-types>`__.

    *   Instance parameterless constructor in a structure type.
    *   Enhance :code:`WithExpr` in QL to support :code:`structs` and anonymous classes.
    
*   \ `Global using directives <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#global-using-directives>`__.
*   \ `File-scoped namespace declaration <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#file-scoped-namespace-declaration>`__.
*   \ `Enhanced #line pragma <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#enhanced-line-pragma>`__.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   :code:`FormatLiteral::getMaxConvertedLength` now uses range analysis to provide a more accurate length for integers formatted with :code:`%x`

C#
""

*   The query :code:`cs/local-shadows-member` no longer highlights parameters of :code:`record` types.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`codeql/cpp-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the :code:`codeql/cpp-all` CodeQL pack.

C#
""

*   The :code:`codeql/csharp-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the :code:`codeql/csharp-all` CodeQL pack.

Java/Kotlin
"""""""""""

*   The :code:`codeql/java-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the :code:`codeql/java-all` CodeQL pack.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`codeql/javascript-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the :code:`codeql/javascript-all` CodeQL pack.

Python
""""""

*   Moved the files defining regex injection configuration and customization, instead of :code:`import semmle.python.security.injection.RegexInjection` please use :code:`import semmle.python.security.dataflow.RegexInjection` (the same for :code:`RegexInjectionCustomizations`).
*   The :code:`codeql/python-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the :code:`codeql/python-all` CodeQL pack.
