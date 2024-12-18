.. _codeql-cli-2.15.1:

==========================
CodeQL 2.15.1 (2023-10-19)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.15.1 runs a total of 398 security queries when configured with the Default suite (covering 158 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The query server's :code:`evaluation/trimCache` command was previously equivalent to the :code:`codeql database cleanup --mode=gentle` CLI command, but is now equivalent to using :code:`--mode=normal`. The new meaning of the command is to clear the entire evaluation cache of a database except for predicates annotated with the :code:`cached` keyword.

Bug Fixes
~~~~~~~~~

*   Fixed a bug where the :code:`$CODEQL_JAVA_HOME` environment variable was erroneously ignored for certain subsidiary Java processes started by
    :code:`codeql`.
*   Fixed a bug in the CodeQL build tracer on Apple Silicon machines that prevented database creation if System Integrity Protection was disabled.

Deprecations
~~~~~~~~~~~~

*   The accepted values of the :code:`--mode` option for :code:`codeql database cleanup`  have been renamed to bring them in line with what they are called in the VSCode extension and the query server:

    *   :code:`--mode=brutal` is now :code:`--mode=clear`.
    *   :code:`--mode=normal` is now :code:`--mode=trim`.
    *   :code:`--mode=light` is now :code:`--mode=fit`.
    *   The old names are deprecated, but will be accepted for backwards-compatibility reasons until further notice.

Improvements
~~~~~~~~~~~~

*   The list of failed tests at the end of a :code:`codeql test run` is now sorted lexicographically.
*   The syntax of DIL now more closely resembles the QL source code that it is compiled from. In particular, conjunctions and disjunctions now use the familiar :code:`and` and :code:`or` keywords, and clauses are enclosed in curly braces.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`cs/web/insecure-direct-object-reference` and :code:`cs/web/missing-function-level-access-control` have been improved to better recognize attributes on generic classes.

Golang
""""""

*   The query "Incorrect conversion between integer types" (:code:`go/incorrect-integer-conversion`) has been improved. It can now detect parsing an unsigned integer type (like :code:`uint32`) and converting it to the signed integer type of the same size (like :code:`int32`), which may lead to more results. It also treats :code:`int` and :code:`uint` more carefully, which may lead to more results or fewer incorrect results.

Java/Kotlin
"""""""""""

*   Most data flow queries that track flow from *remote* flow sources now use the current *threat model* configuration instead. This doesn't lead to any changes in the produced alerts (as the default configuration is *remote* flow sources) unless the threat model configuration is changed.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added the :code:`AmdModuleDefinition::Range` class, making it possible to define custom aliases for the AMD :code:`define` function.

Swift
"""""

*   Added more new logging sinks to the :code:`swift/cleartext-logging` query.
*   Added sinks for the GRDB database library to the :code:`swift/hardcoded-key` query.
*   Added sqlite3 and SQLite.swift sinks and flow summaries for the :code:`swift/hardcoded-key` query.
*   Added sqlite3 and SQLite.swift sinks and flow summaries for the :code:`swift/cleartext-storage-database` query.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   The query :code:`cpp/redundant-null-check-simple` has been promoted to Code Scanning. The query finds cases where a pointer is compared to null after it has already been dereferenced. Such comparisons likely indicate a bug at the place where the pointer is dereferenced, or where the pointer is compared to null.
    
    Note: This query was incorrectly noted as being promoted to Code Scanning in CodeQL version 2.14.6.

Ruby
""""

*   Added a new experimental query, :code:`rb/jwt-empty-secret-or-algorithm`, to detect when application uses an empty secret or weak algorithm.
*   Added a new experimental query, :code:`rb/jwt-missing-verification`, to detect when the application does not verify a JWT payload.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the deprecated :code:`AnalysedString` class, use the new name :code:`AnalyzedString`.
*   Deleted the deprecated :code:`isBarrierGuard` predicate from the dataflow library and its uses, use :code:`isBarrier` and the :code:`BarrierGuard` module instead.

C#
""

*   Deleted the deprecated :code:`isBarrierGuard` predicate from the dataflow library and its uses, use :code:`isBarrier` and the :code:`BarrierGuard` module instead.

Golang
""""""

*   Deleted the deprecated :code:`isBarrierGuard` predicate from the dataflow library and its uses, use :code:`isBarrier` and the :code:`BarrierGuard` module instead.
*   Support has been added for file system access sinks in the following libraries: \ `net/http <https://pkg.go.dev/net/http>`__, `Afero <https://github.com/spf13/afero>`__, `beego <https://pkg.go.dev/github.com/astaxie/beego>`__, `Echo <https://pkg.go.dev/github.com/labstack/echo>`__, `Fiber <https://github.com/kataras/iris>`__, `Gin <https://pkg.go.dev/github.com/gin-gonic/gin>`__, `Iris <https://github.com/kataras/iris>`__.
*   Added :code:`GoKit.qll` to :code:`go.qll` enabling the GoKit framework by default

Java/Kotlin
"""""""""""

*   The :code:`isBarrier`, :code:`isBarrierIn`, :code:`isBarrierOut`, and :code:`isAdditionalFlowStep` methods of the taint-tracking configurations for local queries in the :code:`ArithmeticTaintedLocalQuery`, :code:`ExternallyControlledFormatStringLocalQuery`, :code:`ImproperValidationOfArrayIndexQuery`, :code:`NumericCastTaintedQuery`, :code:`ResponseSplittingLocalQuery`, :code:`SqlTaintedLocalQuery`, and :code:`XssLocalQuery` libraries have been changed to match their remote counterpart configurations.
*   Deleted the deprecated :code:`isBarrierGuard` predicate from the dataflow library and its uses, use :code:`isBarrier` and the :code:`BarrierGuard` module instead.
*   Deleted the deprecated :code:`getAValue` predicate from the :code:`Annotation` class.
*   Deleted the deprecated alias :code:`FloatingPointLiteral`, use :code:`FloatLiteral` instead.
*   Deleted the deprecated :code:`getASuppressedWarningLiteral` predicate from the :code:`SuppressWarningsAnnotation` class.
*   Deleted the deprecated :code:`getATargetExpression` predicate form the :code:`TargetAnnotation` class.
*   Deleted the deprecated :code:`getRetentionPolicyExpression` predicate from the :code:`RetentionAnnotation` class.
*   Deleted the deprecated :code:`conditionCheck` predicate from :code:`Preconditions.qll`.
*   Deleted the deprecated :code:`semmle.code.java.security.performance` folder, use :code:`semmle.code.java.security.regexp` instead.
*   Deleted the deprecated :code:`ExternalAPI` class from :code:`ExternalApi.qll`, use :code:`ExternalApi` instead.
*   Modified the :code:`EnvInput` class in :code:`semmle.code.java.dataflow.FlowSources` to include :code:`environment` and :code:`file` source nodes.
    There are no changes to results unless you add source models using the :code:`environment` or :code:`file` source kinds.
*   Added :code:`environment` source models for the following methods:

    *   :code:`java.lang.System#getenv`
    *   :code:`java.lang.System#getProperties`
    *   :code:`java.lang.System#getProperty`
    *   :code:`java.util.Properties#get`
    *   :code:`java.util.Properties#getProperty`
    
*   Added :code:`file` source models for the following methods:

    *   the :code:`java.io.FileInputStream` constructor
    *   :code:`hudson.FilePath#newInputStreamDenyingSymlinkAsNeeded`
    *   :code:`hudson.FilePath#openInputStream`
    *   :code:`hudson.FilePath#read`
    *   :code:`hudson.FilePath#readFromOffset`
    *   :code:`hudson.FilePath#readToString`
    
*   Modified the :code:`DatabaseInput` class in :code:`semmle.code.java.dataflow.FlowSources` to include :code:`database` source nodes.
    There are no changes to results unless you add source models using the :code:`database` source kind.
*   Added :code:`database` source models for the following method:

    *   :code:`java.sql.ResultSet#getString`

JavaScript/TypeScript
"""""""""""""""""""""

*   The contents of :code:`.jsp` files are now extracted, and any :code:`<script>` tags inside these files will be parsed as JavaScript.
*   \ `Import attributes <https://github.com/tc39/proposal-import-attributes>`__ are now supported in JavaScript code.
    Note that import attributes are an evolution of an earlier proposal called "import assertions", which were implemented in TypeScript 4.5.
    The QL library includes new predicates named :code:`getImportAttributes()` that should be used in favor of the now deprecated :code:`getImportAssertion()`\ ;
    in addition, the :code:`getImportAttributes()` method of the :code:`DynamicImportExpr` has been renamed to :code:`getImportOptions()`.
*   Deleted the deprecated :code:`getAnImmediateUse`, :code:`getAUse`, :code:`getARhs`, and :code:`getAValueReachingRhs` predicates from the :code:`API::Node` class.
*   Deleted the deprecated :code:`mayReferToParameter` predicate from :code:`DataFlow::Node`.
*   Deleted the deprecated :code:`getStaticMethod` and :code:`getAStaticMethod` predicates from :code:`DataFlow::ClassNode`.
*   Deleted the deprecated :code:`isLibaryFile` predicate from :code:`ClassifyFiles.qll`, use :code:`isLibraryFile` instead.
*   Deleted many library models that were build on the AST. Use the new models that are build on the dataflow library instead.
*   Deleted the deprecated :code:`semmle.javascript.security.performance` folder, use :code:`semmle.javascript.security.regexp` instead.
*   Tagged template literals have been added to :code:`DataFlow::CallNode`. This allows the analysis to find flow into functions called with a tagged template literal,
    and the arguments to a tagged template literal are part of the API-graph in :code:`ApiGraphs.qll`.

Python
""""""

*   Added better support for API graphs when encountering :code:`from ... import *`. For example in the code :code:`from foo import *; Bar()`, we will now find a result for :code:`API::moduleImport("foo").getMember("Bar").getACall()`
*   Deleted the deprecated :code:`isBarrierGuard` predicate from the dataflow library and its uses, use :code:`isBarrier` and the :code:`BarrierGuard` module instead.
*   Deleted the deprecated :code:`getAUse`, :code:`getAnImmediateUse`, :code:`getARhs`, and :code:`getAValueReachingRhs` predicates from the :code:`API::Node` class.
*   Deleted the deprecated :code:`fullyQualifiedToAPIGraphPath` class from :code:`SubclassFinder.qll`, use :code:`fullyQualifiedToApiGraphPath` instead.
*   Deleted the deprecated :code:`Paths.qll` file.
*   Deleted the deprecated :code:`semmle.python.security.performance` folder, use :code:`semmle.python.security.regexp` instead.
*   Deleted the deprecated :code:`semmle.python.security.strings` and :code:`semmle.python.web` folders.
*   Improved modeling of decoding through pickle related functions (which can lead to code execution), resulting in additional sinks for the *Deserializing untrusted input* query (:code:`py/unsafe-deserialization`). Added support for :code:`pandas.read_pickle`, :code:`numpy.load` and :code:`joblib.load`.

Ruby
""""

*   Deleted the deprecated :code:`isBarrierGuard` predicate from the dataflow library and its uses, use :code:`isBarrier` and the :code:`BarrierGuard` module instead.
*   Deleted the deprecated :code:`isWeak` predicate from the :code:`CryptographicOperation` class.
*   Deleted the deprecated :code:`getStringOrSymbol` and :code:`isStringOrSymbol` predicates from the :code:`ConstantValue` class.
*   Deleted the deprecated :code:`getAPI` from the :code:`IOOrFileMethodCall` class.
*   Deleted the deprecated :code:`codeql.ruby.security.performance` folder, use :code:`codeql.ruby.security.regexp` instead.
*   GraphQL enums are no longer considered remote flow sources.

Swift
"""""

*   Improved taint models for :code:`Numeric` types and :code:`RangeReplaceableCollection`\ s.
*   The nil-coalescing operator :code:`??` is now supported by the CFG construction and dataflow libraries.
*   The data flow library now supports flow to the loop variable of for-in loops.
*   The methods :code:`getIteratorVar` and :code:`getNextCall` have been added to the :code:`ForEachStmt` class.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added predicate :code:`MemberRefExpr::getReceiverExpr`\ 
