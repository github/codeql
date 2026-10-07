.. _codeql-cli-2.27.2:

==========================
CodeQL 2.27.2 (2026-10-07)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.27.2 runs a total of 498 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a crash in :code:`codeql resolve queries` (and other commands that resolve query suites) that reported a fatal internal error when a suite entry's :code:`qlpack:` or :code:`from:` value was not a valid QL pack name. Such input now produces a clear, user-facing error instead.
*   Fixed a bug in the handling of YAML data extensions that would quietly accept integers outside of the signed 64-bit range, truncating them to smaller values. (Values outside of the signed 32-bit range, but inside the signed 64-bit range, were correctly rejected.) Now, all integers outside of the signed 32-bit range are rejected and will cause evaluation to fail.

Improvements
~~~~~~~~~~~~

*   Error and warning messages printed to standard error are now labelled with an
    :code:`ERROR:`  or :code:`WARNING:`  prefix. Previously only diagnostics carried such a label, so the severity of other messages was not apparent in plain-text output. Structured output is unaffected: log files, SARIF, and stored diagnostics continue to record severity without the prefix.
*   The :code:`codeql query compile` command now accepts the :code:`--dil-constants` flag. When specified along with :code:`--dump-dil`, the emitted DIL will include the values of predicates that have been optimized into constant tuple sets. Otherwise, these constants are omitted. This flag also enables pretty-printing of constant tuple sets for higher-level commands that involve query compilation.

Miscellaneous
~~~~~~~~~~~~~

*   CLI commands that load data extensions, such as :code:`codeql database run-queries`,
    previously emitted a warning for each file-pattern from the :code:`dataExtensions` list of a :code:`qlpack.yml` manifest that failed to match any extension files.
    This check has been relaxed, and will now only emit a warning if none of the patterns match any files (i.e. when there is at least one pattern but no extensions are found).

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`cs/web/missing-x-frame-options` query now recognizes clickjacking protection configured through ASP.NET Core response headers and enforced Content Security Policy :code:`frame-ancestors` directives.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C#
""

*   Fixed an issue where types for pattern expressions were not extracted correctly.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved Hapi route handler and request input tracking through custom route registration helpers and higher-order function wrappers.

Breaking Changes
~~~~~~~~~~~~~~~~

Golang
""""""

*   The Go control flow graph (CFG) implementation has been completely rewritten to use the shared CFG library. The CFG now includes additional nodes to more accurately represent certain constructs, including assignments, function parameters and results, range statements, and deferred calls. The CFG now only includes nodes that are reachable from the entry point. Basic blocks are also now constructed directly from the shared CFG. Existing code that relies on specific CFG nodes, edges, locations, textual representations, or basic block boundaries may need to be updated.  Additionally, the following API changes have been made:

    *   :code:`BasicBlocks::Cfg` has been removed. :code:`BasicBlock` now directly uses the basic-block implementation provided by the shared CFG library.
    *   :code:`ControlFlow::EntryNode` and :code:`ControlFlow::ExitNode` have been added, and
        :code:`ControlFlow::entryNode` and :code:`ControlFlow::exitNode` now return these more specific types.
    *   :code:`IfStmt.getCond` has been deprecated. Please use the new :code:`IfStmt.getCondition` instead.
    *   The result types of :code:`IfStmt.getThen` and :code:`LoopStmt.getBody` have been widened from :code:`BlockStmt` to :code:`Stmt`.
    *   :code:`SwitchStmt.getExpr` has been added, providing a common accessor for the expression examined by expression and type switches.
    *   Several IR instruction classes have been removed or consolidated, including
        :code:`ReadArgumentInstruction`, :code:`InitResultInstruction`, :code:`IncDecInstruction`,
        :code:`EvalIncDecRhsInstruction`, :code:`EvalImplicitOneInstruction`,
        :code:`SelectInstruction`, and :code:`SendInstruction`.
    *   :code:`EvalCompoundAssignRhsInstruction` now also represents increment and decrement operations, and it and :code:`EvalImplicitInitInstruction` directly represent their associated writes.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Fixed a false positive in :code:`cs/web/xss` for ASP.NET Core Razor Pages/MVC views: :code:`WriteLiteral` calls generated for tag helper attribute values (for example, :code:`asp-for`) capture the value into an internal buffer instead of writing it directly to the response, so they are no longer treated as XSS sinks.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added SQL-injection sink models for the Comdb2 C API functions :code:`cdb2_run_statement` and :code:`cdb2_run_statement_typed`.
*   Added flow summaries for the BDE codecs :code:`BloombergLP::balber::BerDecoder`\ /\ :code:`BerEncoder`, :code:`BloombergLP::baljsn::Decoder`\ /\ :code:`Encoder` and :code:`BloombergLP::balxml::Decoder`\ /\ :code:`Encoder`.
*   Added taint flow summaries for the BDE :code:`bslx` byte-stream deserializers :code:`BloombergLP::bslx::ByteInStream`, :code:`BloombergLP::bslx::GenericInStream`, and :code:`BloombergLP::bslx::InStreamFunctions::bdexStreamIn`.

Golang
""""""

*   Models for the :code:`nhooyr.io/websocket` package have been updated to also support its new import path :code:`github.com/coder/websocket`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The Workflow SDK directives :code:`"use workflow"` and :code:`"use step"` are now recognized as known directives, so the :code:`js/unknown-directive` query no longer flags them.

GitHub Actions
""""""""""""""

*   The :code:`trustedActionsOwnerDataModel` extensible predicate, used by the :code:`actions/unpinned-tag` query, now supports removing an owner from the trusted set by adding an entry prefixed with :code:`!` (for example, :code:`!github`). This makes it possible to distrust first-party owners (:code:`actions`, :code:`github`, :code:`advanced-security`) so that unpinned tags for their Actions are reported.

Rust
""""

*   The Rust extractor has been upgraded to use :code:`rust-analyzer` version 0.0.352. As a result, the AST exposed by the Rust libraries now includes the :code:`AnyAttr` and :code:`DocComment` classes.
*   Improve data flow for async blocks when used with :code:`await`.
*   Added new flow summary models for the :code:`native-tls`, :code:`async-native-tls`, and :code:`tokio-native-tls` crates.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a C++ regular-expression parser for the ECMAScript grammar used by :code:`std::regex`.
