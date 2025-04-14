.. _codeql-cli-2.13.3:

==========================
CodeQL 2.13.3 (2023-05-31)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.13.3 runs a total of 389 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 125 queries (covering 32 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug that could cause the compiler to infer incorrect binding sets for non-direct calls to overriding member predicates that have stronger binding sets than their root definitions.
    
*   Fixed a bug that could have caused the compiler to incorrectly infer that a class matched a type signature. The bug only affected classes with overriding member predicates that had stronger binding sets than their root definitions.
    
*   Fixed a bug where a query could not be run from VS Code when there were packs nested within sibling directories of the query.

New Features
~~~~~~~~~~~~

*   This release enhances our preliminary Swift support, setting the stage for the upcoming public beta.
    
*   The :code:`codeql database bundle` command now supports the :code:`--[no]-include-temp` option. When enabled, this option will include the :code:`temp` folder of the database directory in the zip file of the bundled database. This folder includes generated packages and queries, and query suites.
    
*   The structured log produced by :code:`codeql generate log-summary` now includes a Boolean :code:`isCached` field for predicate events, where a :code:`true` value indicates the predicate is a wrapper implementing the :code:`cached` annotation on another predicate. The wrapper depends on the underlying predicate that the annotation was found on, and will usually have the same name, but it has a separate :code:`raHash`.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a spurious diagnostic warning about comments in JSON files being illegal.
    Comments in JSON files are in fact fully supported, and the diagnostic message was misleading.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added taint sources from the :code:`@actions/core` and :code:`@actions/github` packages.
*   Added command-injection sinks from the :code:`@actions/exec` package.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The query :code:`java/groovy-injection` now recognizes :code:`groovy.text.TemplateEngine.createTemplate` as a sink.
*   The queries :code:`java/xxe` and :code:`java/xxe-local` now recognize the second argument of calls to :code:`XPath.evaluate` as a sink.
*   Experimental sinks for the query "Resolving XML external entity in user-controlled data" (:code:`java/xxe`) have been promoted to the main query pack. These sinks were originally `submitted as part of an experimental query by @haby0 <https://github.com/github/codeql/pull/6564>`__.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/indirect-command-line-injection` query no longer flags command arguments that cannot be interpreted as a shell string.
*   The :code:`js/unsafe-deserialization` query no longer flags deserialization through the :code:`js-yaml` library, except when it is used with an unsafe schema.
*   The Forge module in :code:`CryptoLibraries.qll` now correctly classifies SHA-512/224,
    SHA-512/256, and SHA-512/384 hashes used in message digests as NonKeyCiphers.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   In the intermediate representation, handling of control flow after non-returning calls has been improved. This should remove false positives in queries that use the intermedite representation or libraries based on it, including the new data flow library.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`StdNamespace` class now also includes all inline namespaces that are children of :code:`std` namespace.
*   The new dataflow (:code:`semmle.code.cpp.dataflow.new.DataFlow`) and taint-tracking libraries (:code:`semmle.code.cpp.dataflow.new.TaintTracking`) now support tracking flow through static local variables.

C#
""

*   The :code:`cs/log-forging`, :code:`cs/cleartext-storage`, and :code:`cs/exposure-of-sensitive-information` queries now correctly handle unsanitized arguments to :code:`ILogger` extension methods.
*   Updated the :code:`neutralModel` extensible predicate to include a :code:`kind` column.

Golang
""""""

*   Fixed data flow through variadic function parameters. The arguments corresponding to a variadic parameter are no longer returned by :code:`CallNode.getArgument(int i)` and :code:`CallNode.getAnArgument()`, and hence aren't :code:`ArgumentNode`\ s. They now have one result, which is an :code:`ImplicitVarargsSlice` node. For example, a call :code:`f(a, b, c)` to a function :code:`f(T...)` is treated like :code:`f([]T{a, b, c})`. The old behaviour is preserved by :code:`CallNode.getSyntacticArgument(int i)` and :code:`CallNode.getASyntacticArgument()`. :code:`CallExpr.getArgument(int i)` and :code:`CallExpr.getAnArgument()` are unchanged, and will still have three results in the example given.

Java/Kotlin
"""""""""""

*   Added SQL injection sinks for Spring JDBC's :code:`NamedParameterJdbcOperations`.
    
*   Added models for the following packages:

    *   org.apache.hadoop.fs
    
*   Added the :code:`ArithmeticCommon.qll` library to provide predicates for reasoning about arithmetic operations.
    
*   Added the :code:`ArithmeticTaintedLocalQuery.qll` library to provide the :code:`ArithmeticTaintedLocalOverflowFlow` and :code:`ArithmeticTaintedLocalUnderflowFlow` taint-tracking modules to reason about arithmetic with unvalidated user input.
    
*   Added the :code:`ArithmeticTaintedQuery.qll` library to provide the :code:`RemoteUserInputOverflow` and :code:`RemoteUserInputUnderflow` taint-tracking modules to reason about arithmetic with unvalidated user input.
    
*   Added the :code:`ArithmeticUncontrolledQuery.qll` library to provide the :code:`ArithmeticUncontrolledOverflowFlow`  and :code:`ArithmeticUncontrolledUnderflowFlow` taint-tracking modules to reason about arithmetic with uncontrolled user input.
    
*   Added the :code:`ArithmeticWithExtremeValuesQuery.qll` library to provide the :code:`MaxValueFlow` and :code:`MinValueFlow` dataflow modules to reason about arithmetic with extreme values.
    
*   Added the :code:`BrokenCryptoAlgorithmQuery.qll` library to provide the :code:`InsecureCryptoFlow` taint-tracking module to reason about broken cryptographic algorithm vulnerabilities.
    
*   Added the :code:`ExecTaintedLocalQuery.qll` library to provide the :code:`LocalUserInputToArgumentToExecFlow` taint-tracking module to reason about command injection vulnerabilities caused by local data flow.
    
*   Added the :code:`ExternallyControlledFormatStringLocalQuery.qll` library to provide the :code:`ExternallyControlledFormatStringLocalFlow` taint-tracking module to reason about format string vulnerabilities caused by local data flow.
    
*   Added the :code:`ImproperValidationOfArrayConstructionCodeSpecifiedQuery.qll` library to provide the :code:`BoundedFlowSourceFlow` dataflow module to reason about improper validation of code-specified sizes used for array construction.
    
*   Added the :code:`ImproperValidationOfArrayConstructionLocalQuery.qll` library to provide the :code:`ImproperValidationOfArrayConstructionLocalFlow` taint-tracking module to reason about improper validation of local user-provided sizes used for array construction caused by local data flow.
    
*   Added the :code:`ImproperValidationOfArrayConstructionQuery.qll` library to provide the :code:`ImproperValidationOfArrayConstructionFlow` taint-tracking module to reason about improper validation of user-provided size used for array construction.
    
*   Added the :code:`ImproperValidationOfArrayIndexCodeSpecifiedQuery.qll` library to provide the :code:`BoundedFlowSourceFlow` data flow module to reason about about improper validation of code-specified array index.
    
*   Added the :code:`ImproperValidationOfArrayIndexLocalQuery.qll` library to provide the :code:`ImproperValidationOfArrayIndexLocalFlow` taint-tracking module to reason about improper validation of a local user-provided array index.
    
*   Added the :code:`ImproperValidationOfArrayIndexQuery.qll` library to provide the :code:`ImproperValidationOfArrayIndexFlow` taint-tracking module to reason about improper validation of user-provided array index.
    
*   Added the :code:`InsecureCookieQuery.qll` library to provide the :code:`SecureCookieFlow` taint-tracking module to reason about insecure cookie vulnerabilities.
    
*   Added the :code:`MaybeBrokenCryptoAlgorithmQuery.qll` library to provide the :code:`InsecureCryptoFlow` taint-tracking module to reason about broken cryptographic algorithm vulnerabilities.
    
*   Added the :code:`NumericCastTaintedQuery.qll` library to provide the :code:`NumericCastTaintedFlow` taint-tracking module to reason about numeric cast vulnerabilities.
    
*   Added the :code:`ResponseSplittingLocalQuery.qll` library to provide the :code:`ResponseSplittingLocalFlow` taint-tracking module to reason about response splitting vulnerabilities caused by local data flow.
    
*   Added the :code:`SqlConcatenatedQuery.qll` library to provide the :code:`UncontrolledStringBuilderSourceFlow` taint-tracking module to reason about SQL injection vulnerabilities caused by concatenating untrusted strings.
    
*   Added the :code:`SqlTaintedLocalQuery.qll` library to provide the :code:`LocalUserInputToArgumentToSqlFlow` taint-tracking module to reason about SQL injection vulnerabilities caused by local data flow.
    
*   Added the :code:`StackTraceExposureQuery.qll` library to provide the :code:`printsStackExternally`, :code:`stringifiedStackFlowsExternally`, and :code:`getMessageFlowsExternally` predicates to reason about stack trace exposure vulnerabilities.
    
*   Added the :code:`TaintedPermissionQuery.qll` library to provide the :code:`TaintedPermissionFlow` taint-tracking module to reason about tainted permission vulnerabilities.
    
*   Added the :code:`TempDirLocalInformationDisclosureQuery.qll` library to provide the :code:`TempDirSystemGetPropertyToCreate` taint-tracking module to reason about local information disclosure vulnerabilities caused by local data flow.
    
*   Added the :code:`UnsafeHostnameVerificationQuery.qll` library to provide the :code:`TrustAllHostnameVerifierFlow` taint-tracking module to reason about insecure hostname verification vulnerabilities.
    
*   Added the :code:`UrlRedirectLocalQuery.qll` library to provide the :code:`UrlRedirectLocalFlow` taint-tracking module to reason about URL redirection vulnerabilities caused by local data flow.
    
*   Added the :code:`UrlRedirectQuery.qll` library to provide the :code:`UrlRedirectFlow` taint-tracking module to reason about URL redirection vulnerabilities.
    
*   Added the :code:`XPathInjectionQuery.qll` library to provide the :code:`XPathInjectionFlow` taint-tracking module to reason about XPath injection vulnerabilities.
    
*   Added the :code:`XssLocalQuery.qll` library to provide the :code:`XssLocalFlow` taint-tracking module to reason about XSS vulnerabilities caused by local data flow.
    
*   Moved the :code:`url-open-stream` sink models to experimental and removed :code:`url-open-stream` as a sink option from the `Customizing Library Models for Java <https://github.com/github/codeql/blob/733a00039efdb39c3dd76ddffad5e6d6c85e6774/docs/codeql/codeql-language-guides/customizing-library-models-for-java.rst#customizing-library-models-for-java>`__ documentation.
    
*   Added models for the Apache Commons Net library.
    
*   Updated the :code:`neutralModel` extensible predicate to include a :code:`kind` column.
    
*   Added models for the :code:`io.jsonwebtoken` library.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved the queries for injection vulnerabilities in GitHub Actions workflows (:code:`js/actions/command-injection` and :code:`js/actions/pull-request-target`) and the associated library :code:`semmle.javascript.Actions`. These now support steps defined in composite actions, in addition to steps defined in Actions workflow files. It supports more potentially untrusted input values. Additionally to the shell injections it now also detects injections in :code:`actions/github-script`. It also detects simple injections from user controlled :code:`${{ env.name }}`. Additionally to the :code:`yml` extension now it also supports workflows with the :code:`yaml` extension.

Python
""""""

*   Type tracking is now aware of reads of captured variables (variables defined in an outer scope). This leads to a richer API graph, and may lead to more results in some queries.
*   Added more content-flow/field-flow for dictionaries, by adding support for reads through :code:`mydict.get("key")` and :code:`mydict.setdefault("key", value)`, and store steps through :code:`dict["key"] = value` and :code:`mydict.setdefault("key", value)`.

Ruby
""""

*   Support for the :code:`sqlite3` gem has been added. Method calls that execute queries against an SQLite3 database that may be vulnerable to injection attacks will now be recognized.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added an AST-based interface (:code:`semmle.code.cpp.rangeanalysis.new.RangeAnalysis`) for the relative range analysis library.
*   A new predicate :code:`BarrierGuard::getAnIndirectBarrierNode` has been added to the new dataflow library (:code:`semmle.code.cpp.dataflow.new.DataFlow`) to mark indirect expressions as barrier nodes using the :code:`BarrierGuard` API.
