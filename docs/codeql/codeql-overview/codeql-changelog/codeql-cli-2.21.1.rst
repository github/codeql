.. _codeql-cli-2.21.1:

==========================
CodeQL 2.21.1 (2025-04-22)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.21.1 runs a total of 452 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 136 queries (covering 35 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug in CodeQL analysis for GitHub Actions in the presence of a code scanning configuration file containing :code:`paths-ignore` exclusion patterns but not :code:`paths` inclusion patterns.
    Previously, such a configuration incorrectly led to all YAML, HTML,
    JSON, and JS source files being extracted,
    except for those filtered by :code:`paths-ignore`.
    This in turn led to performance issues on large codebases.
    Now, only workflow and Action metadata YAML files relevant to the GitHub Actions analysis will be extracted,
    except for those filtered by :code:`paths-ignore`.
    This matches the default behavior when no configuration file is provided.
    The handling of :code:`paths` inclusion patterns is unchanged:
    if provided, only those paths will be considered,
    except for those filtered by :code:`paths-ignore`.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug that would prevent extraction of :code:`tsconfig.json` files when it contained an array literal with a trailing comma.

GitHub Actions
""""""""""""""

*   Alerts produced by the query :code:`actions/missing-workflow-permissions` now include a minimal set of recommended permissions in the alert message, based on well-known actions seen within the workflow file.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ruby
""""

*   The query :code:`rb/useless-assignment-to-local` now comes with query help and has been tweaked to produce fewer false positives.
*   The query :code:`rb/uninitialized-local-variable` now only produces alerts when the variable is the receiver of a method call and should produce very few false positives. It also now comes with a help file.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Enums and :code:`System.DateTimeOffset` are now treated as *simple* types, which means that they are considered to have a sanitizing effect. This impacts many queries, among others the :code:`cs/log-forging` query.
*   The MaD models for the .NET 9 Runtime have been re-generated after a fix related to :code:`out`\ /\ :code:`ref` parameters.

JavaScript/TypeScript
"""""""""""""""""""""

*   Data passed to the `Response <https://developer.mozilla.org/en-US/docs/Web/API/Response>`__ constructor is now treated as a sink for :code:`js/reflected-xss`.
*   Slightly improved detection of DOM element references, leading to XSS results being detected in more cases.

Python
""""""

*   The :code:`py/mixed-tuple-returns` query no longer flags instances where the tuple is passed into the function as an argument, as this led to too many false positives.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The *alignment* and *format* clauses in string interpolation expressions are now extracted. That is, in :code:`$"Hello {name,align:format}"` *name*, *align* and *format* are extracted as children of the string interpolation *insert* :code:`{name,align:format}`.
*   Blazor support can now better recognize when a property being set is specified with a string literal, rather than referenced in a :code:`nameof` expression.

Golang
""""""

*   Local source models for APIs reading from databases have been added for :code:`github.com/gogf/gf/database/gdb` and :code:`github.com/uptrace/bun`.

Java/Kotlin
"""""""""""

*   Enum-typed values are now assumed to be safe by most queries. This means that queries may return fewer results where an enum value is used in a sensitive context, e.g. pasted into a query string.
*   All existing modelling and support for :code:`javax.persistence` now applies to :code:`jakarta.persistence` as well.

JavaScript/TypeScript
"""""""""""""""""""""

*   Data passed to the `NextResponse <https://nextjs.org/docs/app/api-reference/functions/next-response>`__ constructor is now treated as a sink for :code:`js/reflected-xss`.
*   Data received from `NextRequest <https://nextjs.org/docs/app/api-reference/functions/next-request>`__ and `Request <https://developer.mozilla.org/en-US/docs/Web/API/Request>`__ is now treated as a remote user input :code:`source`.
*   Added support for the :code:`make-dir` package.
*   Added support for the :code:`open` package.
*   Added taint propagation for :code:`Uint8Array`, :code:`ArrayBuffer`, :code:`SharedArrayBuffer` and :code:`TextDecoder.decode()`.
*   Improved detection of :code:`WebSocket` and :code:`SockJS` usage.
*   Added data received from :code:`WebSocket` clients as a remote flow source.
*   Added support for additional :code:`mkdirp` methods as sinks in path-injection queries.
*   Added support for additional :code:`rimraf` methods as sinks in path-injection queries.

Ruby
""""

*   Calls to :code:`super` without explict arguments now have their implicit arguments generated. For example, in :code:`def foo(x, y) { super } end` the call to :code:`super` becomes :code:`super(x, y)`.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Calling conventions explicitly specified on function declarations (:code:`__cdecl`, :code:`__stdcall`, :code:`__fastcall`, etc.)  are now represented as specifiers of those declarations.
*   A new class :code:`CallingConventionSpecifier` extending the :code:`Specifier` class was introduced, which represents explicitly specified calling conventions.

Shared Libraries
----------------

Deprecated APIs
~~~~~~~~~~~~~~~

Static Single Assignment (SSA)
""""""""""""""""""""""""""""""

*   All references to the :code:`DefinitionExt` and :code:`PhiReadNode` classes in the SSA library have been deprecated. The concept of phi-read nodes is now strictly an internal implementation detail. Their sole use-case is to improve the structure of the use-use flow relation for data flow, and this use-case remains supported by the :code:`DataFlowIntegration` module.
