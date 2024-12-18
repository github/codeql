.. _codeql-cli-2.10.2:

==========================
CodeQL 2.10.2 (2022-08-02)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.10.2 runs a total of 341 security queries when configured with the Default suite (covering 144 CWE). The Extended suite enables an additional 104 queries (covering 30 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The option :code:`--compiler-spec` to :code:`codeql database create` (and
    :code:`codeql database trace-command`) no longer works. It is replaced by
    :code:`--extra-tracing-config`, which accepts a tracer configuration file in the new, Lua-based tracer configuration format instead. See
    :code:`tools/tracer/base.lua` for the precise API available. If you need help help porting your existing compiler specification files, please file a public issue in https://github.com/github/codeql-cli-binaries,
    or open a private ticket with GitHub support and request an escalation to engineering.

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   Versions of the CodeQL extension for Visual Studio Code released before February 2021 may not work correctly with this CLI, in particular if database upgrades are necessary. We recommend keeping your VS Code extension up-to-date.

Deprecations
~~~~~~~~~~~~

*   The experimental :code:`codeql resolve ml-models` command has been deprecated. Advanced users calling this command should use the new
    :code:`codeql resolve extensions` command instead.

New Features
~~~~~~~~~~~~

*   The :code:`codeql github upload-results` command now supports a :code:`--merge` option. If this option is provided, the command will accept the paths to multiple SARIF files, and will merge those files before uploading them as a single analysis. This option is recommended *only* for backwards compatibility with old analyses produced by the CodeQL Runner, which combined the results for multiple languages into a single analysis.

Query Packs
-----------

Breaking Changes
~~~~~~~~~~~~~~~~

Python
""""""

*   Contextual queries and the query libraries they depend on have been moved to the :code:`codeql/python-all` package.

New Queries
~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   A new query "Case-sensitive middleware path" (:code:`js/case-sensitive-middleware-path`) has been added.
    It highlights middleware routes that can be bypassed due to having a case-sensitive regular expression path.

Ruby
""""

*   Added a new experimental query, :code:`rb/manually-checking-http-verb`, to detect cases when the HTTP verb for an incoming request is checked and then used as part of control flow.
*   Added a new experimental query, :code:`rb/weak-params`, to detect cases when the rails strong parameters pattern isn't followed and values flow into persistent store writes.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Under certain circumstances a variable declaration that is not also a definition could be associated with a :code:`Variable` that did not have the definition as a :code:`VariableDeclarationEntry`. This is now fixed, and a unique :code:`Variable` will exist that has both the declaration and the definition as a :code:`VariableDeclarationEntry`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The JUnit5 version of :code:`AssertNotNull` is now recognized, which removes related false positives in the nullness queries.
*   Added data flow models for :code:`java.util.Scanner`.

Ruby
""""

*   Calls to :code:`Arel.sql` are now recognised as propagating taint from their argument.
*   Calls to :code:`ActiveRecord::Relation#annotate` are now recognized as :code:`SqlExecution`\ s so that it will be considered as a sink for queries like rb/sql-injection.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The QL predicate :code:`Expr::getUnderlyingExpr` has been added. It can be used to look through casts and not-null expressions and obtain the underlying expression to which they apply.
