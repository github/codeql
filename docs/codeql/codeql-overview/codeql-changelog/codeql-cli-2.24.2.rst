.. _codeql-cli-2.24.2:

==========================
CodeQL 2.24.2 (2026-02-20)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.24.2 runs a total of 491 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed SARIF output to generate RFC 1738 compatible file URIs. File URIs now always use the :code:`file:///` format instead of :code:`file:/` for better interoperability with SARIF consumers.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

C#
""

*   The :code:`cs/web/missing-token-validation` ("Missing cross-site request forgery token validation") query now recognizes antiforgery attributes on base controller classes, fixing false positives when :code:`[ValidateAntiForgeryToken]` or :code:`[AutoValidateAntiforgeryToken]` is applied to a parent class.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Python
""""""

*   Using :code:`=` as a fill character in a format specifier (e.g :code:`f"{x:=^20}"`) now no longer results in a syntax error during parsing.

Breaking Changes
~~~~~~~~~~~~~~~~

Golang
""""""

*   The :code:`BasicBlock` class is now defined using the shared basic blocks library. :code:`BasicBlock.getRoot` has been replaced by :code:`BasicBlock.getScope`. :code:`BasicBlock.getAPredecessor` and :code:`BasicBlock.getASuccessor` now take a :code:`SuccessorType` argument. :code:`ReachableJoinBlock.inDominanceFrontierOf` has been removed, so use :code:`BasicBlock.inDominanceFrontier` instead, swapping the receiver and the argument.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Go 1.26 is now supported.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added remote flow source models for the :code:`winhttp.h` windows header and the Azure SDK core library for C/C++.

C#
""

*   The model for :code:`System.Web.HttpUtility` has been modified to better model the flow of tainted URIs.
*   C# 14: Added support for :code:`extension` members in the extractor, QL library, data flow, and Models as Data, covering extension methods, properties, and operators.

Java/Kotlin
"""""""""""

*   Using a regular expression to check that a string doesn't contain any line breaks is already a sanitizer for :code:`java/log-injection`. Additional ways of doing the regular expression check are now recognised, including annotation with :code:`@javax.validation.constraints.Pattern`.
*   More ways of checking that a string matches a regular expression are now considered as sanitizers for various queries, including :code:`java/ssrf` and :code:`java/path-injection`. In particular, being annotated with :code:`@javax.validation.constraints.Pattern` is now recognised as a sanitizer for those queries.
*   Kotlin versions up to 2.3.10 are now supported.

Python
""""""

*   Added request forgery sink models for the Azure SDK.
*   Made it so that models-as-data sinks with the kind :code:`request-forgery` contribute to the class :code:`Http::Client::Request` which represents HTTP client requests.

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`UnreachableBlocks.qll` library has been deprecated.
*   Renamed the following predicates to increase uniformity across languages. The :code:`getBody` predicate already existed on :code:`LoopStmt`, but is now properly inherited.

    *   :code:`UnaryExpr.getExpr` to :code:`getOperand`.
    *   :code:`ConditionalExpr.getTrueExpr` to :code:`getThen`.
    *   :code:`ConditionalExpr.getFalseExpr` to :code:`getElse`.
    *   :code:`ReturnStmt.getResult` to :code:`getExpr`.
    *   :code:`WhileStmt.getStmt` to :code:`getBody`.
    *   :code:`DoStmt.getStmt` to :code:`getBody`.
    *   :code:`ForStmt.getStmt` to :code:`getBody`.
    *   :code:`EnhancedForStmt.getStmt` to :code:`getBody`.
    
