.. _codeql-cli-2.15.4:

==========================
CodeQL 2.15.4 (2023-12-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.15.4 runs a total of 401 security queries when configured with the Default suite (covering 159 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Java 21 is now fully supported, including support for new language features such as pattern switches and record patterns.

Improvements
~~~~~~~~~~~~

*   Parallelism in the evaluator has been improved, resulting in faster analysis when running with many threads, particularly for large databases.

Query Packs
-----------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/tainted-format-string-through-global` query has been deleted. This does not lead to a loss of relevant alerts, as the query duplicated a subset of the alerts from :code:`cpp/tainted-format-string`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Modelled additional flow steps to track flow from a :code:`View` call in an MVC controller to the corresponding Razor View (:code:`.cshtml`) file, which may result in additional results for queries such as :code:`cs/web/xss`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added django URLs to detected "safe" URL patterns in :code:`js/unsafe-external-link`.

Swift
"""""

*   Added additional sinks for the "Uncontrolled format string" (:code:`swift/uncontrolled-format-string`) query. Some of these sinks are heuristic (imprecise) in nature.
*   Added heuristic (imprecise) sinks for the "Database query built from user-controlled sources" (:code:`swift/sql-injection`) query.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new query, :code:`cpp/use-of-string-after-lifetime-ends`, to detect calls to :code:`c_str` on strings that will be destroyed immediately.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   A bug has been fixed that meant that value flow through a slice expression was not tracked correctly. Taint flow was tracked correctly.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The diagnostic query :code:`java/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Java files, now considers any Java file seen during extraction, even one with some errors, to be extracted / scanned.
*   Switch cases using binding patterns and :code:`case null[, default]` are now supported. Classes :code:`PatternCase` and :code:`NullDefaultCase` are introduced to represent new kinds of case statement.
*   Both switch cases and instanceof expressions using record patterns are now supported. The new class :code:`RecordPatternExpr` is introduced to represent record patterns, and :code:`InstanceOfExpr` gains :code:`getPattern` to replace :code:`getLocalVariableDeclExpr`.
*   The control-flow graph and therefore dominance information regarding switch blocks in statement context but with an expression rule (e.g. :code:`switch(...) { case 1 -> System.out.println("Hello world!") }`) has been fixed. This reduces false positives and negatives from various queries relating to functions featuring such statements.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added models for the :code:`sqlite` and :code:`better-sqlite3` npm packages.
*   TypeScript 5.3 is now supported.

Python
""""""

*   Added support for tarfile extraction filters as defined in `PEP-706 <https://peps.python.org/pep-0706>`__. In particular, calls to :code:`TarFile.extract`, and :code:`TarFile.extractall` are no longer considered to be sinks for the :code:`py/tarslip` query if a sufficiently safe filter is provided.
*   Added modeling of :code:`*args` and :code:`**kwargs` as routed-parameters in request handlers for django/flask/FastAPI/tornado.
*   Added support for type parameters in function and class definitions, as well as the new Python 3.12 type alias statement.
*   Added taint-flow modeling for regular expressions with :code:`re` module from the standard library.

Ruby
""""

*   Improved modeling for :code:`ActiveRecord`\ s :code:`update_all` method

Swift
"""""

*   Extracts Swift's :code:`DiscardStmt` and :code:`MaterizliePackExpr`
*   Expanded and improved flow models for :code:`Set` and :code:`Sequence`.
*   Added imprecise flow sources matching initializers such as :code:`init(contentsOfFile:)`.
*   Extracts :code:`MacroDecl` and some related information

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added an :code:`isPrototyped` predicate to :code:`Function` that holds when the function has a prototype.
