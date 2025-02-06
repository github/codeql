.. _codeql-cli-2.20.1:

==========================
CodeQL 2.20.1 (2025-01-09)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.20.1 runs a total of 454 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE). 22 security queries have been added with this release.

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   Automatic installation of dependencies for C++ autobuild is now supported on Ubuntu 24.04.
    
*   The CLI will now warn if it detects that it is installed in a location where it is likely to cause performance issues. This includes: user home, desktop, downloads, or the file system root.
    
    You can avoid this warning by setting the :code:`CODEQL_ALLOW_INSTALLATION_ANYWHERE` environment variable to :code:`true`.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Returning stack-allocated memory" query (:code:`cpp/return-stack-allocated-memory`) no longer produces results if there is an extraction error in the returned expression.
*   The "Badly bounded write" query (:code:`cpp/badly-bounded-write`) no longer produces results if there is an extraction error in the type of the output buffer.
*   The "Too few arguments to formatting function" query (:code:`cpp/wrong-number-format-arguments`) no longer produces results if an argument has an extraction error.
*   The "Wrong type of arguments to formatting function" query (:code:`cpp/wrong-type-format-argument`) no longer produces results when an argument type has an extraction error.
*   Added dataflow models and flow sources for Microsoft's Active Template Library (ATL).

C#
""

*   The :code:`ExternalApi` and :code:`TestLibrary` modules have been moved to the library pack.

New Queries
~~~~~~~~~~~

Python
""""""

*   The Server Side Template Injection query (:code:`py/template-injection`), originally contributed to the experimental query pack by @porcupineyhairs, has been promoted to the main query suite. This query finds instances of templates for a template engine such as Jinja being constructed with user input.

Actions
"""""""

*   Initial public preview release

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The class :code:`ControlFlowNode` (and by extension :code:`BasicBlock`) is no longer directly equatable to :code:`Expr` and :code:`Stmt`. Any queries that have been exploiting these equalities, for example by using casts, will need minor updates in order to fix any compilation errors. Conversions can be inserted in either direction depending on what is most convenient. Available conversions include :code:`Expr.getControlFlowNode()`, :code:`Stmt.getControlFlowNode()`,
    :code:`ControlFlowNode.asExpr()`, :code:`ControlFlowNode.asStmt()`, and
    :code:`ControlFlowNode.asCall()`. Exit nodes were until now modelled as a
    :code:`ControlFlowNode` equal to its enclosing :code:`Callable`\ ; these are now instead modelled by the class :code:`ControlFlow::ExitNode`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.0.2.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`Guards` library (:code:`semmle.code.cpp.controlflow.Guards`) has been improved to recognize more guard conditions.

C#
""

*   C# 13: Added QL library support for *collection* like type :code:`params` parameters.
*   Added :code:`remote` flow source models for properties of Blazor components annotated with any of the following attributes from :code:`Microsoft.AspNetCore.Components`\ :

    *   :code:`[SupplyParameterFromForm]`
    *   :code:`[SupplyParameterFromQuery]`
    
*   Added the constructor and explicit cast operator of :code:`Microsoft.AspNetCore.Components.MarkupString` as an :code:`html-injection` sink. This will help catch cross-site scripting resulting from using :code:`MarkupString`.
*   Added flow summaries for the :code:`Microsoft.AspNetCore.Mvc.Controller::View` method.
*   The data flow library has been updated to track types in a slightly different way: The type of the tainted data (which may be stored into fields, etc.) is tracked more precisely, while the types of intermediate containers for nested contents is tracked less precisely. This may have a slight effect on false positives for complex flow paths.
*   The C# extractor now supports *basic* extraction of .NET 9 projects. There might be limited support for extraction of code using the new C# 13 language features.

Golang
""""""

*   Added a :code:`commandargs` local source model for the :code:`os.Args` variable.

Java/Kotlin
"""""""""""

*   Added :code:`java.io.File.getName()` as a path injection sanitizer.
*   The data flow library has been updated to track types in a slightly different way: The type of the tainted data (which may be stored into fields, etc.) is tracked more precisely, while the types of intermediate containers for nested contents is tracked less precisely. This may have a slight effect on false positives for complex flow paths.
*   Added a sink for "Server-side request forgery" (:code:`java/ssrf`) for the third parameter to org.springframework.web.client.RestTemplate.getForObject, when we cannot statically determine that it does not affect the host in the URL.

Python
""""""

*   Added modeling of :code:`fastapi.Request` and :code:`starlette.requests.Request` as sources of untrusted input,
    and modeling of tainted data flow out of these request objects.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`TemplateParameter` class, representing C++ type template parameters has been deprecated. Use :code:`TypeTemplateParameter` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   New classes :code:`SizeofPackExprOperator` and :code:`SizeofPackTypeOperator` were introduced, which represent the C++ :code:`sizeof...` operator taking expressions and type arguments, respectively.
*   A new class :code:`TemplateTemplateParameterInstantiation` was introduced, which represents instantiations of template template parameters.
*   A new predicate :code:`getAnInstantiation` was added to the :code:`TemplateTemplateParameter` class, which yields instantiations of template template parameters.
*   The :code:`getTemplateArgumentType` and :code:`getTemplateArgumentValue` predicates of the :code:`Declaration` class now also yield template arguments of template template parameters.
*   A new class :code:`NonTypeTemplateParameter` was introduced, which represents C++ non-type template parameters.
*   A new class :code:`TemplateParameterBase` was introduced, which represents C++ non-type template parameters, type template parameters, and template template parameters.

Python
""""""

*   Added support for parameter annotations in API graphs. This means that in a function definition such as :code:`def foo(x: Bar): ...`, you can now use the :code:`getInstanceFromAnnotation()` method to step from :code:`Bar` to :code:`x`. In addition to this, the :code:`getAnInstance` method now also includes instances arising from parameter annotations.

Actions
"""""""

*   Initial public preview release

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   Added a module :code:`DataFlow::DeduplicatePathGraph` that can be used to avoid generating duplicate path explanations in queries that use flow state.
