.. _codeql-cli-2.20.4:

==========================
CodeQL 2.20.4 (2025-02-06)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.20.4 runs a total of 454 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug where CodeQL for Java would fail with an SSL exception while trying to download :code:`maven`.

New Features
~~~~~~~~~~~~

*   Using the :code:`actions` language (for analysis of GitHub Actions workflows) no longer requires the :code:`CODEQL_ENABLE_EXPERIMENTAL_FEATURES` environment variable to be set. Support for analysis of GitHub Actions workflows remains in public preview.

Miscellaneous
~~~~~~~~~~~~~

*   The build of the `logback-core <https://logback.qos.ch/>`__ library that is used for logging in the CodeQL CLI has been updated to version 1.3.15.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug that would occur when TypeScript code was found in an HTML-like file, such as a :code:`.vue` file,
    but where it could not be associated with any :code:`tsconfig.json` file. Previously the embedded code was not extracted in this case, but should now be extracted properly.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved support for NestJS applications that make use of dependency injection with custom providers.
    Calls to methods on an injected service should now be resolved properly.
*   TypeScript extraction is now better at analyzing projects where the main :code:`tsconfig.json` file does not include any source files, but references other :code:`tsconfig.json`\ -like files that do include source files.
*   The :code:`js/incorrect-suffix-check` query now recognises some good patterns of the form :code:`origin.indexOf("." + allowedOrigin)` that were previously falsely flagged.
*   Added a new threat model kind called :code:`view-component-input`, which can enabled with `advanced setup <https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models>`__.
    When enabled, all React props, Vue props, and input fields in an Angular component are seen as taint sources, even if none of the corresponding instantiation sites appear to pass in a tainted value.
    Some users may prefer this as a "defense in depth" option but note that it may result in false positives.
    Regardless of whether the threat model is enabled, CodeQL will propagate taint from the instantiation sites of such components into the components themselves.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Wrong type of arguments to formatting function" query (:code:`cpp/wrong-type-format-argument`) now produces fewer FPs if the formatting function has multiple definitions.
*   The "Call to memory access function may overflow buffer" query (:code:`cpp/overflow-buffer`) now produces fewer FPs involving non-static member variables.

C#
""

*   All *experimental* queries have been deprecated. The queries are instead available as part of the *default* query suite in `CodeQL-Community-Packs <https://github.com/GitHubSecurityLab/CodeQL-Community-Packs>`__.

Java/Kotlin
"""""""""""

*   All *experimental* queries have been deprecated. The queries are instead available as part of the *default* query suite in `CodeQL-Community-Packs <https://github.com/GitHubSecurityLab/CodeQL-Community-Packs>`__.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

GitHub Actions
""""""""""""""

*   Fixed data for vulnerable versions of :code:`actions/download-artifact` and :code:`rlespinasse/github-slug-action` (following GHSA-cxww-7g56-2vh6 and GHSA-6q4m-7476-932w).
*   Improved :code:`untrustedGhCommandDataModel` regex for :code:`gh pr view` and Bash taint analysis in GitHub Actions.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the deprecated :code:`getAllocatorCall` predicate from :code:`DeleteOrDeleteArrayExpr`, use :code:`getDeallocatorCall` instead.

C#
""

*   Deleted the deprecated :code:`getInstanceType` predicate from the :code:`UnboundGenericType` class.
*   Deleted the deprecated :code:`getElement` predicate from the :code:`Node` class in :code:`ControlFlowGraph.qll`, use :code:`getAstNode` instead.

Golang
""""""

*   Deleted the deprecated :code:`describeBitSize` predicate from :code:`IncorrectIntegerConversionLib.qll`

Java/Kotlin
"""""""""""

*   Deleted the deprecated :code:`isLValue` and :code:`isRValue` predicates from the :code:`VarAccess` class, use :code:`isVarWrite` and :code:`isVarRead` respectively instead.
*   Deleted the deprecated :code:`getRhs` predicate from the :code:`VarWrite` class, use :code:`getASource` instead.
*   Deleted the deprecated :code:`LValue` and :code:`RValue` classes, use :code:`VarWrite` and :code:`VarRead` respectively instead.
*   Deleted a lot of deprecated classes ending in "*Access", use the corresponding "*Call" classes instead.
*   Deleted a lot of deprecated predicates ending in "*Access", use the corresponding "*Call" predicates instead.
*   Deleted the deprecated :code:`EnvInput` and :code:`DatabaseInput` classes from :code:`FlowSources.qll`, use the threat models feature instead.
*   Deleted some deprecated API predicates from :code:`SensitiveApi.qll`, use the Sink classes from that file instead.

Python
""""""

*   Deleted the old deprecated TypeTracking library.
*   Deleted the deprecated :code:`classRef` predicate from the :code:`FieldStorage` module, use :code:`subclassRef` instead.
*   Deleted a lot of deprecated modules and predicates from :code:`Stdlib.qll`, use API-graphs directly instead.

