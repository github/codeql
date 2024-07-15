.. _codeql-cli-2.17.4:

==========================
CodeQL 2.17.4 (2024-06-03)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.17.4 runs a total of 414 security queries when configured with the Default suite (covering 161 CWE). The Extended suite enables an additional 131 queries (covering 35 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

Query Packs
-----------

Breaking Changes
~~~~~~~~~~~~~~~~

Java
""""

*   Removed :code:`local` query variants. The results pertaining to local sources can be found using the non-local counterpart query. As an example, the results previously found by :code:`java/unvalidated-url-redirection-local` can be found by :code:`java/unvalidated-url-redirection`, if the :code:`local` threat model is enabled. The removed queries are :code:`java/path-injection-local`, :code:`java/command-line-injection-local`, :code:`java/xss-local`, :code:`java/sql-injection-local`, :code:`java/http-response-splitting-local`, :code:`java/improper-validation-of-array-construction-local`, :code:`java/improper-validation-of-array-index-local`, :code:`java/tainted-format-string-local`, :code:`java/tainted-arithmetic-local`, :code:`java/unvalidated-url-redirection-local`, :code:`java/xxe-local` and :code:`java/tainted-numeric-cast-local`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Use of unique pointer after lifetime ends" query (:code:`cpp/use-of-unique-pointer-after-lifetime-ends`) no longer reports an alert when the pointer is converted to a boolean
*   The "Variable not initialized before use" query (:code:`cpp/not-initialised`) no longer reports an alert on static variables.

Golang
""""""

*   The query :code:`go/incorrect-integer-conversion` has now been restricted to only use flow through value-preserving steps. This reduces false positives, especially around type switches.

Java
""""

*   The alert message for the query "Trust boundary violation" (:code:`java/trust-boundary-violation`) has been updated to include a link to the remote source.
*   The sanitizer of the query :code:`java/zipslip` has been improved to include nodes that are safe due to having certain safe types. This reduces false positives.

Python
""""""

*   Added models of :code:`gradio` PyPI package.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug where very large TypeScript files would cause database creation to crash. Large files over 10MB were already excluded from analysis, but the file size check was not applied to TypeScript files.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java
""""

*   Added support for data flow through side-effects on static fields. For example, when a static field containing an array is updated.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   A bug has been fixed which meant that the query :code:`go/incorrect-integer-conversion` did not consider type assertions and type switches which use a defined type whose underlying type is an integer type. This may lead to fewer false positive alerts.
*   A bug has been fixed which meant flow was not followed through some ranged for loops. This may lead to more alerts being found.
*   Added value flow models for the built-in functions :code:`append`, :code:`copy`, :code:`max` and :code:`min` using Models-as-Data. Removed the old-style models for :code:`max` and :code:`min`.

Java
""""

*   JDK version detection based on Gradle projects has been improved. Java extraction using build-modes :code:`autobuild` or :code:`none` is more likely to pick an appropriate JDK version, particularly when the Android Gradle Plugin or Spring Boot Plugin are in use.

JavaScript/TypeScript
"""""""""""""""""""""

*   Additional heuristics for a new sensitive data classification for private information (e.g. credit card numbers) have been added to the shared :code:`SensitiveDataHeuristics.qll` library. This may result in additional results for queries that use sensitive data such as :code:`js/clear-text-storage-sensitive-data` and :code:`js/clear-text-logging`.

Python
""""""

*   The :code:`request` parameter of Flask :code:`SessionInterface.open_session` method is now modeled as a remote flow source.
*   Additional heuristics for a new sensitive data classification for private information (e.g. credit card numbers) have been added to the shared :code:`SensitiveDataHeuristics.qll` library. This may result in additional results for queries that use sensitive data such as :code:`py/clear-text-storage-sensitive-data` and :code:`py/clear-text-logging-sensitive-data`.

Ruby
""""

*   Additional heuristics for a new sensitive data classification for private information (e.g. credit card numbers) have been added to the shared :code:`SensitiveDataHeuristics.qll` library. This may result in additional results for queries that use sensitive data such as :code:`rb/sensitive-get-query`.

New Features
~~~~~~~~~~~~

Python
""""""

*   A Python MaD (Models as Data) row may now contain a dotted path in the :code:`type` column. Like in Ruby, a path to a class will refer to instances of that class. This means that the summary :code:`["foo", "Member[MyClass].Instance.Member[instance_method]", "Argument[0]", "ReturnValue", "value"]` can now be written :code:`["foo.MS_Class", "Member[instance_method]", "Argument[0]", "ReturnValue", "value"]`. To refer to an actual class, one may add a :code:`!` at the end of the path.

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The data flow library now adds intermediate nodes when data flows out of a function via a parameter, in order to make path explanations easier to follow. The intermediate nodes have the same location as the underlying parameter, but must be accessed via :code:`PathNode.asParameterReturnNode` instead of :code:`PathNode.asNode`.
