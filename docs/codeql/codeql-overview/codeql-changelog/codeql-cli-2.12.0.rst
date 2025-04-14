.. _codeql-cli-2.12.0:

==========================
CodeQL 2.12.0 (2023-01-10)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.0 runs a total of 365 security queries when configured with the Default suite (covering 150 CWE). The Extended suite enables an additional 116 queries (covering 32 more CWE). 8 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The :code:`--[no-]count-lines` option to :code:`codeql database create` and related commands that was deprecated in 2.11.1 has been removed. Users of this option should instead pass
    :code:`--[no-]calculate-baseline`.

Bug Fixes
~~~~~~~~~

*   Fixed a bug where the :code:`codeql pack install` command would fail if a `CodeQL configuration file <https://codeql.github.com/docs/codeql-cli/specifying-command-options-in-a-codeql-configuration-file/#using-a-codeql-configuration-file>`__ is used and the :code:`--additional-packs` option is specified.

New Features
~~~~~~~~~~~~

*   Query packs created by :code:`codeql pack create`, :code:`codeql pack bundle`, and :code:`codeql pack release` now contain precompiled queries in a new format that aims to be compatible with future (and, to a certain extent, past) releases of the CodeQL CLI. Previously the precompiled queries were in a format specific to each CLI release, and all other releases would need to re-compile queries.
    
    Published packs contain precompiled queries in files with a :code:`.qlx` extension located next to each query's :code:`.ql` source file.  In case of differences between the :code:`.ql` and :code:`.qlx` files, the :code:`.qlx` file takes priority when evaluating queries from the command line, so if you need to modify a published pack, be sure to delete the :code:`.qlx` files first.
    
    A new :code:`--precompile` flag to :code:`codeql query compile` can be used to construct :code:`*.qlx` file explicitly, but in all usual cases it should be enough to rely on :code:`codeql pack create` doing the right thing.
    
*   The :code:`codeql database init` command now accepts a PAT that allows you to download queries from external, private repositories when using the :code:`--codescanning-config <config-file>` option. For example, you can specify the following queries block in the config file, which will checkout the main branch of the :code:`codeql-test/my-private-repository` repository and evaluate any queries found in that repository:

    ..  code-block:: yaml
    
        queries:
          - codeql-test/my-private-repository@main
        
    If the repository is private, you can add a :code:`--external-repository-token-stdin` option and supply a PAT with appropriate permissions via standard input. For more information on queries and external repositories in Code Scanning, see `Using queries in QL packs <https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning#using-queries-in-ql-packs>`__.
    
*   The baseline information produced by :code:`codeql database init` and
    :code:`codeql database create` now accounts for
    |link-code-paths-and-code-paths-ignore-configuration-1|_.
    
*   In the VS Code extension, recursive calls will be marked with inlay hints. These can be disabled with the global inlay hints setting
    (:code:`editor.inlayHints.enabled`). If you just want to disable them for codeql the settings can be scoped to just codeql files (language id is :code:`ql`).
    See `Language Specific Editor Settings <https://code.visualstudio.com/docs/getstarted/settings#_language-specific-editor-settings>`__ in the VS Code documentation for more information.
    
*   The CLI now gives a more helpful error message when asked to run queries on a database that has not been finalized.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

C#
""

*   Fixes a bug where the Owin.qll framework library will look for "URI" instead of "Uri" in the OwinRequest class.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`AlertSuppression.ql` query has been updated to support the new :code:`// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy :code:`// lgtm` and :code:`// lgtm[query-id]` comments can now also be placed on the line before an alert.
*   The :code:`cpp/missing-check-scanf` query no longer reports the free'ing of :code:`scanf` output variables as potential reads.

C#
""

*   The :code:`AlertSuppression.ql` query has been updated to support the new :code:`// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy :code:`// lgtm` and :code:`// lgtm[query-id]` comments can now also be placed on the line before an alert.
*   The extensible predicates for Models as Data have been renamed (the :code:`ext` prefix has been removed). As an example, :code:`extSummaryModel` has been renamed to :code:`summaryModel`.

Golang
""""""

*   The :code:`AlertSuppression.ql` query has been updated to support the new :code:`// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy :code:`// lgtm` and :code:`// lgtm[query-id]` comments can now also be placed on the line before an alert.

