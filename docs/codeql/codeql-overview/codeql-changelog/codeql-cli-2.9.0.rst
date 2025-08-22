.. _codeql-cli-2.9.0:

=========================
CodeQL 2.9.0 (2022-04-26)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.9.0 runs a total of 325 security queries when configured with the Default suite (covering 140 CWE). The Extended suite enables an additional 102 queries (covering 29 more CWE). 13 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug that would prevent resolution of a query suite in a published CodeQL query pack that has a reference to the pack itself.
    
*   Fixed inaccurate documentation of what the :code:`--include-extension` option to :code:`codeql resolve files` and :code:`codeql database index-files` does. The actual behavior is unchanged.

New Features
~~~~~~~~~~~~

*   :code:`codeql database create` now supports the :code:`--[no-]-count-lines` option, which was previously only available with :code:`codeql database init`.
    
*   :code:`codeql resolve files` and :code:`codeql database index-files` has a new
    :code:`--also-match` option, which allows users to specify glob patterns that are applied in conjunction with the existing :code:`--include` option.

QL Language
~~~~~~~~~~~

*   This release introduces experimental support for parameterized QL modules. This language feature is still subject to change and should not be used in production yet.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/cleartext-transmission` query now recognizes additional sources, for sensitive private data such as e-mail addresses and credit card numbers.
*   The :code:`cpp/unused-local-variable` no longer ignores functions that include lambda expressions capturing trivially copyable objects.
*   The :code:`cpp/command-line-injection` query now takes into account calling contexts across string concatenations. This removes false positives due to mismatched calling contexts before and after string concatenations.
*   A new query, "Potential exposure of sensitive system data to an unauthorized control sphere" (:code:`cpp/potential-system-data-exposure`) has been added. This query is focused on exposure of information that is highly likely to be sensitive, whereas the similar query "Exposure of system data to an unauthorized control sphere" (:code:`cpp/system-data-exposure`) is focused on exposure of information on a channel that is more likely to be intercepted by an attacker.

Java/Kotlin
"""""""""""

*   Fixed "Local information disclosure in a temporary directory" (:code:`java/local-temp-file-or-directory-information-disclosure`) to resolve false-negatives when OS isn't properly used as logical guard.
*   The :code:`SwitchCase.getRuleExpression()` predicate now gets expressions for case rules with an expression on the right-hand side of the arrow belonging to both :code:`SwitchStmt` and :code:`SwitchExpr`, and the corresponding :code:`getRuleStatement()` no longer returns an :code:`ExprStmt` in either case. Previously :code:`SwitchStmt` and :code:`SwitchExpr` behaved differently in
    this respect.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved handling of custom DOM elements, potentially leading to more alerts for the XSS queries.
*   Improved taint tracking through calls to the :code:`Array.prototype.reduce` function.

New Queries
~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/resource-exhaustion` query has been added. It highlights locations where an attacker can cause a large amount of resources to be consumed.
    The query previously existed as an experimental query.

Ruby
""""

*   Added a new query, :code:`rb/insecure-dependency`. The query finds cases where Ruby gems may be downloaded over an insecure communication channel.
*   Added a new query, :code:`rb/weak-cryptographic-algorithm`. The query finds uses of cryptographic algorithms that are known to be weak, such as DES.
*   Added a new query, :code:`rb/http-tainted-format-string`. The query finds cases where data from remote user input is used in a string formatting method in a way that allows arbitrary format specifiers to be inserted.
*   Added a new query, :code:`rb/http-to-file-access`. The query finds cases where data from remote user input is written to a file.
*   Added a new query, :code:`rb/incomplete-url-substring-sanitization`. The query finds instances where a URL is incompletely sanitized due to insufficient checks.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added the :code:`security-severity` tag to several queries.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The following predicates on :code:`API::Node` have been changed so as not to include the receiver. The receiver should now only be accessed via :code:`getReceiver()`.

    *   :code:`getParameter(int i)` previously included the receiver when :code:`i = -1`
    *   :code:`getAParameter()` previously included the receiver
    *   :code:`getLastParameter()` previously included the receiver for calls with no arguments

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The recently added flow-state versions of :code:`isBarrierIn`, :code:`isBarrierOut`, :code:`isSanitizerIn`, and :code:`isSanitizerOut` in the data flow and taint tracking libraries have been removed.

C#
""

*   The recently added flow-state versions of :code:`isBarrierIn`, :code:`isBarrierOut`, :code:`isSanitizerIn`, and :code:`isSanitizerOut` in the data flow and taint tracking libraries have been removed.

Java/Kotlin
"""""""""""