Ruby
""""

*   Deleted the deprecated :code:`getCallNode` predicate from :code:`API::Node`, use :code:`asCall()` instead.
*   Deleted the deprecated :code:`getASubclass`, :code:`getAnImmediateSubclass`, :code:`getASuccessor`, :code:`getAPredecessor`, :code:`getASuccessor`, :code:`getDepth`, and :code:`getPath` predicates from :code:`API::Node`.
*   Deleted the deprecated :code:`Root`, :code:`Use`, and :code:`Def` classes from :code:`ApiGraphs.qll`.
*   Deleted the deprecated :code:`Label` module from :code:`ApiGraphs.qll`.
*   Deleted the deprecated :code:`getAUse`, :code:`getAnImmediateUse`, :code:`getARhs`, and :code:`getAValueReachingRhs` predicates from :code:`API::Node`, use :code:`getAValueReachableFromSource`, :code:`asSource`, :code:`asSink`, and :code:`getAValueReachingSink` instead.
*   Deleted the deprecated :code:`getAVariable` predicate from the :code:`ExprNode` class, use :code:`getVariable` instead.
*   Deleted the deprecated :code:`getAPotentialFieldAccessMethod` predicate from the :code:`ActiveRecordModelClass` class.
*   Deleted the deprecated :code:`ActiveRecordModelClassMethodCall` class from :code:`ActiveRecord.qll`, use :code:`ActiveRecordModelClass.getClassNode().trackModule().getMethod()` instead.
*   Deleted the deprecated :code:`PotentiallyUnsafeSqlExecutingMethodCall` class from :code:`ActiveRecord.qll`, use the :code:`SqlExecution` concept instead.
*   Deleted the deprecated :code:`ModelClass` and :code:`ModelInstance` classes from :code:`ActiveResource.qll`, use :code:`ModelClassNode` and :code:`ModelClassNode.getAnInstanceReference()` instead.
*   Deleted the deprecated :code:`Collection` class from :code:`ActiveResource.qll`, use :code:`CollectionSource` instead.
*   Deleted the deprecated :code:`ServiceInstantiation` and :code:`ClientInstantiation` classes from :code:`Twirp.qll`.
*   Deleted a lot of deprecated dataflow modules from "*Query.qll" files.
*   Deleted the old deprecated TypeTracking library.

Swift
"""""

*   Deleted the deprecated :code:`ArrayContent` class from the dataflow library, use :code:`CollectionContent` instead.
*   Deleted the deprecated :code:`getOptionsInput`, :code:`getRegexInput`, and :code:`getStringInput` predicates from the regexp library, use :code:`getAnOptionsInput`, :code:`getRegexInputNode`, and :code:`getStringInputNode` instead.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added new XSS sink where :code:`innerHTML` or :code:`outerHTML` is assigned to with the Angular Renderer2 API, plus modeled this API as a general attribute setter

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   C# 13: Added MaD models for some overload implementations using :code:`ReadOnlySpan` parameters (like :code:`String.Format(System.String, System.ReadOnlySpan<System.Object>))`).
*   C# 13: Added support for the overload resolution priority attribute (:code:`OverloadResolutionPriority`). Usages of the attribute and the corresponding priority can be found using the QL class :code:`SystemRuntimeCompilerServicesOverloadResolutionPriorityAttribute`.
*   C# 13: Added support for partial properties and indexers.

Golang
""""""

*   Models-as-data models using "Parameter", "Parameter[n]" or "Parameter[n1..n2]" as the output now work correctly.
*   By implementing :code:`ImplicitFieldReadNode` it is now possible to declare a dataflow node that reads any content (fields, array members, map keys and values). For example, this is appropriate for modelling a serialization method that flattens a potentially deep data structure into a string or byte array.
*   The :code:`Template.Execute[Template]` methods of the :code:`text/template` package now correctly convey taint from any nested fields to their result. This may produce more results from any taint-tracking query when the :code:`text/template` package is in use.
*   Added the `rs cors <https://github.com/rs/cors>`__ library to the CorsMisconfiguration.ql query

Java/Kotlin
"""""""""""

*   We now allow classes which don't have any JAX-RS annotations to inherit JAX-RS annotations from superclasses or interfaces. This is not allowed in the JAX-RS specification, but some implementations, like Apache CXF, allow it. This may lead to more alerts being found.

Python
""""""

*   Additional data flow models for the builtin functions :code:`map`, :code:`filter`, :code:`zip`, and :code:`enumerate` have been added.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   A new predicate :code:`getOffsetInClass` was added to the :code:`Field` class, which computes the byte offset of a field relative to a given :code:`Class`.
*   New classes :code:`PreprocessorElifdef` and :code:`PreprocessorElifndef` were introduced, which represents the C23/C++23 :code:`#elifdef` and :code:`#elifndef` preprocessor directives.
*   A new class :code:`TypeLibraryImport` was introduced, which represents the :code:`#import` preprocessor directive as used by the Microsoft Visual C++ for importing type libraries.

Shared Libraries
----------------

Breaking Changes
~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   Deleted the deprecated :code:`Make` and :code:`MakeWithState` modules, use :code:`Global` and :code:`GlobalWithState` instead.
*   Deleted the deprecated :code:`hasFlow`, :code:`hasFlowPath`, :code:`hasFlowTo`, and :code:`hasFlowToExpr` predicates, use :code:`flow`, :code:`flowPath`, :code:`flowTo`, and :code:`flowToExpr` respectively instead.

Control Flow Analysis
"""""""""""""""""""""

*   Added a basic block construction as part of the library. This is currently considered an internal unstable API. The input signature to the control flow graph now requires two additional predicates: :code:`idOfAstNode` and
    :code:`idOfCfgScope`.

Type Trackers
"""""""""""""

*   Deleted the deprecated :code:`ConsistencyChecks` module.
