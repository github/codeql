.. _codeql-cli-2.10.1:

==========================
CodeQL 2.10.1 (2022-07-19)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.10.1 runs a total of 340 security queries when configured with the Default suite (covering 143 CWE). The Extended suite enables an additional 104 queries (covering 30 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Improved error message from :code:`codeql database analyze` when a query is missing :code:`@id` or :code:`@kind` query metadata.

Query Packs
-----------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Contextual queries and the query libraries they depend on have been moved to the :code:`codeql/cpp-all` package.

C#
""

*   Contextual queries and the query libraries they depend on have been moved to the :code:`codeql/csharp-all` package.

Java/Kotlin
"""""""""""

*   Contextual queries and the query libraries they depend on have been moved to the :code:`codeql/java-all` package.

JavaScript/TypeScript
"""""""""""""""""""""

*   Contextual queries and the query libraries they depend on have been moved to the :code:`codeql/javascript-all` package.

Python
""""""

*   Contextual queries and the query libraries they depend on have been moved to the :code:`codeql/python-all` package.

Ruby
""""

*   Contextual queries and the query libraries they depend on have been moved to the :code:`codeql/ruby-all` package.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   A new query "Improper verification of intent by broadcast receiver" (:code:`java/improper-intent-verification`) has been added.
    This query finds instances of Android :code:`BroadcastReceiver`\ s that don't verify the action string of received intents when registered to receive system intents.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   :code:`AnalysedExpr::isNullCheck` and :code:`AnalysedExpr::isValidCheck` have been updated to handle variable accesses on the left-hand side of the C++ logical "and", and variable declarations in conditions.

Java/Kotlin
"""""""""""

*   Added data-flow models for :code:`java.util.Properties`. Additional results may be found where relevant data is stored in and then retrieved from a :code:`Properties` instance.
*   Added :code:`Modifier.isInline()`.
*   Removed Kotlin-specific database and QL structures for loops and :code:`break`\ /\ :code:`continue` statements. The Kotlin extractor was changed to reuse the Java structures for these constructs.
*   Added additional flow sources for uses of external storage on Android.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`chownr` library is now modeled as a sink for the :code:`js/path-injection` query.
*   Improved modeling of sensitive data sources, so common words like :code:`certain` and :code:`secretary` are no longer considered a certificate and a secret (respectively).
*   The :code:`gray-matter` library is now modeled as a sink for the :code:`js/code-injection` query.

Python
""""""

*   Improved modeling of sensitive data sources, so common words like :code:`certain` and :code:`secretary` are no longer considered a certificate and a secret (respectively).

Ruby
""""

*   Fixed a bug causing every expression in the database to be considered a system-command execution sink when calls to any of the following methods exist:

    *   The :code:`spawn`, :code:`fspawn`, :code:`popen4`, :code:`pspawn`, :code:`system`, :code:`_pspawn` methods and the backtick operator from the :code:`POSIX::spawn` gem.
    *   The :code:`execute_command`, :code:`rake`, :code:`rails_command`, and :code:`git` methods in :code:`Rails::Generation::Actions`.
    
*   Improved modeling of sensitive data sources, so common words like :code:`certain` and :code:`secretary` are no longer considered a certificate and a secret (respectively).

Deprecated APIs
~~~~~~~~~~~~~~~

Python
""""""

*   The documentation of API graphs (the :code:`API` module) has been expanded, and some of the members predicates of :code:`API::Node` have been renamed as follows:

    *   :code:`getAnImmediateUse` -> :code:`asSource`
    *   :code:`getARhs` -> :code:`asSink`
    *   :code:`getAUse` -> :code:`getAValueReachableFromSource`
    *   :code:`getAValueReachingRhs` -> :code:`getAValueReachingSink`

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added an :code:`ErrorType` class. An instance of this class will be used if an extractor is unable to extract a type, or if an up/downgrade script is unable to provide a type.