Java/Kotlin
"""""""""""

*   The :code:`AlertSuppression.ql` query has been updated to support the new :code:`// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy :code:`// lgtm` and :code:`// lgtm[query-id]` comments can now also be placed on the line before an alert.
*   The extensible predicates for Models as Data have been renamed (the :code:`ext` prefix has been removed). As an example, :code:`extSummaryModel` has been renamed to :code:`summaryModel`.
*   The query :code:`java/misnamed-type` is now enabled for Kotlin.
*   The query :code:`java/non-serializable-field` is now enabled for Kotlin.
*   Fixed an issue in the query :code:`java/android/implicit-pendingintents` by which an implicit Pending Intent marked as immutable was not correctly recognized as such.
*   The query :code:`java/maven/non-https-url` no longer alerts about disabled repositories.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`AlertSuppression.ql` query has been updated to support the new :code:`// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy :code:`// lgtm` and :code:`// lgtm[query-id]` comments can now also be placed on the line before an alert.

Python
""""""

*   The :code:`analysis/AlertSuppression.ql` query has moved to the root folder. Users that refer to this query by path should update their configurations. The query has been updated to support the new :code:`# codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy :code:`# lgtm` and :code:`# lgtm[query-id]` comments can now also be placed on the line before an alert.
*   Bumped the minimum keysize we consider secure for elliptic curve cryptography from 224 to 256 bits, following current best practices. This might effect results from the *Use of weak cryptographic key* (:code:`py/weak-crypto-key`) query.
*   Added modeling of :code:`getpass.getpass` as a source of passwords, which will be an additional source for :code:`py/clear-text-logging-sensitive-data`, :code:`py/clear-text-storage-sensitive-data`, and :code:`py/weak-sensitive-data-hashing`.

Ruby
""""

*   The :code:`AlertSuppression.ql` query has been updated to support the new :code:`# codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy :code:`# lgtm` and :code:`# lgtm[query-id]` comments can now also be placed on the line before an alert.
*   Extended the :code:`rb/kernel-open` query with following sinks: :code:`IO.write`, :code:`IO.binread`, :code:`IO.binwrite`, :code:`IO.foreach`, :code:`IO.readlines`, and :code:`URI.open`.

New Queries
~~~~~~~~~~~

C#
""

*   Added a new query, :code:`csharp/telemetry/supported-external-api`, to detect supported 3rd party APIs used in a codebase.

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/summary/generated-vs-manual-coverage`, to expose metrics for the number of API endpoints covered by generated versus manual MaD models.
*   Added a new query, :code:`java/telemetry/supported-external-api`, to detect supported 3rd party APIs used in a codebase.
*   Added a new query, :code:`java/android/missing-certificate-pinning`, to find network calls where certificate pinning is not implemented.
*   Added a new query, :code:`java/android-webview-addjavascriptinterface`, to detect the use of :code:`addJavascriptInterface`, which can lead to cross-site scripting.
*   Added a new query, :code:`java/android-websettings-file-access`, to detect configurations that enable file system access in Android WebViews.
*   Added a new query, :code:`java/android-websettings-javascript-enabled`, to detect if JavaScript execution is enabled in an Android WebView.
*   The query :code:`java/regex-injection` has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @edvraa <https://github.com/github/codeql/pull/5704>`__.

Ruby
""""

*   Added a new query, :code:`rb/stack-trace-exposure`, to detect exposure of stack-traces to users via HTTP responses.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

Java/Kotlin
"""""""""""

*   We now correctly handle empty block comments, like :code:`/**/`. Previously these could be mistaken for Javadoc comments and led to attribution of Javadoc tags to the wrong declaration.

Python
""""""

