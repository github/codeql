.. _codeql-cli-2.12.5:

==========================
CodeQL 2.12.5 (2023-03-21)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.5 runs a total of 385 security queries when configured with the Default suite (covering 154 CWE). The Extended suite enables an additional 124 queries (covering 31 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fix a bug in :code:`codeql query run` where queries whose path contain colons cannot be run.

New Features
~~~~~~~~~~~~

*   The :code:`codeql pack install` command now accepts a :code:`--additional-packs` option. This option takes a list of directories to search for locally available packs when resolving which packs to install. Any pack that is found locally through :code:`--additional-packs` will override any other version of a pack found in the package registry.
    Locally resolved packs are not added to the lock file.
    
    Because the use of :code:`--additional-packs` when running
    :code:`codeql pack install` makes running queries dependent on the local state of the machine initially invoking :code:`codeql pack install`, a warning is emitted if any pack is found outside of the package registry. This warning can be suppressed by using the
    :code:`--no-strict-mode` option.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The following queries now recognize HTML sanitizers as propagating taint: :code:`js/sql-injection`,
    :code:`js/path-injection`, :code:`js/server-side-unvalidated-url-redirection`, :code:`js/client-side-unvalidated-url-redirection`,
    and :code:`js/request-forgery`.

Deprecated Queries
~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`NetworkToBufferSizeConfiguration` and :code:`UntrustedDataToExternalApiConfig` dataflow configurations have been deprecated. Please use :code:`NetworkToBufferSizeFlow` and :code:`UntrustedDataToExternalApiFlow`.
*   The :code:`LeapYearCheckConfiguration`, :code:`FiletimeYearArithmeticOperationCheckConfiguration`, and :code:`PossibleYearArithmeticOperationCheckConfiguration` dataflow configurations have been deprecated. Please use :code:`LeapYearCheckFlow`, :code:`FiletimeYearArithmeticOperationCheckFlow` and :code:`PossibleYearArithmeticOperationCheckFlow`.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/android/arbitrary-apk-installation`, to detect installation of APKs from untrusted sources.

Python
""""""

*   Added a new query, :code:`py/shell-command-constructed-from-input`, to detect libraries that unsafely construct shell commands from their inputs.

Ruby
""""

*   Added a new query, :code:`rb/zip-slip`, to detect arbitrary file writes during extraction of zip/tar archives.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`semmle.code.cpp.commons.Buffer` and :code:`semmle.code.cpp.commons.NullTermination` libraries no longer expose :code:`semmle.code.cpp.dataflow.DataFlow`. Please import :code:`semmle.code.cpp.dataflow.DataFlow` directly.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   A new C/C++ dataflow library (:code:`semmle.code.cpp.dataflow.new.DataFlow`) has been added.
    The new library behaves much more like the dataflow library of other CodeQL supported languages by following use-use dataflow paths instead of def-use dataflow paths.
    The new library also better supports dataflow through indirections, and new predicates such as :code:`Node::asIndirectExpr` have been added to facilitate working with indirections.
    
    The :code:`semmle.code.cpp.ir.dataflow.DataFlow` library is now identical to the new
    :code:`semmle.code.cpp.dataflow.new.DataFlow` library.
    
*   The main data flow and taint tracking APIs have been changed. The old APIs remain in place for now and translate to the new through a backwards-compatible wrapper. If multiple configurations are in scope simultaneously, then this may affect results slightly. The new API is quite similar to the old, but makes use of a configuration module instead of a configuration class.

C#
""

*   The main data flow and taint tracking APIs have been changed. The old APIs remain in place for now and translate to the new through a backwards-compatible wrapper. If multiple configurations are in scope simultaneously, then this may affect results slightly. The new API is quite similar to the old, but makes use of a configuration module instead of a configuration class.

Golang
""""""

*   The main data flow and taint tracking APIs have been changed. The old APIs remain in place for now and translate to the new through a backwards-compatible wrapper. If multiple configurations are in scope simultaneously, then this may affect results slightly. The new API is quite similar to the old, but makes use of a configuration module instead of a configuration class.

Java/Kotlin
"""""""""""

*   Removed low-confidence call edges to known neutral call targets from the call graph used in data flow analysis. This includes, for example, custom :code:`List.contains` implementations when the best inferrable type at the call site is simply :code:`List`.
*   Added more sink and summary dataflow models for the following packages:

    *   :code:`java.io`
    *   :code:`java.lang`
    *   :code:`java.sql`
    *   :code:`javafx.scene.web`
    *   :code:`org.apache.commons.compress.archivers.tar`
    *   :code:`org.apache.http.client.utils`
    *   :code:`org.codehaus.cargo.container.installer`
    
*   The main data flow and taint tracking APIs have been changed. The old APIs remain in place for now and translate to the new through a backwards-compatible wrapper. If multiple configurations are in scope simultaneously, then this may affect results slightly. The new API is quite similar to the old, but makes use of a configuration module instead of a configuration class.

Python
""""""

*   The main data flow and taint tracking APIs have been changed. The old APIs remain in place for now and translate to the new through a backwards-compatible wrapper. If multiple configurations are in scope simultaneously, then this may affect results slightly. The new API is quite similar to the old, but makes use of a configuration module instead of a configuration class.

Ruby
""""

*   The main data flow and taint tracking APIs have been changed. The old APIs remain in place for now and translate to the new through a backwards-compatible wrapper. If multiple configurations are in scope simultaneously, then this may affect results slightly. The new API is quite similar to the old, but makes use of a configuration module instead of a configuration class.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the deprecated :code:`hasGeneratedCopyConstructor` and :code:`hasGeneratedCopyAssignmentOperator` predicates from the :code:`Folder` class.
*   Deleted the deprecated :code:`getPath` and :code:`getFolder` predicates from the :code:`XmlFile` class.
*   Deleted the deprecated :code:`getMustlockFunction`, :code:`getTrylockFunction`, :code:`getLockFunction`, and :code:`getUnlockFunction` predicates from the :code:`MutexType` class.
*   Deleted the deprecated :code:`getPosInBasicBlock` predicate from the :code:`SubBasicBlock` class.
*   Deleted the deprecated :code:`getExpr` predicate from the :code:`PointerDereferenceExpr` class.
*   Deleted the deprecated :code:`getUseInstruction` and :code:`getDefinitionInstruction` predicates from the :code:`Operand` class.
*   Deleted the deprecated :code:`isInParameter`, :code:`isInParameterPointer`, and :code:`isInQualifier` predicates from the :code:`FunctionInput` class.
*   Deleted the deprecated :code:`isOutParameterPointer`, :code:`isOutQualifier`, :code:`isOutReturnValue`, and :code:`isOutReturnPointer` predicate from the :code:`FunctionOutput` class.
*   Deleted the deprecated 3-argument :code:`isGuardPhi` predicate from the :code:`RangeSsaDefinition` class.

C#
""

*   Deleted the deprecated :code:`getPath` and :code:`getFolder` predicates from the :code:`XmlFile` class.
*   Deleted the deprecated :code:`getAssertionIndex`, and :code:`getAssertedParameter` predicates from the :code:`AssertMethod` class.
*   Deleted the deprecated :code:`OverridableMethod` and :code:`OverridableAccessor` classes.
*   The :code:`unsafe` predicate for :code:`Modifiable` has been extended to cover delegate return types and identify pointer-like types at any nest level. This is relevant for :code:`unsafe` declarations extracted from assemblies.

Java/Kotlin
"""""""""""

*   Deleted the deprecated :code:`getPath` and :code:`getFolder` predicates from the :code:`XmlFile` class.
*   Deleted the deprecated :code:`getRepresentedString` predicate from the :code:`StringLiteral` class.
*   Deleted the deprecated :code:`ServletWriterSource` class.
*   Deleted the deprecated :code:`getGroupID`, :code:`getArtefactID`, and :code:`artefactMatches` predicates from the :code:`MavenRepoJar` class.

JavaScript/TypeScript
"""""""""""""""""""""

*   Deleted the deprecated :code:`getPath` and :code:`getFolder` predicates from the :code:`XmlFile` class.
*   Deleted the deprecated :code:`getId` from the :code:`Function`, :code:`NamespaceDefinition`, and :code:`ImportEqualsDeclaration` classes.
*   Deleted the deprecated :code:`flowsTo` predicate from the :code:`HTTP::Servers::RequestSource` and :code:`HTTP::Servers::ResponseSource` class.
*   Deleted the deprecated :code:`getEventName` predicate from the :code:`SocketIO::ReceiveNode`, :code:`SocketIO::SendNode`, :code:`SocketIOClient::SendNode` classes.
*   Deleted the deprecated :code:`RateLimitedRouteHandlerExpr` and :code:`RouteHandlerExpressionWithRateLimiter` classes.
*   \ `Import assertions <https://github.com/tc39/proposal-import-assertions>`__ are now supported.
    Previously this feature was only supported in TypeScript code, but is now supported for plain JavaScript as well and is also accessible in the AST.

Python
""""""

*   Deleted the deprecated :code:`getPath` and :code:`getFolder` predicates from the :code:`XmlFile` class.

Ruby
""""

*   Data flow through :code:`initialize` methods is now taken into account also when the receiver of a :code:`new` call is an (implicit or explicit) :code:`self`.
*   The Active Record query methods :code:`reorder` and :code:`count_by_sql` are now recognized as SQL executions.
*   Calls to :code:`ActiveRecord::Connection#execute`, including those via subclasses, are now recognized as SQL executions.
*   Data flow through :code:`ActionController::Parameters#require` is now tracked properly.
*   The severity of parse errors was reduced to warning (previously error).
*   Deleted the deprecated :code:`getQualifiedName` predicate from the :code:`ConstantWriteAccess` class.
*   Deleted the deprecated :code:`getWhenBranch` and :code:`getAWhenBranch` predicates from the :code:`CaseExpr` class.
*   Deleted the deprecated :code:`Self`, :code:`PatternParameter`, :code:`Pattern`, :code:`VariablePattern`, :code:`TuplePattern`, and :code:`TuplePatternParameter` classes.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`WriteConfig` taint tracking configuration has been deprecated. Please use :code:`WriteFlow`.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added support for merging two :code:`PathGraph`\ s via disjoint union to allow results from multiple data flow computations in a single :code:`path-problem` query.

C#
""

*   Added support for merging two :code:`PathGraph`\ s via disjoint union to allow results from multiple data flow computations in a single :code:`path-problem` query.

Golang
""""""

*   Added support for merging two :code:`PathGraph`\ s via disjoint union to allow results from multiple data flow computations in a single :code:`path-problem` query.

Java/Kotlin
"""""""""""

*   Added support for merging two :code:`PathGraph`\ s via disjoint union to allow results from multiple data flow computations in a single :code:`path-problem` query.

Python
""""""

*   Added support for merging two :code:`PathGraph`\ s via disjoint union to allow results from multiple data flow computations in a single :code:`path-problem` query.

Ruby
""""

*   Added support for merging two :code:`PathGraph`\ s via disjoint union to allow results from multiple data flow computations in a single :code:`path-problem` query.
