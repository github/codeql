.. _codeql-cli-2.10.4:

==========================
CodeQL 2.10.4 (2022-08-31)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.10.4 runs a total of 352 security queries when configured with the Default suite (covering 146 CWE). The Extended suite enables an additional 106 queries (covering 30 more CWE). 12 security queries have been added with this release.

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Cleartext storage of sensitive information in buffer" (:code:`cpp/cleartext-storage-buffer`) query has been improved to produce fewer false positives.

C#
""

*   Parameters of delegates passed to routing endpoint calls like :code:`MapGet` in ASP.NET Core are now considered remote flow sources.
*   The query :code:`cs/unsafe-deserialization-untrusted-input` is not reporting on all calls of :code:`JsonConvert.DeserializeObject` any longer, it only covers cases that explicitly use unsafe serialization settings.
*   Added better support for the SQLite framework in the SQL injection query.
*   File streams are now considered stored flow sources. For example, reading query elements from a file can lead to a Second Order SQL injection alert.

Java/Kotlin
"""""""""""

*   The query :code:`java/static-initialization-vector` no longer requires a :code:`Cipher` object to be initialized with :code:`ENCRYPT_MODE` to be considered a valid sink. Also, several new sanitizers were added.
*   Improved sanitizers for :code:`java/sensitive-log`, which removes some false positives and improves performance a bit.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/android/implicitly-exported-component`, to detect if components are implicitly exported in the Android manifest.
*   A new query "Use of RSA algorithm without OAEP" (:code:`java/rsa-without-oaep`) has been added. This query finds uses of RSA encryption that don't use the OAEP scheme.
*   Added a new query, :code:`java/android/debuggable-attribute-enabled`, to detect if the :code:`android:debuggable` attribute is enabled in the Android manifest.
*   The query "Using a static initialization vector for encryption" (:code:`java/static-initialization-vector`) has been promoted from experimental to the main query pack. This query was originally `submitted as an experimental query by @artem-smotrakov <https://github.com/github/codeql/pull/6357>`__.
*   A new query :code:`java/partial-path-traversal` finds partial path traversal vulnerabilities resulting from incorrectly using
    :code:`String#startsWith` to compare canonical paths.
*   Added a new query, :code:`java/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match
    too many characters.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added a new query, :code:`py/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match
    too many characters.

Python
""""""

*   Added a new query, :code:`py/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match
    too many characters.

Ruby
""""

*   Added a new query, :code:`rb/log-injection`, to detect cases where a malicious user may be able to forge log entries.
*   Added a new query, :code:`rb/incomplete-multi-character-sanitization`. The query finds string transformations that do not replace all occurrences of a multi-character substring.
*   Added a new query, :code:`rb/suspicious-regexp-range`, to detect character ranges in regular expressions that seem to match
    too many characters.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The queries :code:`java/redos` and :code:`java/polynomial-redos` now have a tag for CWE-1333.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed that top-level :code:`for await` statements would produce a syntax error. These statements are now parsed correctly.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

C#
""

*   All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

Golang
""""""

*   Go 1.19 is now supported, including adding new taint propagation steps for new standard-library functions introduced in this release.
*   Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.
*   Fixed data-flow to captured variable references.
*   We now assume that if a channel-typed field is only referred to twice in the user codebase, once in a send operation and once in a receive, then data flows from the send to the receive statement. This enables finding some cross-goroutine flow.

Java/Kotlin
"""""""""""

*   Added new flow steps for the classes :code:`java.nio.file.Path` and :code:`java.nio.file.Paths`.
*   The class :code:`AndroidFragment` now also models the Android Jetpack version of the :code:`Fragment` class (:code:`androidx.fragment.app.Fragment`).
*   Java 19 builds can now be extracted. There are no non-preview new language features in this release, so the only user-visible change is that the CodeQL extractor will now correctly trace compilations using the JDK 19 release of :code:`javac`.
*   Classes and methods that are seen with several different paths during the extraction process (for example, packaged into different JAR files) now report an arbitrarily selected location via their :code:`getLocation` and :code:`hasLocationInfo` predicates, rather than reporting all of them. This may lead to reduced alert duplication.
*   The query :code:`java/hardcoded-credential-api-call` now recognises methods that consume usernames, passwords and keys from the JSch, Ganymed, Apache SSHD, sshj, Trilead SSH-2, Apache FTPClient and MongoDB projects.

JavaScript/TypeScript
"""""""""""""""""""""

*   Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

Python
""""""

*   Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

Ruby
""""

*   Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.
*   Calls to :code:`render` in Rails controllers and views are now recognized as HTTP response bodies.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

C#
""

*   Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Java/Kotlin
"""""""""""

*   Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.
*   The utility files previously in the :code:`semmle.code.java.security.performance` package have been moved to the :code:`semmle.code.java.security.regexp` package.
    
    The previous files still exist as deprecated aliases.

JavaScript/TypeScript
"""""""""""""""""""""

*   Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.
*   The utility files previously in the :code:`semmle.javascript.security.performance` package have been moved to the :code:`semmle.javascript.security.regexp` package.
    
    The previous files still exist as deprecated aliases.

Python
""""""

*   Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.
*   The utility files previously in the :code:`semmle.python.security.performance` package have been moved to the :code:`semmle.python.security.regexp` package.
    
    The previous files still exist as deprecated aliases.

Ruby
""""

*   The utility files previously in the :code:`codeql.ruby.security.performance` package have been moved to the :code:`codeql.ruby.security.regexp` package.
    
    The previous files still exist as deprecated aliases.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added support for getting the link targets of global and namespace variables.
*   Added a :code:`BlockAssignExpr` class, which models a :code:`memcpy`\ -like operation used in compiler generated copy/move constructors and assignment operations.

Java/Kotlin
"""""""""""

*   Added a new predicate, :code:`requiresPermissions`, in the :code:`AndroidComponentXmlElement` and :code:`AndroidApplicationXmlElement` classes to detect if the element has explicitly set a value for its :code:`android:permission` attribute.
*   Added a new predicate, :code:`hasAnIntentFilterElement`, in the :code:`AndroidComponentXmlElement` class to detect if a component contains an intent filter element.
*   Added a new predicate, :code:`hasExportedAttribute`, in the :code:`AndroidComponentXmlElement` class to detect if a component has an :code:`android:exported` attribute.
*   Added a new class, :code:`AndroidCategoryXmlElement`, to represent a category element in an Android manifest file.
*   Added a new predicate, :code:`getACategoryElement`, in the :code:`AndroidIntentFilterXmlElement` class to get a category element of an intent filter.
*   Added a new predicate, :code:`isInBuildDirectory`, in the :code:`AndroidManifestXmlFile` class. This predicate detects if the manifest file is located in a build directory.
*   Added a new predicate, :code:`isDebuggable`, in the :code:`AndroidApplicationXmlElement` class. This predicate detects if the application element has its :code:`android:debuggable` attribute enabled.