*   :code:`except*` is now supported.
*   The result of :code:`Try.getAHandler` and :code:`Try.getHandler(<index>)` is no longer of type :code:`ExceptStmt`, as handlers may also be :code:`ExceptGroupStmt`\ s (After Python 3.11 introduced PEP 654). Instead, it is of the new type :code:`ExceptionHandler` of which :code:`ExceptStmt` and :code:`ExceptGroupStmt` are subtypes. To support selecting only one type of handler, :code:`Try.getANormalHandler` and :code:`Try.getAGroupHandler` have been added. Existing uses of :code:`Try.getAHandler` for which it is important to select only normal handlers, will need to be updated to :code:`Try.getANormalHandler`.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The predicates in the :code:`MustFlow::Configuration` class used by the :code:`MustFlow` library (:code:`semmle.code.cpp.ir.dataflow.MustFlow`) have changed to be defined directly in terms of the C++ IR instead of IR dataflow nodes.

Golang
""""""

*   The signature of :code:`allowImplicitRead` on :code:`DataFlow::Configuration` and :code:`TaintTracking::Configuration` has changed from :code:`allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to :code:`allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   The *PAM authorization bypass due to incorrect usage* (:code:`py/pam-auth-bypass`) query has been converted to a taint-tracking query, resulting in significantly fewer false positives.

Ruby
""""

*   Flow through :code:`initialize` constructors is now taken into account. For example, in

    ..  code-block:: rb
    
        class C
          def initialize(x)
            @field = x
          end
        end
        
        C.new(y)
        
    there will be flow from :code:`y` to the field :code:`@field` on the constructed :code:`C` object.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`ArgvSource` flow source now uses the second parameter of :code:`main` as its source instead of the uses of this parameter.
*   The :code:`ArgvSource` flow source has been generalized to handle cases where the argument vector of :code:`main` is not named :code:`argv`.
*   The :code:`getaddrinfo` function is now recognized as a flow source.
*   The :code:`secure_getenv` and :code:`_wgetenv` functions are now recognized as local flow sources.
*   The :code:`scanf` and :code:`fscanf` functions and their variants are now recognized as flow sources.
*   Deleted the deprecated :code:`getName` and :code:`getShortName` predicates from the :code:`Folder` class.

C#
""

*   C# 11: Added support for list- and slice patterns in the extractor.
*   Deleted the deprecated :code:`getNameWithoutBrackets` predicate from the :code:`ValueOrRefType` class in :code:`Type.qll`.
*   :code:`Element::hasQualifiedName/1` has been deprecated. Use :code:`hasQualifiedName/2` or :code:`hasQualifiedName/3` instead.
*   Added TCP/UDP sockets as taint sources.

Golang
""""""

*   The predicate :code:`getNumParameter` on :code:`FuncTypeExpr` has been changed to actually give the number of parameters. It previously gave the number of parameter declarations. :code:`getNumParameterDecl` has been introduced to preserve this functionality.
*   The definition of :code:`mayHaveSideEffects` for :code:`ReturnStmt` was incorrect when more than one expression was being returned. Such return statements were effectively considered to never have side effects. This has now been fixed. In rare circumstances :code:`globalValueNumber` may have incorrectly treated two values as the same when they were in fact distinct.
*   Queries that care about SQL, such as :code:`go/sql-injection`, now recognise SQL-consuming functions belonging to the :code:`gorqlite` and :code:`GoFrame` packages.
*   :code:`rsync` has been added to the list of commands which may evaluate its parameters as a shell command.

Java/Kotlin
"""""""""""

*   Added more dataflow models for frequently-used JDK APIs.
*   The extraction of Kotlin extension methods has been improved when default parameter values are present. The dispatch and extension receiver parameters are extracted in the correct order. The :code:`ExtensionMethod::getExtensionReceiverParameterIndex` predicate has been introduced to facilitate getting the correct extension parameter index.
*   The query :code:`java/insecure-cookie` now uses global dataflow to track secure cookies being set to the HTTP response object.
*   The library :code:`PathSanitizer.qll` has been improved to detect more path validation patterns in Kotlin.
*   Models as Data models for Java are defined as data extensions instead of being inlined in the code. New models should be added in the :code:`lib/ext` folder.
*   Added a taint model for the method :code:`java.nio.file.Path.getParent`.
*   Fixed a problem in the taint model for the method :code:`java.nio.file.Paths.get`.
*   Deleted the deprecated :code:`LocalClassDeclStmtNode` and :code:`LocalClassDeclStmt` classes from :code:`PrintAst.qll` and :code:`Statement.qll` respectively.
*   Deleted the deprecated :code:`getLocalClass` predicate from :code:`LocalTypeDeclStmt`, and the deprecated :code:`getLocalClassDeclStmt` predicate from :code:`LocalClassOrInterface`.
*   Added support for Android Manifest :code:`<activity-aliases>` elements in data flow sources.

