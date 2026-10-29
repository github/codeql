.. _codeql-cli-2.25.0:

==========================
CodeQL 2.25.0 (2026-03-19)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.25.0 runs a total of 491 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE).

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   :code:`codeql database interpret-results` and :code:`codeql database analyze` no longer attempt to reconstruct file baseline information from databases created with CLI versions before 2.11.2.

Bug Fixes
~~~~~~~~~

*   Upgraded Jackson library from 2.16.1 to 2.18.6 to address a high-severity denial of service vulnerability (GHSA-72hv-8253-57qq) in jackson-core's async JSON parser.
*   Upgraded snakeyaml (which is a dependency of jackson-dataformat-yaml) from 2.2 to 2.3.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The Java control flow graph (CFG) implementation has been completely rewritten. The CFG now includes additional nodes to more accurately represent certain constructs. This also means that any existing code that implicitly relies on very specific details about the CFG may need to be updated.
    The CFG now only includes the nodes that are reachable from the entry point.
    Additionally, the following breaking changes have been made:

    *   :code:`ControlFlowNode.asCall` has been removed - use :code:`Call.getControlFlowNode` instead.
    *   :code:`ControlFlowNode.getEnclosingStmt` has been removed.
    *   :code:`ControlFlow::ExprNode` has been removed.
    *   :code:`ControlFlow::StmtNode` has been removed.
    *   :code:`ControlFlow::Node` has been removed - this was merely an alias of
        :code:`ControlFlowNode`, which is still available.
    *   Previously deprecated predicates on :code:`BasicBlock` have been removed.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.2.4.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Inline expectations test comments, which are of the form :code:`// $ tag` or :code:`// $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.

C#
""

*   Inline expectations test comments, which are of the form :code:`// $ tag` or :code:`// $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.
*   Added :code:`System.Net.WebSockets::ReceiveAsync` as a remote flow source.
*   Added reverse taint flow from implicit conversion operator calls to their arguments.
*   Added post-update nodes for struct-type arguments, allowing data flow out of method calls via those arguments.
*   C# 14: Added support for partial constructors.

Golang
""""""

*   Inline expectations test comments, which are of the form :code:`// $ tag` or :code:`// $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.

Java/Kotlin
"""""""""""

*   Inline expectations test comments, which are of the form :code:`// $ tag` or :code:`// $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.
*   The class :code:`Assignment` now extends :code:`BinaryExpr`. Uses of :code:`BinaryExpr` may in some cases need slight adjustment.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for browser-specific source kinds (:code:`browser`, :code:`browser-url-query`, :code:`browser-url-fragment`, :code:`browser-url-path`, :code:`browser-url`, :code:`browser-window-name`, :code:`browser-message-event`) that can be used in data extensions to model sources in browser environments.
*   Inline expectations test comments, which are of the form :code:`// $ tag` or :code:`// $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.

Python
""""""

*   The call graph resolution no longer considers methods marked using |link-code-typing-overload-1|_ as valid targets. This ensures that only the method that contains the actual implementation gets resolved as a target.
*   Inline expectations test comments, which are of the form :code:`# $ tag` or :code:`# $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.

Ruby
""""

*   Inline expectations test comments, which are of the form :code:`# $ tag` or :code:`# $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.

Swift
"""""

*   Inline expectations test comments, which are of the form :code:`// $ tag` or :code:`// $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.

Rust
""""

*   Inline expectations test comments, which are of the form :code:`// $ tag` or :code:`// $ tag=value`, are now parsed more strictly and will not be recognized if there isn't a space after the :code:`$` symbol.
*   Added neutral models to inhibit spurious generated sink models for :code:`map` and :code:`from`. This fixes some false positive query results.

Shared Libraries
----------------

New Features
~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   Two new flow features :code:`FeatureEscapesSourceCallContext` and :code:`FeatureEscapesSourceCallContextOrEqualSourceSinkCallContext` have been added. The former implies that the sink must be reached from the source by escaping the source call context, that is, flow must either return from the callable containing the source or use a jump-step before reaching the sink. The latter is the disjunction of the former and the existing :code:`FeatureEqualSourceSinkCallContext` flow feature.

.. |link-code-typing-overload-1| replace:: :code:`@typing.overload`\ 
.. _link-code-typing-overload-1: https://typing.python.org/en/latest/spec/overload.html#overloads

