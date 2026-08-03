.. _codeql-cli-2.26.0:

==========================
CodeQL 2.26.0 (2026-07-08)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.26.0 runs a total of 497 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   Improved the performance of commands that interact with Git repositories by checking whether the :code:`git` command-line tool is available at most once per CodeQL CLI invocation.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The query :code:`go/unhandled-writable-file-close` ("Writable file handle closed without error handling") now produces fewer false positives. A deferred call to :code:`Close` that is preceded on every execution path by a handled call to :code:`Sync` on the same file handle is no longer flagged.

Python
""""""

*   The :code:`py/modification-of-locals` query no longer flags modifications of a :code:`locals()` dictionary that has been passed out of the scope in which :code:`locals()` was called (for example, by passing it to another function or storing it in an instance attribute). In such cases the dictionary is used as an ordinary mapping and modifying it is meaningful, so these were false positives. The "modification has no effect" claim only applies within the scope that called :code:`locals()`, which is now the only case reported.

Swift
"""""

*   Fixed an issue where common usage patterns for :code:`CryptoKit` weren't being recognized as hashing sinks for the :code:`swift/weak-sensitive-data-hashing` and :code:`swift/weak-password-hashing` queries. These queries may find additional results after this change.

New Queries
~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added a new query, :code:`js/system-prompt-injection`, to detect cases where untrusted, user-provided values flow into the system prompt of an AI model, allowing an attacker to manipulate the model's behavior.
*   Added a new experimental query, :code:`javascript/ssrf-ipv6-transition-incomplete-guard`, to detect SSRF host-validation guards that reject private IPv4 ranges but fail to unwrap IPv6-transition forms (IPv4-mapped :code:`::ffff:`, NAT64 :code:`64:ff9b::`, 6to4 :code:`2002::`), allowing the guard to be bypassed by wrapping an internal IPv4 address in a transition literal.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   The name, description, and alert message of :code:`actions/untrusted-checkout/medium` have been corrected to describe a non-privileged context.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

GitHub Actions
""""""""""""""

*   GitHub Actions queries now better account for permission checks on jobs that call reusable workflows.
*   The query :code:`actions/pr-on-self-hosted-runner` was updated to the latest standard runner labels reducing false positive results.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Removed the deprecated :code:`overrideReturnsNull` predicate from :code:`Options.qll`. Use :code:`CustomOptions.overrideReturnsNull` instead.
*   Removed the deprecated :code:`returnsNull` predicate from :code:`Options.qll`. Use :code:`CustomOptions.returnsNull` instead.
*   Removed the deprecated :code:`exits` predicate from :code:`Options.qll`. Use :code:`CustomOptions.exits` instead.
*   Removed the deprecated :code:`exprExits` predicate from :code:`Options.qll`. Use :code:`CustomOptions.exprExits` instead.
*   Removed the deprecated :code:`alwaysCheckReturnValue` predicate from :code:`Options.qll`. Use :code:`CustomOptions.alwaysCheckReturnValue` instead.
*   Removed the deprecated :code:`okToIgnoreReturnValue` predicate from :code:`Options.qll`. Use :code:`CustomOptions.okToIgnoreReturnValue` instead.
*   Removed the deprecated :code:`semmle.code.cpp.Member`. Import :code:`semmle.code.cpp.Element` and/or :code:`semmle.code.cpp.Type` directly.
*   Removed the deprecated :code:`UnknownDefaultLocation` class. Use :code:`UnknownLocation` instead.
*   Removed the deprecated :code:`UnknownExprLocation` class. Use :code:`UnknownLocation` instead.
*   Removed the deprecated :code:`UnknownStmtLocation` class. Use :code:`UnknownLocation` instead.
*   Removed the deprecated :code:`TemplateParameter` class. Use :code:`TypeTemplateParameter` instead.
*   Support for class resolution across link targets has been removed for databases which were created with CodeQL versions before 1.23.0.

C#
""

*   Renamed types related to *operation* expressions. The QL classes :code:`BinaryArithmeticOperation`, :code:`BinaryBitwiseOperation`, and :code:`BinaryLogicalOperation` now include compound assignments; for example, :code:`BinaryArithmeticOperation` now includes :code:`a += b`.

Ruby
""""

