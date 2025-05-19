.. _codeql-cli-2.20.6:

==========================
CodeQL 2.20.6 (2025-03-06)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.20.6 runs a total of 450 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 137 queries (covering 35 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Miscellaneous
~~~~~~~~~~~~~

*   The CodeQL XML extractor is now able to parse documents in a wider array of character sets.
    
*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.6.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

GitHub Actions
""""""""""""""

*   The :code:`actions/unversioned-immutable-action` query will no longer report any alerts, since the Immutable Actions feature is not yet available for customer use. The query has also been moved to the experimental folder and will not be used in code scanning unless it is explicitly added to a code scanning configuration. Once the Immutable Actions feature is available, the query will be updated to report alerts again.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Fixed false positive alerts in the java query "Cross-site scripting" (:code:`java/xss`) when :code:`javax.servlet.http.HttpServletResponse` is used with a content type which is not exploitable.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved precision of data flow through arrays, fixing some spurious flows that would sometimes cause the :code:`length` property of an array to be seen as tainted.
*   Improved call resolution logic to better handle calls resolving "downwards", targeting a method declared in a subclass of the enclosing class. Data flow analysis has also improved to avoid spurious flow between unrelated classes in the class hierarchy.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Due to changes in libraries the query "Static array access may cause overflow" (:code:`cpp/static-buffer-overflow`) will no longer report cases where multiple fields of a struct or class are written with a single :code:`memset` or similar operation.
*   The query "Call to memory access function may overflow buffer" (:code:`cpp/overflow-buffer`) has been added to the security-extended query suite. The query detects a range of buffer overflow and underflow issues.

C#
""

*   C#: Improve precision of the query :code:`cs/call-to-object-tostring` for value tuples.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Go 1.24 is now supported. This includes the new language feature of generic type aliases.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for the :code:`response` threat model kind, which can enabled with `advanced setup <https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models>`__. When enabled, the response data coming back from an outgoing HTTP request is considered a source of taint.
*   Added support for the :code:`useQuery` hook from :code:`@tanstack/react-query`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Modified the :code:`getBufferSize` predicate in :code:`commons/Buffer.qll` to be more tolerant in some cases involving member variables in a larger struct or class.
*   Fixed an issue where the :code:`getBufferSize` predicate in :code:`commons/Buffer.qll` was returning results for references inside :code:`offsetof` expressions, which are not accesses to a buffer.

Golang
""""""

*   The location info for the following classes has been changed slightly to match a location that is in the database: :code:`BasicBlock`, :code:`ControlFlow::EntryNode`, :code:`ControlFlow::ExitNode`, :code:`ControlFlow::ConditionGuardNode`, :code:`IR::ImplicitLiteralElementIndexInstruction`, :code:`IR::EvalImplicitTrueInstruction`, :code:`SsaImplicitDefinition`, :code:`SsaPhiNode`.
*   Added :code:`database` source models for the :code:`github.com/rqlite/gorqlite` package.
*   Added :code:`database` source models for database methods from the :code:`go.mongodb.org/mongo-driver/mongo` package.

Java/Kotlin
"""""""""""

*   Added a path injection sanitizer for the :code:`child` argument of a :code:`java.io.File` constructor if that argument does not contain path traversal sequences.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`response.download()` function in :code:`express` is now recognized as a sink for path traversal attacks.

Deprecated APIs
~~~~~~~~~~~~~~~

Golang
""""""

*   The member predicate :code:`hasLocationInfo` has been deprecated on the following classes: :code:`BasicBlock`, :code:`Callable`, :code:`Content`, :code:`ContentSet`, :code:`ControlFlow::Node`, :code:`DataFlowCallable`, :code:`DataFlow::Node`, :code:`Entity`, :code:`GVN`, :code:`HtmlTemplate::TemplateStmt`, :code:`IR:WriteTarget`, :code:`SourceSinkInterpretationInput::SourceOrSinkElement`, :code:`SourceSinkInterpretationInput::InterpretNode`, :code:`SsaVariable`, :code:`SsaDefinition`, :code:`SsaWithFields`, :code:`StringOps::ConcatenationElement`, :code:`Type`, and :code:`VariableWithFields`. Use :code:`getLocation()` instead.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The Java extractor and QL libraries now support Java 24.
