.. _codeql-cli-2.20.5:

==========================
CodeQL 2.20.5 (2025-02-20)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.20.5 runs a total of 450 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 136 queries (covering 34 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   Removed support for :code:`QlBuiltins::BigInt`\ s in the :code:`avg()` aggregate.
    
*   A number of breaking changes have been made to the C and C++ CodeQL test environment as used by :code:`codeql test run`\ :

    *   The :code:`-Xclang-only=<arg>` option is no longer supported by :code:`semmle-extractor-options`. Instead, when either :code:`--clang` or :code:`--clang_version` is specified the option should be replaced by :code:`<arg>` only, otherwise the option should be omitted.
    *   The :code:`--sys_include <arg>` and :code:`--preinclude <arg>` options are no longer supported by :code:`semmle-extractor-options`. Instead, :code:`--edg <option_name> --edg <arg>` should be specified.
    *   The :code:`-idirafter <arg>` option is no longer supported by :code:`semmle-extractor-options`. Instead, :code:`--edg --sys_include --edg <arg>` should be specified.
    *   The :code:`-imacros <arg>` option is no longer supported by :code:`semmle-extractor-options`. Instead, :code:`--edg --preinclude_macros --edg <arg>` should be specified.
    *   The :code:`/FI <arg>` option is no longer supported by :code:`semmle-extractor-options`. Instead, :code:`--edg --preinclude --edg <arg>` should be specified.
    *   The :code:`-Wreserved-user-defined-literal`, :code:`-Wno-reserved-user-defined-literal`, :code:`-fwritable-strings`, :code:`/Zc:rvalueCast`, :code:`/Zc:rvalueCast-`, and :code:`/Zc:wchar_t-` options are no longer supported by :code:`semmle-extractor-options`. Instead, :code:`--edg --reserved_user_defined_literal`, :code:`--edg --no-reserved_user_defined_literal`, :code:`--edg --no_const_string_literals`, :code:`--edg --no_preserve_lvalues_with_same_type_casts`, :code:`--edg --preserve_lvalues_with_same_type_casts`, and :code:`--edg --no_wchar_t_keyword` should be specified, respectively.
    *   The :code:`/Fo <arg>` option is no longer supported by :code:`semmle-extractor-options`. The option should be omitted.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a recently-introduced bug that prevented taint tracking through :code:`URLSearchParams` objects.
    The original behaviour has been restored and taint should once again be tracked through such objects.
*   Fixed a rare issue that would occur when a function declaration inside a block statement was referenced before it was declared.
    Such code is reliant on legacy web semantics, which is non-standard but nevertheless implemented by most engines.
    CodeQL now takes legacy web semantics into account and resolves references to these functions correctly.
*   Fixed a bug that would cause parse errors in :code:`.jsx` files in rare cases where the file contained syntax that was misinterpreted as Flow syntax.

Breaking Changes
~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   The following queries have been removed from the :code:`code-scanning` and :code:`security-extended` suites.
    Any existing alerts for these queries will be closed automatically.

    *   :code:`actions/if-expression-always-true/critical`
    *   :code:`actions/if-expression-always-true/high`
    *   :code:`actions/unnecessary-use-of-advanced-config`
    
*   The following query has been moved from the :code:`code-scanning` suite to the :code:`security-extended` suite. Any existing alerts for this query will be closed automatically unless the analysis is configured to use the :code:`security-extended` suite.

    *   :code:`actions/unpinned-tag`
    
*   The following queries have been added to the :code:`security-extended` suite.

    *   :code:`actions/unversioned-immutable-action`
    *   :code:`actions/envpath-injection/medium`
    *   :code:`actions/envvar-injection/medium`
    *   :code:`actions/code-injection/medium`
    *   :code:`actions/artifact-poisoning/medium`
    *   :code:`actions/untrusted-checkout/medium`

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Added `github.com/gorilla/mux.Vars <https://pkg.go.dev/github.com/gorilla/mux#Vars>`__ to path sanitizers (disabled if `github.com/gorilla/mix.Router.SkipClean <https://pkg.go.dev/github.com/gorilla/mux#Router.SkipClean>`__ has been called).

GitHub Actions
""""""""""""""

*   Fixed false positives in the query :code:`actions/unpinned-tag` (CWE-829), which will no longer flag uses of Docker-based GitHub actions pinned by the container's SHA256 digest.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/csrf-unprotected-request-type`, to detect Cross-Site Request Forgery (CSRF) vulnerabilities due to using HTTP request types that are not default-protected from CSRF.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Python
""""""

*   Fixed a bug in the extractor where a comment inside a subscript could sometimes cause the AST to be missing nodes.
*   Using the :code:`break` and :code:`continue` keywords outside of a loop, which is a syntax error but is accepted by our parser, would cause the control-flow construction to fail. This is now no longer the case.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Go 1.24 is now supported. This includes the new language feature of generic type aliases.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Full support for C# 13 / .NET 9. All new language features are now supported by the extractor. QL library and data flow support for the new C# 13 language constructs and generated MaD models for the .NET 9 runtime.
*   C# 13: Add generated models for .NET 9.
*   The models for :code:`System.Net.Http.HttpRequestMessage` and :code:`System.UriBuilder` have been modified to better model the flow of tainted URIs.
*   Blazor :code:`[Parameter]` fields bound to a variable from the route specified in the :code:`@page` directive are now modeled as remote flow sources.

Golang
""""""

*   Taint models have been added for the :code:`weak` package, which was added in Go 1.24.
*   Taint models have been added for the interfaces :code:`TextAppender` and :code:`BinaryAppender` in the :code:`encoding` package, which were added in Go 1.24.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for regular expressions using the :code:`v` flag.

Deprecated APIs
~~~~~~~~~~~~~~~

C#
""

*   The predicates :code:`immediatelyControls` and :code:`controls` on the :code:`ConditionBlock` class have been deprecated in favor of the newly added :code:`dominatingEdge` predicate.

Golang
""""""

*   The class :code:`NamedType` has been deprecated. Use the new class :code:`DefinedType` instead. This better matches the terminology used in the Go language specification, which was changed in Go 1.9.
*   The member predicate :code:`getNamedType` on :code:`GoMicro::ServiceInterfaceType` has been deprecated. Use the new member predicate :code:`getDefinedType` instead.
*   The member predicate :code:`getNamedType` on :code:`Twirp::ServiceInterfaceType` has been deprecated. Use the new member predicate :code:`getDefinedType` instead.

Ruby
""""

*   The predicates :code:`immediatelyControls` and :code:`controls` on the :code:`ConditionBlock` class have been deprecated in favor of the newly added :code:`dominatingEdge` predicate.

Swift
"""""

*   The predicates :code:`immediatelyControls` and :code:`controls` on the :code:`ConditionBlock` class have been deprecated in favor of the newly added :code:`dominatingEdge` predicate.

New Features
~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   The "Unpinned tag for a non-immutable Action in workflow" query (:code:`actions/unpinned-tag`) now supports expanding the trusted action owner list using data extensions (:code:`extensible: trustedActionsOwnerDataModel`). If you trust an Action publisher, you can include the owner name/organization in a model pack to add it to the allow list for this query. This addition will prevent security alerts when using unpinned tags for Actions published by that owner. For more information on creating a model pack, see `Creating a CodeQL Model Pack <https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack>`__.