*   The recently added flow-state versions of :code:`isBarrierIn`, :code:`isBarrierOut`, :code:`isSanitizerIn`, and :code:`isSanitizerOut` in the data flow and taint tracking libraries have been removed.
*   The :code:`getUrl` predicate of :code:`DeclaredRepository` in :code:`MavenPom.qll` has been renamed to :code:`getRepositoryUrl`.

Python
""""""

*   The recently added flow-state versions of :code:`isBarrierIn`, :code:`isBarrierOut`, :code:`isSanitizerIn`, and :code:`isSanitizerOut` in the data flow and taint tracking libraries have been removed.

Ruby
""""

*   The recently added flow-state versions of :code:`isBarrierIn`, :code:`isBarrierOut`, :code:`isSanitizerIn`, and :code:`isSanitizerOut` in the data flow and taint tracking libraries have been removed.
*   The :code:`getURL` member-predicates of the :code:`HTTP::Client::Request` and :code:`HTTP::Client::Request::Range` classes from :code:`Concepts.qll` have been renamed to :code:`getAUrlPart`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Added data-flow for Django ORM models that are saved in a database (no :code:`models.ForeignKey` support).

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`semmle.code.cpp.security.SensitiveExprs` library has been enhanced with some additional rules for detecting credentials.

Java/Kotlin
"""""""""""

*   Added guard precondition support for assertion methods for popular testing libraries (e.g. Junit 4, Junit 5, TestNG).

Python
""""""

*   Improved modeling of Flask :code:`Response` objects, so passing a response body with the keyword argument :code:`response` is now recognized.

Ruby
""""

*   Whereas :code:`ConstantValue::getString()` previously returned both string and regular-expression values, it now returns only string values. The same applies to :code:`ConstantValue::isString(value)`.
*   Regular-expression values can now be accessed with the new predicates :code:`ConstantValue::getRegExp()`, :code:`ConstantValue::isRegExp(value)`, and :code:`ConstantValue::isRegExpWithFlags(value, flags)`.
*   The :code:`ParseRegExp` and :code:`RegExpTreeView` modules are now "internal" modules. Users should use :code:`codeql.ruby.Regexp` instead.

Deprecated APIs
~~~~~~~~~~~~~~~

Python
""""""

*   Queries importing a data-flow configuration from :code:`semmle.python.security.dataflow` should ensure that the imported file ends with :code:`Query`, and only import its top-level module. For example, a query that used :code:`CommandInjection::Configuration` from
    :code:`semmle.python.security.dataflow.CommandInjection` should from now use :code:`Configuration` from :code:`semmle.python.security.dataflow.CommandInjectionQuery` instead.

Ruby
""""

*   :code:`ConstantValue::getStringOrSymbol` and :code:`ConstantValue::isStringOrSymbol`, which return/hold for all string-like values (strings, symbols, and regular expressions), have been renamed to :code:`ConstantValue::getStringlikeValue` and :code:`ConstantValue::isStringlikeValue`, respectively. The old names have been marked as :code:`deprecated`.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   A new library :code:`semmle.code.cpp.security.PrivateData` has been added. The new library heuristically detects variables and functions dealing with sensitive private data, such as e-mail addresses and credit card numbers.

Java/Kotlin
"""""""""""

*   There are now QL classes ErrorExpr and ErrorStmt. These may be generated by upgrade or downgrade scripts when databases cannot be fully converted.
