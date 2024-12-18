.. _codeql-cli-2.13.0:

==========================
CodeQL 2.13.0 (2023-04-20)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.13.0 runs a total of 388 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 124 queries (covering 30 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   In :code:`codeql pack add`, the dependency that is added to the :code:`qlpack.yml` file will now allow any version of the pack that is compatible with the specified version (:code:`^version`) in the following cases:

    *   When no version is specified (:code:`codeql pack add codeql/cpp-all`).
    *   When the version is specified as :code:`latest` (:code:`codeql pack add codeql/cpp-all@latest`).
    *   When a single version is specified (:code:`codeql pack add codeql/cpp-all@1.0.0`).
    
    The :code:`^version` dependency allows any version of that pack with no breaking changes since :code:`version`.
    For example, :code:`^1.2.3` would allow versions :code:`1.2.3`, :code:`1.2.5`, and :code:`1.4.0`, but not :code:`2.0.0`, because changing the major version number to :code:`2` indicates a breaking change.
    
    Using :code:`^version` ensures that the added pack is not needlessly constrained to an exact version by default.
    
*   Upper-case variable names are no longer accepted by the QL compiler.
    
    Such variable names have produced a deprecation warning since release 2.9.2 (released 2022-05-16), so QL code that compiles without warnings with a recent release of the CLI should still work.

Deprecations
~~~~~~~~~~~~

*   The possibility to omit :code:`override` annotations on class member predicates that override a base class predicate has been deprecated.
    This is to avoid confusion with shadowing behaviour in the presence of final member predicates.

    ..  code-block:: ql
    
        class Foo extends Base {
          final predicate foo() { ... }
        
          predicate bar() { ... }
        
          predicate baz() { ... }
        }
        
        class Bar extends Foo {
          // This method shadows Foo::foo.
          predicate foo() { ... }
        
          // This used to override Foo::bar with a warning, is now deprecated.
          predicate bar() { ... }
        
          // This correctly overrides Foo::baz
          override predicate baz() { ... }
        }

New Features
~~~~~~~~~~~~

*   :code:`codeql database analyze` and related commands now export file coverage information by default. GHAS customers using CodeQL in third-party CI systems will now see file coverage information on the
    \ `tool status page <https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-the-tool-status-page>`__ without needing to modify their CI workflows.

Known Issues
~~~~~~~~~~~~

*   We recommend that customers using the CodeQL CLI in a third party CI system do not upgrade to this release, due to an issue with :code:`codeql github upload-results`. Instead, please use CodeQL 2.12.5, or, when available, CodeQL 2.12.7 or 2.13.1. For more information, see the
    "Known issues" section for CodeQL 2.12.6.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug where a destructuring pattern could not be parsed if it had a property named :code:`get` or :code:`set` with a default value.

Python
""""""

*   Nonlocal variables are excluded from alerts.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The query :code:`cpp/tainted-arithmetic` now also flags possible overflows in arithmetic assignment operations.

C#
""

*   The query :code:`cs/web/debug-binary` now disregards the :code:`debug` attribute in case there is a transformation that removes it.

Golang
""""""

*   The receiver arguments of :code:`net/http.Header.Set` and :code:`.Del` are no longer flagged by query :code:`go/untrusted-data-to-external-api`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`DisablingCertificateValidation.ql` query has been updated to check :code:`createServer` from :code:`https` for disabled certificate validation.
*   Improved the model of jQuery to account for XSS sinks where the HTML string is provided via a callback. This may lead to more results for the :code:`js/xss` query.
*   The :code:`js/weak-cryptographic-algorithm` query now flags cryptograhic operations using a weak block mode,
    such as AES-ECB.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   The query :code:`cpp/redundant-null-check-simple` has been promoted to Code Scanning. The query finds cases where a pointer is compared to null after it has already been dereferenced. Such comparisons likely indicate a bug at the place where the pointer is dereferenced, or where the pointer is compared to null.

Java/Kotlin
"""""""""""

*   The query :code:`java/insecure-ldap-auth` has been promoted from experimental to the main query pack. This query detects transmission of cleartext credentials in LDAP authentication. Insecure LDAP authentication causes sensitive information to be vulnerable to remote attackers. This query was originally `submitted as an experimental query by @luchua-bc <https://github.com/github/codeql/pull/4854>`__

Ruby
""""

*   Added a new experimental query, :code:`rb/server-side-template-injection`, to detect cases where user input may be embedded into a template's code in an unsafe manner.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular :code:`DataFlow::hasFlowPath`, :code:`DataFlow::hasFlow`, :code:`DataFlow::hasFlowTo`, and :code:`DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

C#
""

*   Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular :code:`DataFlow::hasFlowPath`, :code:`DataFlow::hasFlow`, :code:`DataFlow::hasFlowTo`, and :code:`DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

Golang
""""""

*   Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular :code:`DataFlow::hasFlowPath`, :code:`DataFlow::hasFlow`, :code:`DataFlow::hasFlowTo`, and :code:`DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

Java/Kotlin
"""""""""""

*   Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular :code:`DataFlow::hasFlowPath`, :code:`DataFlow::hasFlow`, :code:`DataFlow::hasFlowTo`, and :code:`DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

Python
""""""

*   Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular, :code:`DataFlow::hasFlowPath`, :code:`DataFlow::hasFlow`, :code:`DataFlow::hasFlowTo`, and :code:`DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

Ruby
""""

*   Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular :code:`DataFlow::hasFlowPath`, :code:`DataFlow::hasFlow`, :code:`DataFlow::hasFlowTo`, and :code:`DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The internal :code:`SsaConsistency` module has been moved from :code:`SSAConstruction` to :code:`SSAConsitency`, and the deprecated :code:`SSAConsistency` module has been removed.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 5.0.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`BufferAccess` library (:code:`semmle.code.cpp.security.BufferAccess`) no longer matches buffer accesses inside unevaluated contexts (such as inside :code:`sizeof` or :code:`decltype` expressions). As a result, queries using this library may see fewer false positives.

Java/Kotlin
"""""""""""

*   Fixed a bug in the regular expression used to identify sensitive information in :code:`SensitiveActions::getCommonSensitiveInfoRegex`. This may affect the results of the queries :code:`java/android/sensitive-communication`, :code:`java/android/sensitive-keyboard-cache`, and :code:`java/sensitive-log`.
*   Added a summary model for the :code:`java.lang.UnsupportedOperationException(String)` constructor.
*   The filenames embedded in :code:`Compilation.toString()` now use :code:`/` as the path separator on all platforms.
*   Added models for the following packages:

    *   :code:`java.lang`
    *   :code:`java.net`
    *   :code:`java.nio.file`
    *   :code:`java.io`
    *   :code:`java.lang.module`
    *   :code:`org.apache.commons.httpclient.util`
    *   :code:`org.apache.commons.io`
    *   :code:`org.apache.http.client`
    *   :code:`org.eclipse.jetty.client`
    *   :code:`com.google.common.io`
    *   :code:`kotlin.io`
    
*   Added the :code:`TaintedPathQuery.qll` library to provide the :code:`TaintedPathFlow` and :code:`TaintedPathLocalFlow` taint-tracking modules to reason about tainted path vulnerabilities.
*   Added the :code:`ZipSlipQuery.qll` library to provide the :code:`ZipSlipFlow` taint-tracking module to reason about zip-slip vulnerabilities.
*   Added the :code:`InsecureBeanValidationQuery.qll` library to provide the :code:`BeanValidationFlow` taint-tracking module to reason about bean validation vulnerabilities.
*   Added the :code:`XssQuery.qll` library to provide the :code:`XssFlow` taint-tracking module to reason about cross site scripting vulnerabilities.
*   Added the :code:`LdapInjectionQuery.qll` library to provide the :code:`LdapInjectionFlow` taint-tracking module to reason about LDAP injection vulnerabilities.
*   Added the :code:`ResponseSplittingQuery.qll` library to provide the :code:`ResponseSplittingFlow` taint-tracking module to reason about response splitting vulnerabilities.
*   Added the :code:`ExternallyControlledFormatStringQuery.qll` library to provide the :code:`ExternallyControlledFormatStringFlow` taint-tracking module to reason about externally controlled format string vulnerabilities.
*   Improved the handling of addition in the range analysis. This can cause in minor changes to the results produced by :code:`java/index-out-of-bounds` and :code:`java/constant-comparison`.
*   A new models as data sink kind :code:`command-injection` has been added.
*   The queries :code:`java/command-line-injection` and :code:`java/concatenated-command-line` now can be extended using the :code:`command-injection` models as data sink kind.
*   Added more sink and summary dataflow models for the following packages:

    *   :code:`java.net`
    *   :code:`java.nio.file`
    *   :code:`javax.imageio.stream`
    *   :code:`javax.naming`
    *   :code:`javax.servlet`
    *   :code:`org.geogebra.web.full.main`
    *   :code:`hudson`
    *   :code:`hudson.cli`
    *   :code:`hudson.lifecycle`
    *   :code:`hudson.model`
    *   :code:`hudson.scm`
    *   :code:`hudson.util`
    *   :code:`hudson.util.io`
    
*   Added the extensible abstract class :code:`JndiInjectionSanitizer`. Now this class can be extended to add more sanitizers to the :code:`java/jndi-injection` query.
*   Added a summary model for the :code:`nativeSQL` method of the :code:`java.sql.Connection` interface.
*   Added sink and summary dataflow models for the Jenkins and Netty frameworks.
*   The Models as Data syntax for selecting the qualifier has been changed from :code:`-1` to :code:`this` (e.g. :code:`Argument[-1]` is now written as :code:`Argument[this]`).
*   Added sources and flow step models for the Netty framework up to version 4.1.
*   Added more dataflow models for frequently-used JDK APIs.

JavaScript/TypeScript
"""""""""""""""""""""

*   :code:`router.push` and :code:`router.replace` in :code:`Next.js` are now considered as XSS sink.
*   The crypto-js module in :code:`CryptoLibraries.qll` now supports progressive hashing with algo.update().

Python
""""""

*   Added modeling of SQL execution in the packages :code:`sqlite3.dbapi2`, :code:`cassandra-driver`, :code:`aiosqlite`, and the functions :code:`sqlite3.Connection.executescript`\ /\ :code:`sqlite3.Cursor.executescript` and :code:`asyncpg.connection.connect()`.
*   Fixed module resolution so we allow imports of definitions that have had an attribute assigned to it, such as :code:`class Foo; Foo.bar = 42`.

Ruby
""""

*   Control flow graph: the evaluation order of scope expressions and receivers in multiple assignments has been adjusted to match the changes made in Ruby
    3.1 and 3.2.
*   The clear-text storage (:code:`rb/clear-text-storage-sensitive-data`) and logging (:code:`rb/clear-text-logging-sensitive-data`) queries now use built-in flow through hashes, for improved precision. This may result in both new true positives and less false positives.
*   Accesses of :code:`params` in Sinatra applications are now recognized as HTTP input accesses.
*   Data flow is tracked from Sinatra route handlers to ERB files.
*   Data flow is tracked between basic Sinatra filters (those without URL patterns) and their corresponding route handlers.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The single-parameter predicates :code:`ArrayOrVectorAggregateLiteral.getElementExpr` and :code:`ClassAggregateLiteral.getFieldExpr` have been deprecated in favor of :code:`ArrayOrVectorAggregateLiteral.getAnElementExpr` and :code:`ClassAggregateLiteral.getAFieldExpr`.
*   The recently introduced new data flow and taint tracking APIs have had a number of module and predicate renamings. The old APIs remain in place for now.
*   The :code:`SslContextCallAbstractConfig`, :code:`SslContextCallConfig`, :code:`SslContextCallBannedProtocolConfig`, :code:`SslContextCallTls12ProtocolConfig`, :code:`SslContextCallTls13ProtocolConfig`, :code:`SslContextCallTlsProtocolConfig`, :code:`SslContextFlowsToSetOptionConfig`, :code:`SslOptionConfig` dataflow configurations from :code:`BoostorgAsio` have been deprecated. Please use :code:`SslContextCallConfigSig`, :code:`SslContextCallGlobal`, :code:`SslContextCallFlow`, :code:`SslContextCallBannedProtocolFlow`, :code:`SslContextCallTls12ProtocolFlow`, :code:`SslContextCallTls13ProtocolFlow`, :code:`SslContextCallTlsProtocolFlow`, :code:`SslContextFlowsToSetOptionFlow`.

C#
""

*   The recently introduced new data flow and taint tracking APIs have had a number of module and predicate renamings. The old APIs remain in place for now.

Golang
""""""

*   The recently introduced new data flow and taint tracking APIs have had a number of module and predicate renamings. The old APIs remain in place for now.

Java/Kotlin
"""""""""""

*   The :code:`execTainted` predicate in :code:`CommandLineQuery.qll` has been deprecated and replaced with the predicate :code:`execIsTainted`.
*   The recently introduced new data flow and taint tracking APIs have had a number of module and predicate renamings. The old APIs remain in place for now.
*   The :code:`WebViewDubuggingQuery` library has been renamed to :code:`WebViewDebuggingQuery` to fix the typo in the file name. :code:`WebViewDubuggingQuery` is now deprecated.

Python
""""""

*   The recently introduced new data flow and taint tracking APIs have had a number of module and predicate renamings. The old APIs remain in place for now.

Ruby
""""

*   The recently introduced new data flow and taint tracking APIs have had a number of module and predicate renamings. The old APIs remain in place for now.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added overridable predicates :code:`getSizeExpr` and :code:`getSizeMult` to the :code:`BufferAccess` class (:code:`semmle.code.cpp.security.BufferAccess.qll`). This makes it possible to model a larger class of buffer reads and writes using the library.

Java/Kotlin
"""""""""""

*   Predicates :code:`Compilation.getExpandedArgument` and :code:`Compilation.getAnExpandedArgument` has been added.