JavaScript/TypeScript
"""""""""""""""""""""

*   Deleted the deprecated :code:`Instance` class from the :code:`Vue` module.
*   Deleted the deprecated :code:`VHtmlSourceWrite` class from :code:`DomBasedXssQuery.qll`.
*   Deleted all the deprecated :code:`[QueryName].qll` files from the :code:`javascript/ql/lib/semmle/javascript/security/dataflow` folder, use the corresponding :code:`[QueryName]Query.qll` files instead.
*   The ReDoS libraries in :code:`semmle.code.javascript.security.regexp` has been moved to a shared pack inside the :code:`shared/` folder, and the previous location has been deprecated.

Python
""""""

*   Added :code:`subprocess.getoutput` and :code:`subprocess.getoutputstatus` as new command injection sinks for the StdLib.
*   The data-flow library has been rewritten to no longer rely on the points-to analysis in order to resolve references to modules. Improvements in the module resolution can lead to more results.
*   Deleted the deprecated :code:`importNode` predicate from the :code:`DataFlowUtil.qll` file.
*   Deleted the deprecated features from :code:`PEP249.qll` that were not inside the :code:`PEP249` module.
*   Deleted the deprecated :code:`werkzeug` from the :code:`Werkzeug` module in :code:`Werkzeug.qll`.
*   Deleted the deprecated :code:`methodResult` predicate from :code:`PEP249::Cursor`.

Ruby
""""

*   Calls to :code:`Kernel.load`, :code:`Kernel.require`, :code:`Kernel.autoload` are now modeled as sinks for path injection.
*   Calls to :code:`mail` and :code:`inbound_mail` in :code:`ActionMailbox` controllers are now considered sources of remote input.
*   Calls to :code:`GlobalID::Locator.locate` and its variants are now recognized as instances of :code:`OrmInstantiation`.
*   Data flow through the :code:`ActiveSupport` extensions :code:`Enumerable#index_with`, :code:`Enumerable#pick`, :code:`Enumerable#pluck` and :code:`Enumerable#sole`  are now modeled.
*   When resolving a method call, the analysis now also searches in sub-classes of the receiver's type.
*   Taint flow is now tracked through many common JSON parsing and generation methods.
*   The ReDoS libraries in :code:`codeql.ruby.security.regexp` has been moved to a shared pack inside the :code:`shared/` folder, and the previous location has been deprecated.
*   String literals and arrays of string literals in case expression patterns are now recognised as barrier guards.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   Deprecated :code:`semmle.code.cpp.ir.dataflow.DefaultTaintTracking`. Use :code:`semmle.code.cpp.ir.dataflow.TaintTracking`.
*   Deprecated :code:`semmle.code.cpp.security.TaintTrackingImpl`. Use :code:`semmle.code.cpp.ir.dataflow.TaintTracking`.
*   Deprecated :code:`semmle.code.cpp.valuenumbering.GlobalValueNumberingImpl`. Use :code:`semmle.code.cpp.valuenumbering.GlobalValueNumbering`, which exposes the same API.

Golang
""""""

*   The :code:`BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new :code:`BarrierGuard` parameterized module.

New Features
~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved support for `Restify <http://restify.com/>`__ framework, leading to more results when scanning applications developed with this framework.
*   Added support for the `Spife <https://github.com/npm/spife>`__ framework.

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Type Trackers
"""""""""""""

*   Initial release. Includes a parameterized module implementing type-trackers.

QL Detective Tutorial
"""""""""""""""""""""

*   Initial release. Contains the library for the CodeQL detective tutorials, helping new users learn to write CodeQL queries.

Utility Classes
"""""""""""""""

*   Initial release. Includes common utility classes and modules: Unit, Boolean, and Option.

.. |link-code-paths-and-code-paths-ignore-configuration-1| replace:: :code:`paths` and :code:`paths-ignore` configuration
.. _link-code-paths-and-code-paths-ignore-configuration-1: https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning#specifying-directories-to-scan