*   The :code:`else` branch of a :code:`case` expression is no longer represented as a :code:`StmtSequence` directly. Instead, a new :code:`CaseElseBranch` AST node wraps the body (a :code:`StmtSequence`). :code:`CaseExpr.getElseBranch()` now returns a :code:`CaseElseBranch`, and the body of the else branch can be accessed via :code:`CaseElseBranch.getBody()`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added Razor Page handler method parameters (e.g., :code:`OnGet`, :code:`OnPost`, :code:`OnPostAsync`) as remote flow sources, enabling security queries such as :code:`cs/sql-injection` to detect vulnerabilities in :code:`PageModel` subclasses.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Improved property and indexer call target resolution for partially overridden properties and indexers.
*   Improved extraction of range-access expressions on spans and strings (for example, :code:`a[0..3]`). These expressions are now extracted as :code:`Slice` (span) or :code:`Substring` (string) calls.
*   Improved call target resolution for ref-return properties and indexers.

Golang
""""""

*   Added models for the :code:`log/slog` package (Go 1.21+). Its logging functions and
    :code:`*slog.Logger` methods (:code:`Debug`\ /\ :code:`Info`\ /\ :code:`Warn`\ /\ :code:`Error`, their :code:`Context` variants, and :code:`Log`\ /\ :code:`LogAttrs`) are now recognized as logging sinks, so the
    :code:`go/log-injection` and :code:`go/clear-text-logging` queries cover code that logs through :code:`slog`.
*   :code:`DataFlow::ResultNode`\ s are no longer created for returned expressions in functions with named result parameters. In this case there are already result nodes corresponding to :code:`IR::ReadResultInstruction`\ s at the end of the function body.
*   :code:`FuncTypeExpr.getNumResult()` now gets the number of result parameters. It previously got the number of result declarations, which is different when one result declaration declares more than one variable, as in :code:`x, y int`. All uses of it expected the number of result parameters. Its QLDoc has been updated.
*   More logging functions are now recognized as not returning or panicking.

Java/Kotlin
"""""""""""

*   Improved modeling of Apache HttpClient :code:`execute` method sinks for :code:`java/ssrf` and :code:`java/non-https-url`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added more prompt-injection sinks for the OpenAI, Anthropic, and Google GenAI SDKs: OpenAI :code:`videos.create`\ /\ :code:`edit`\ /\ :code:`extend`\ /\ :code:`remix` (Sora) prompts and :code:`beta.realtime.sessions.create` instructions, Anthropic legacy :code:`completions.create` prompts, and Google GenAI :code:`caches.create` cached contents and system instructions.
*   The OpenAI legacy :code:`completions.create` prompt is now treated as a user-prompt-injection sink instead of a system-prompt-injection sink, since the legacy :code:`/v1/completions` endpoint takes a single free-form prompt with no role separation.

Python
""""""

*   Python type tracking now follows values stored in instance attributes such as :code:`self.attr` across instance methods, including across a class hierarchy (for example, a value stored on :code:`self.attr` in a base class and read in a subclass, or vice versa). As a result, analysis is more likely to recognize user-defined objects that are stored on :code:`self` and used later in other methods, which may produce additional results.
*   Simplified the internal predicates that detect :code:`@staticmethod`, :code:`@classmethod` and :code:`@property` decorators to match the decorator's AST :code:`Name` directly, rather than going through the CFG and requiring the name to resolve globally. Code that shadows these three builtin decorators at the module-scope will now be classified by the decorator name alone; in practice, shadowing these names is extremely rare and the call-graph results are unchanged.
*   Python taint tracking is now more precise for values flowing through container contents, such as list, set, tuple, and dictionary elements. This may remove some false positive alerts.

Deprecated APIs
~~~~~~~~~~~~~~~

Golang
""""""

*   :code:`FuncTypeExpr.getResultDecl()` has been deprecated. Use :code:`FuncTypeExpr.getResultDecl(int i)` instead.

Python
""""""

*   The :code:`Function.getAReturnValueFlowNode()` predicate has been deprecated. Bind a :code:`Return` node explicitly instead — :code:`exists(Return ret | ret.getScope() = f and n.getNode() = ret.getValue())`. This is a preparatory step towards migrating the dataflow library off the legacy CFG; it has no semantic effect.
*   The :code:`AstNode.getAFlowNode()` predicate has been deprecated. Use :code:`ControlFlowNode.getNode()` from the other direction instead: replace :code:`e.getAFlowNode() = n` with :code:`n.getNode() = e`. This is a preparatory step towards migrating the dataflow library off the legacy CFG; it has no semantic effect.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Kotlin 2.4.0 can now be analysed.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added :code:`UseMemoDirective` and :code:`UseNoMemoDirective` classes to model the React compiler directives :code:`"use memo"` and :code:`"use no memo"`.
