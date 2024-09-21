.. _codeql-cli-2.12.2:

==========================
CodeQL 2.12.2 (2023-02-07)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.2 runs a total of 385 security queries when configured with the Default suite (covering 154 CWE). The Extended suite enables an additional 121 queries (covering 31 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a QL evaluator bug introduced in release 2.12.1 which could in certain rare cases lead to wrong analysis results.
    
*   Fixed handling of :code:`-Xclang <arg>` arguments passed to the :code:`clang` compiler which could cause missing extractions for C++ code bases.
    
*   Fixed a bug where the :code:`--overwrite` option was failing for database clusters.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is bundled with the CodeQL CLI has been updated to version 17.0.6.

Query Packs
-----------

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/android/sensitive-result-receiver`, to find instances of sensitive data being leaked to an untrusted :code:`ResultReceiver`.

Ruby
""""

*   Added a new query, :code:`rb/html-constructed-from-input`, to detect libraries that unsafely construct HTML from their inputs.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Add extractor and library support for UTF-8 encoded strings.
*   The :code:`StringLiteral` class includes UTF-8 encoded strings.
*   In the DB Scheme :code:`@string_literal_expr` is renamed to :code:`@utf16_string_literal_expr`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   C# 11: Added extractor support for :code:`ref` fields in :code:`ref struct` declarations.

Java/Kotlin
"""""""""""

*   Added sink models for the :code:`createQuery`, :code:`createNativeQuery`, and :code:`createSQLQuery` methods of the :code:`org.hibernate.query.QueryProducer` interface.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added sinks from the |link-code-node-pty-1|_ library to the :code:`js/code-injection` query.

Ruby
""""

*   Data flowing from the :code:`locals` argument of a Rails :code:`render` call is now tracked to uses of that data in an associated view.
*   Access to headers stored in the :code:`env` of Rack requests is now recognized as a source of remote input.
*   Ruby 3.2: anonymous rest and keyword rest arguments can now be passed as arguments, instead of just used in method parameters.

.. |link-code-node-pty-1| replace:: :code:`node-pty`\ 
.. _link-code-node-pty-1: https://www.npmjs.com/package/node-pty

