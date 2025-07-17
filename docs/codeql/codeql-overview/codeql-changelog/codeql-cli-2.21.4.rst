.. _codeql-cli-2.21.4:

==========================
CodeQL 2.21.4 (2025-06-02)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.21.4 runs a total of 449 security queries when configured with the Default suite (covering 165 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE).

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   The :code:`clang_vector_types`, :code:`clang_attributes`, and :code:`flax-vector-conversions` command line options have been removed from the C/C++ extractor. These options were introduced as workarounds to frontend limitations in earlier versions of the extractor and are no longer needed when calling the extractor directly.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.7.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added flow model for the :code:`SQLite` and :code:`OpenSSL` libraries. This may result in more alerts when running queries on codebases that use these libraries.

C#
""

*   The precision of the query :code:`cs/missed-readonly-modifier` has been improved. Some false positives related to static fields and struct type fields have been removed.
*   The queries :code:`cs/password-in-configuration`, :code:`cs/hardcoded-credentials` and :code:`cs/hardcoded-connection-string-credentials` have been removed from all query suites.
*   The precision of the query :code:`cs/gethashcode-is-not-defined` has been improved (false negative reduction). Calls to more methods (and indexers) that rely on the invariant :code:`e1.Equals(e2)` implies :code:`e1.GetHashCode() == e2.GetHashCode()` are taken into account.
*   The precision of the query :code:`cs/uncontrolled-format-string` has been improved (false negative reduction). Calls to :code:`System.Text.CompositeFormat.Parse` are now considered a format like method call.

Golang
""""""

*   The query :code:`go/hardcoded-credentials` has been removed from all query suites.

Java/Kotlin
"""""""""""

*   The query :code:`java/hardcoded-credential-api-call` has been removed from all query suites.

JavaScript/TypeScript
"""""""""""""""""""""

*   The queries :code:`js/hardcoded-credentials` and :code:`js/password-in-configuration-file` have been removed from all query suites.

Python
""""""

*   The query :code:`py/hardcoded-credentials` has been removed from all query suites.

Ruby
""""

*   The query :code:`rb/hardcoded-credentials` has been removed from all query suites.

Swift
"""""

*   The queries :code:`swift/hardcoded-key` and :code:`swift/constant-password` have been removed from all query suites.

GitHub Actions
""""""""""""""

*   The query :code:`actions/missing-workflow-permissions` is now aware of the minimal permissions needed for the actions :code:`deploy-pages`, :code:`delete-package-versions`, :code:`ai-inference`. This should lead to better alert messages and better fix suggestions.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Fixed a problem where :code:`asExpr()` on :code:`DataFlow::Node` would never return :code:`ArrayAggregateLiteral`\ s.
*   Fixed a problem where :code:`asExpr()` on :code:`DataFlow::Node` would never return :code:`ClassAggregateLiteral`\ s.

Ruby
""""

*   Bug Fixes
*   The Ruby printAst.qll library now orders AST nodes slightly differently: child nodes that do not literally appear in the source code, but whose parent nodes do, are assigned a deterministic order based on a combination of source location and logical order within the parent. This fixes the non-deterministic ordering that sometimes occurred depending on evaluation order. The effect may also be visible in downstream uses of the printAst library, such as the AST view in the VSCode extension.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the deprecated :code:`userInputArgument` predicate and its convenience accessor from the :code:`Security.qll`.
*   Deleted the deprecated :code:`userInputReturned` predicate and its convenience accessor from the :code:`Security.qll`.
*   Deleted the deprecated :code:`userInputReturn` predicate from the :code:`Security.qll`.
*   Deleted the deprecated :code:`isUserInput` predicate and its convenience accessor from the :code:`Security.qll`.
*   Deleted the deprecated :code:`userInputArgument` predicate from the :code:`SecurityOptions.qll`.
*   Deleted the deprecated :code:`userInputReturned` predicate from the :code:`SecurityOptions.qll`.

Swift
"""""

*   Deleted the deprecated :code:`parseContent` predicate from the :code:`ExternalFlow.qll`.
*   Deleted the deprecated :code:`hasLocationInfo` predicate from the :code:`DataFlowPublic.qll`.
*   Deleted the deprecated :code:`SummaryComponent` class from the :code:`FlowSummary.qll`.
*   Deleted the deprecated :code:`SummaryComponentStack` class from the :code:`FlowSummary.qll`.
*   Deleted the deprecated :code:`SummaryComponent` module from the :code:`FlowSummary.qll`.
*   Deleted the deprecated :code:`SummaryComponentStack` module from the :code:`FlowSummary.qll`.
*   Deleted the deprecated :code:`RequiredSummaryComponentStack` class from the :code:`FlowSummary.qll`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The generated Models as Data (MaD) models for .NET 9 Runtime have been updated and are now more precise (due to a recent model generator improvement).

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved analysis for :code:`ES6 classes` mixed with :code:`function prototypes`, leading to more accurate call graph resolution.

Python
""""""

*   The Python extractor now extracts files in hidden directories by default. If you would like to skip files in hidden directories, add :code:`paths-ignore: ["**/.*/**"]` to your `Code Scanning config <https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#specifying-directories-to-scan>`__. If you would like to skip all hidden files, you can use :code:`paths-ignore: ["**/.*"]`. When using the CodeQL CLI for extraction, specify the configuration (creating the configuration file if necessary) using the :code:`--codescanning-config` option.

Ruby
""""

*   Captured variables are currently considered live when the capturing function exits normally. Now they are also considered live when the capturing function exits via an exception.

Swift
"""""

*   Updated to allow analysis of Swift 6.1.1.
*   :code:`TypeValueExpr` experimental AST leaf is now implemented in the control flow library

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The predicate :code:`getValue()` on :code:`SpringRequestMappingMethod` is now deprecated. Use :code:`getAValue()` instead.
*   Java now uses the shared :code:`BasicBlock` library. This means that the names of several member predicates have been changed to align with the names used in other languages. The old predicates have been deprecated. The :code:`BasicBlock` class itself no longer extends :code:`ControlFlowNode` - the predicate :code:`getFirstNode` can be used to fix any QL code that somehow relied on this.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added local flow source models for :code:`ReadFile`, :code:`ReadFileEx`, :code:`MapViewOfFile`, :code:`MapViewOfFile2`, :code:`MapViewOfFile3`, :code:`MapViewOfFile3FromApp`, :code:`MapViewOfFileEx`, :code:`MapViewOfFileFromApp`, :code:`MapViewOfFileNuma2`, and :code:`NtReadFile`.
*   Added the :code:`pCmdLine` arguments of :code:`WinMain` and :code:`wWinMain` as local flow sources.
*   Added source models for :code:`GetCommandLineA`, :code:`GetCommandLineW`, :code:`GetEnvironmentStringsA`, :code:`GetEnvironmentStringsW`, :code:`GetEnvironmentVariableA`, and :code:`GetEnvironmentVariableW`.
*   Added summary models for :code:`CommandLineToArgvA` and :code:`CommandLineToArgvW`.
*   Added support for :code:`wmain` as part of the ArgvSource model.

Shared Libraries
----------------

Breaking Changes
~~~~~~~~~~~~~~~~

Static Single Assignment (SSA)
""""""""""""""""""""""""""""""

*   Adjusted the Guards interface in the SSA data flow integration to distinguish :code:`hasBranchEdge` from :code:`controlsBranchEdge`. Any breakage can be fixed by implementing one with the other as a reasonable fallback solution.
