.. _codeql-cli-2.18.1:

==========================
CodeQL 2.18.1 (2024-07-25)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.18.1 runs a total of 419 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 129 queries (covering 34 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   The *experimental* type :code:`QlBuiltins::BigInt` of arbitrary-precision integers has been introduced. To opt in to this API, compile your queries with
    :code:`--allow-experimental=bigint`. Big integers can be constructed using the
    :code:`.toBigInt()` methods of :code:`int` and :code:`string`. The built-in operations are:

    *   comparisons: :code:`=`, :code:`!=`, :code:`<`, :code:`<=`, :code:`>`, :code:`>=`,
    *   conversions: :code:`.toString()`, :code:`.toInt()`,
    *   arithmetic: binary :code:`+`, :code:`-`, :code:`*`, :code:`/`, :code:`%`, unary :code:`-`,
    *   bitwise operations: :code:`.bitAnd(BigInt)`, :code:`.bitOr(BigInt)`,
        :code:`.bitXor(BigInt)`, :code:`.bitShiftLeft(int)`, :code:`.bitShiftRightSigned(int)`,
        :code:`.bitNot()`,
    *   aggregates: :code:`min`, :code:`max`, (:code:`strict`):code:`sum`, (:code:`strict`):code:`count`, :code:`avg`,
        :code:`rank`, :code:`unique`, :code:`any`.
    *   other: :code:`.pow(int)`, :code:`.abs()`, :code:`.gcd(BigInt)`, :code:`.minimum(BigInt)`,
        :code:`.maximum(BigInt)`.
    
*   :code:`codeql test run` now supports postprocessing of test results. When .qlref files specify a path to a :code:`postprocess` query, then this is evaluated after the test query to transform the test outputs prior to concatenating them into the :code:`actual` results.

Improvements
~~~~~~~~~~~~

*   The 30% QL query compilation slowdown noted in 2.18.0 has been fixed.

Security Updates
~~~~~~~~~~~~~~~~

*   Resolves CVE-2023-4759, an arbitrary file overwrite in Eclipse JGit that can be triggered when using untrusted third-party queries from a git repository. See the
    \ `security advisory <https://github.com/github/codeql-cli-binaries/security/advisories/GHSA-x4gx-f2xv-6wj9>`__ for more information.
*   The following dependencies have been updated. These updates include security fixes in the respective libraries that prevent out-of-bounds accesses or denial-of-service in scenarios where untrusted files are processed. These scenarios are not likely to be encountered in most uses of CodeQL and code scanning, and only apply to advanced use cases where precompiled query packs,
    database ZIP files, or database TRAP files are obtained from untrusted sources and then processed on a trusted machine.

    *   airlift/aircompressor is updated to version 0.27.
    *   Apache Ant is updated to version 1.10.11.
    *   Apache Commons Compress is updated to version 1.26.0.
    *   Apache Commons IO is updated to version 2.15.1.
    *   Apache Commons Lang3 is updated to version 3.14.0.
    *   jsoup is updated to version 1.15.3.
    *   Logback is updated to version 1.2.13.
    *   Snappy is updated to version 0.5.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/unsigned-difference-expression-compared-zero` ("Unsigned difference expression compared to zero") query now produces fewer false positives.

Java/Kotlin
"""""""""""

*   The heuristic to enable certain Android queries has been improved. Now it ignores Android Manifests which don't define an activity, content provider or service. We also only consider files which are under a folder containing such an Android Manifest for these queries. This should remove some false positive alerts.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added a new query, :code:`js/functionality-from-untrusted-domain`, which detects uses in HTML and JavaScript scripts from untrusted domains, including the :code:`polyfill.io` content delivery network

    *   it can be extended to detect other compromised scripts using user-provided data extensions of the :code:`untrustedDomain` predicate, which takes one string argument with the domain to warn on (and will warn on any subdomains too).
    
*   Modified existing query, :code:`js/functionality-from-untrusted-source`, to allow adding this new query, but reusing the same logic

    *   Added the ability to use data extensions to require SRI on CDN hostnames using the :code:`isCdnDomainWithCheckingRequired` predicate, which takes one string argument of the full hostname to require SRI for.
    
*   Created a new library, :code:`semmle.javascript.security.FunctionalityFromUntrustedSource`, to support both queries.

New Queries
~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added a new query, :code:`js/insecure-helmet-configuration`, to detect instances where Helmet middleware is configured with important security features disabled.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The precision of :code:`cpp/iterator-to-expired-container` ("Iterator to expired container") has been increased to :code:`high`. As a result, it will be run by default as part of the Code Scanning suite.
*   The precision of :code:`cpp/unsafe-strncat` ("Potentially unsafe call to strncat") has been increased to :code:`high`. As a result, it will be run by default as part of the Code Scanning suite.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The Java extractor no longer supports the :code:`SEMMLE_DIST` legacy environment variable.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   There was a bug which meant that the built-in function :code:`clear` was considered as a sanitizer in some cases when it shouldn't have been. This has now been fixed, which may lead to more alerts.

Java/Kotlin
"""""""""""

*   Added a path-injection sink for :code:`hudson.FilePath.exists()`.
*   Added summary models for :code:`org.apache.commons.io.IOUtils.toByteArray`.
*   Java build-mode :code:`none` analyses now only report a warning on the CodeQL status page when there are significant analysis problems-- defined as 5% of expressions lacking a type, or 5% of call targets being unknown. Other messages reported on the status page are downgraded from warnings to notes and so are less prominent, but are still available for review.

Python
""""""

*   Additional modelling to detect direct writes to the :code:`Set-Cookie` header has been added for several web frameworks.

Swift
"""""

*   Additional heuristics for sensitive private information have been added to the :code:`SensitiveExprs.qll` library, improving coverage for credit card and social security numbers. This may result in additional results for queries that use sensitive data such as :code:`swift/cleartext-transmission`.

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The predicate :code:`isAndroid` from the module :code:`semmle.code.java.security.AndroidCertificatePinningQuery` has been deprecated. Use :code:`semmle.code.java.frameworks.android.Android::inAndroidApplication(File)` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Models-as-data alert provenance information has been extended to the C/C++ language. Any qltests that include the edges relation in their output (for example, :code:`.qlref`\ s that reference path-problem queries) will need to be have their expected output updated accordingly.
*   Added subclasses of :code:`BuiltInOperations` for :code:`__builtin_has_attribute`, :code:`__builtin_is_corresponding_member`, :code:`__builtin_is_pointer_interconvertible_with_class`, :code:`__is_assignable_no_precondition_check`, :code:`__is_bounded_array`, :code:`__is_convertible`, :code:`__is_corresponding_member`, :code:`__is_nothrow_convertible`, :code:`__is_pointer_interconvertible_with_class`, :code:`__is_referenceable`, :code:`__is_same_as`, :code:`__is_trivially_copy_assignable`, :code:`__is_unbounded_array`, :code:`__is_valid_winrt_type`, :code:`_is_win_class`, :code:`__is_win_interface`, :code:`__reference_binds_to_temporary`, :code:`__reference_constructs_from_temporary`, and :code:`__reference_converts_from_temporary`.
*   The class :code:`NewArrayExpr` adds a predicate :code:`getArraySize()` to allow a more convenient way to access the static size of the array when the extent is missing.

Java/Kotlin
"""""""""""

*   Kotlin support is now out of beta, and generally available
*   Kotlin versions up to 2.0.2*x* are now supported.

Swift
"""""

*   Swift support is now out of beta, and generally available.
