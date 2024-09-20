.. _codeql-cli-2.16.1:

==========================
CodeQL 2.16.1 (2024-01-25)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.16.1 runs a total of 406 security queries when configured with the Default suite (covering 160 CWE). The Extended suite enables an additional 129 queries (covering 34 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   When executing the :code:`codeql database init` command, the CodeQL runner executable path is now stored in the :code:`CODEQL_RUNNER` environment variable.
    Users of indirect tracing on MacOS with System Integrity Protection enabled who previously had trouble with indirect tracing should prefix their build command with this path. For example, :code:`$CODEQL_RUNNER build.sh`.

QL Language
~~~~~~~~~~~

*   Name clashes between weak aliases (i.e. aliases that are not final aliases of non-final entities) of the same target no longer cause ambiguity errors.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/include-non-header` style query will now ignore the :code:`.def` extension for textual header inclusions.

C#
""

*   Modelled additional flow steps to track flow from handler methods of a :code:`PageModel` class to the corresponding Razor Page (:code:`.cshtml`) file, which may result in additional results for queries such as :code:`cs/web/xss`.

Golang
""""""

*   The query :code:`go/insecure-randomness` now recognizes the selection of candidates from a predefined set using a weak RNG when the result is used in a sensitive operation. Also, false positives have been reduced by adding more sink exclusions for functions in the :code:`crypto` package not related to cryptographic operations.
*   Added more sources and sinks to the query :code:`go/clear-text-logging`.

Java/Kotlin
"""""""""""

*   A manual neutral summary model for a callable now blocks all generated summary models for that callable from having any effect.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for `doT <https://github.com/olado/doT>`__ templates.

Python
""""""

*   Added modeling of YARL's :code:`is_absolute` method and checks of the :code:`netloc` of a parsed URL as sanitizers for the :code:`py/url-redirection` query, leading to fewer false positives.

Swift
"""""

*   The diagnostic query :code:`swift/diagnostics/successfully-extracted-files` now considers any Swift file seen during extraction, even one with some errors, to be extracted / scanned. This affects the Code Scanning UI measure of scanned Swift files.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added the :code:`java/exec-tainted-environment` query, to detect the injection of environment variables names or values from remote input.

Swift
"""""

*   Added new query "Use of an inappropriate cryptographic hashing algorithm on passwords" (:code:`swift/weak-password-hashing`). This query detects use of inappropriate hashing algorithms for password hashing. Some of the results of this query are new, others would previously have been reported by the "Use of a broken or weak cryptographic hashing algorithm on sensitive data" (:code:`swift/weak-sensitive-data-hashing`) query.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Java/Kotlin
"""""""""""

*   Fixed regular expressions containing flags not being parsed correctly in some cases.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted many deprecated predicates and classes with uppercase :code:`XML`, :code:`SSA`, :code:`SAL`, :code:`SQL`, etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`StrcatFunction` class, use :code:`semmle.code.cpp.models.implementations.Strcat.qll` instead.

C#
""

*   Deleted many deprecated predicates and classes with uppercase :code:`SSL`, :code:`XML`, :code:`URI`, :code:`SSA` etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`getALocalFlowSucc` predicate and :code:`TaintType` class from the dataflow library.
*   Deleted the deprecated :code:`Newobj` and :code:`Rethrow` classes, use :code:`NewObj` and :code:`ReThrow` instead.
*   Deleted the deprecated :code:`getAFirstRead`, :code:`hasAdjacentReads`, :code:`lastRefBeforeRedef`, and :code:`hasLastInputRef` predicates from the SSA library.
*   Deleted the deprecated :code:`getAReachableRead` predicate from the :code:`AssignableRead` and :code:`VariableRead` classes.
*   Deleted the deprecated :code:`hasQualifiedName` predicate from the :code:`NamedElement` class.
*   C# 12: Add extractor support and QL library support for inline arrays.
*   Fixed a Log forging false positive when logging the value of a nullable simple type. This fix also applies to all other queries that use the simple type sanitizer.
*   The diagnostic query :code:`cs/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned C# files, now considers any C# file seen during extraction, even one with some errors, to be extracted / scanned.
*   Added a new library :code:`semmle.code.csharp.security.dataflow.flowsources.FlowSources`, which provides a new class :code:`ThreatModelFlowSource`. The :code:`ThreatModelFlowSource` class can be used to include sources which match the current *threat model* configuration.
*   A manual neutral summary model for a callable now blocks all generated summary models for that callable from having any effect.
*   C# 12: Add extractor support for lambda expressions with parameter defaults like :code:`(int x, int y = 1) => ...` and lambda expressions with a :code:`param` parameter like :code:`(params int[] x) => ...)`.

Golang
""""""

*   Deleted many deprecated predicates and classes with uppercase :code:`TLD`, :code:`HTTP`, :code:`SQL`, :code:`URL` etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated and unused :code:`Source` class from the :code:`SharedXss` module of :code:`Xss.qll`
*   Support for flow sources in `AWS Lambda function handlers <https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html>`__ has been added.
*   Support for the `fasthttp framework <https://github.com/valyala/fasthttp/>`__ has been added.

Java/Kotlin
"""""""""""

*   Deleted many deprecated predicates and classes with uppercase :code:`EJB`, :code:`JMX`, :code:`NFE`, :code:`DNS` etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`semmle/code/java/security/OverlyLargeRangeQuery.qll`, :code:`semmle/code/java/security/regexp/ExponentialBackTracking.qll`, :code:`semmle/code/java/security/regexp/NfaUtils.qll`, and :code:`semmle/code/java/security/regexp/NfaUtils.qll` files.
*   Improved models for :code:`java.lang.Throwable` and :code:`java.lang.Exception`, and the :code:`valueOf` method of :code:`java.lang.String`.
*   Added taint tracking for the following GSON methods:

    *   :code:`com.google.gson.stream.JsonReader` constructor
    *   :code:`com.google.gson.stream.JsonWriter` constructor
    *   :code:`com.google.gson.JsonObject.getAsJsonArray`
    *   :code:`com.google.gson.JsonObject.getAsJsonObject`
    *   :code:`com.google.gson.JsonObject.getAsJsonPrimitive`
    *   :code:`com.google.gson.JsonParser.parseReader`
    *   :code:`com.google.gson.JsonParser.parseString`
    
*   Added a dataflow model for :code:`java.awt.Desktop.browse(URI)`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Deleted many deprecated predicates and classes with uppercase :code:`CPU`, :code:`TLD`, :code:`SSA`, :code:`ASM` etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`getMessageSuffix` predicates in :code:`CodeInjectionCustomizations.qll`.
*   Deleted the deprecated :code:`semmle/javascript/security/dataflow/ExternalAPIUsedWithUntrustedData.qll` file.
*   Deleted the deprecated :code:`getANonHtmlHeaderDefinition` and :code:`nonHtmlContentTypeHeader` predicates from :code:`ReflectedXssCustomizations.qll`.
*   Deleted the deprecated :code:`semmle/javascript/security/OverlyLargeRangeQuery.qll`, :code:`semmle/javascript/security/regexp/ExponentialBackTracking.qll`, :code:`semmle/javascript/security/regexp/NfaUtils.qll`, and :code:`semmle/javascript/security/regexp/NfaUtils.qll` files.
*   Deleted the deprecated :code:`Expressions/TypoDatabase.qll` file.
*   The diagnostic query :code:`js/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned JavaScript and TypeScript files, now considers any JavaScript and TypeScript file seen during extraction, even one with some errors, to be extracted / scanned.

Python
""""""

*   Deleted many deprecated predicates and classes with uppercase :code:`LDAP`, :code:`HTTP`, :code:`URL`, :code:`CGI` etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`localSourceStoreStep` predicate, use :code:`flowsToStoreStep` instead.
*   Deleted the deprecated :code:`iteration_defined_variable` predicate from the :code:`SSA` library.
*   Deleted various deprecated predicates from the points-to libraries.
*   Deleted the deprecated :code:`semmle/python/security/OverlyLargeRangeQuery.qll`, :code:`semmle/python/security/regexp/ExponentialBackTracking.qll`, :code:`semmle/python/security/regexp/NfaUtils.qll`, and :code:`semmle/python/security/regexp/NfaUtils.qll` files.
*   The diagnostic query :code:`py/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Python files, now considers any Python file seen during extraction, even one with some errors, to be extracted / scanned.

Ruby
""""

*   Deleted many deprecated predicates and classes with uppercase :code:`HTTP`, :code:`CSRF` etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`getAUse` and :code:`getARhs` predicates from :code:`API::Node`, use :code:`getASource` and :code:`getASink` instead.
*   Deleted the deprecated :code:`disablesCertificateValidation` predicate from the :code:`Http` module.
*   Deleted the deprecated :code:`ParamsCall`, :code:`CookiesCall`, and :code:`ActionControllerControllerClass` classes from :code:`ActionController.qll`, use the simarly named classes from :code:`codeql.ruby.frameworks.Rails::Rails` instead.
*   Deleted the deprecated :code:`HtmlSafeCall`, :code:`HtmlEscapeCall`, :code:`RenderCall`, and :code:`RenderToCall` classes from :code:`ActionView.qll`, use the simarly named classes from :code:`codeql.ruby.frameworks.Rails::Rails` instead.
*   Deleted the deprecated :code:`HtmlSafeCall` class from :code:`Rails.qll`.
*   Deleted the deprecated :code:`codeql/ruby/security/BadTagFilterQuery.qll`, :code:`codeql/ruby/security/OverlyLargeRangeQuery.qll`, :code:`codeql/ruby/security/regexp/ExponentialBackTracking.qll`, :code:`codeql/ruby/security/regexp/NfaUtils.qll`, :code:`codeql/ruby/security/regexp/RegexpMatching.qll`, and :code:`codeql/ruby/security/regexp/SuperlinearBackTracking.qll` files.
*   Deleted the deprecated :code:`localSourceStoreStep` predicate from :code:`TypeTracker.qll`, use :code:`flowsToStoreStep` instead.
*   The diagnostic query :code:`rb/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Ruby files, now considers any Ruby file seen during extraction, even one with some errors, to be extracted / scanned.

Swift
"""""

*   Swift upgraded to 5.9.2
*   The control flow graph library (:code:`codeql.swift.controlflow`) has been transitioned to use the shared implementation from the :code:`codeql/controlflow` qlpack. No result changes are expected due to this change.

Deprecated APIs
~~~~~~~~~~~~~~~

Golang
""""""

*   The class :code:`Fmt::AppenderOrSprinter` of the :code:`Fmt.qll` module has been deprecated. Use the new :code:`Fmt::AppenderOrSprinterFunc` class instead. Its taint flow features have been migrated to models-as-data.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new library :code:`semmle.code.java.security.Sanitizers` which contains a new sanitizer class :code:`SimpleTypeSanitizer`, which represents nodes which cannot realistically carry taint for most queries (e.g. primitives, their boxed equivalents, and numeric types).
*   Converted definitions of :code:`isBarrier` and sanitizer classes to use :code:`SimpleTypeSanitizer` instead of checking if :code:`node.getType()` is :code:`PrimitiveType` or :code:`BoxedType`.

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Static Single Assignment (SSA)
""""""""""""""""""""""""""""""

*   Deleted the deprecated :code:`adjacentDefNoUncertainReads`, :code:`lastRefRedefNoUncertainReads`, and :code:`lastRefNoUncertainReads` predicates.
