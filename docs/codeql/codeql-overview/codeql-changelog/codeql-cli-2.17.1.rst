.. _codeql-cli-2.17.1:

==========================
CodeQL 2.17.1 (2024-04-24)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.17.1 runs a total of 412 security queries when configured with the Default suite (covering 160 CWE). The Extended suite enables an additional 130 queries (covering 34 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   The :code:`--mode` option and :code:`-m` alias to :code:`codeql database create`,
    :code:`codeql database cleanup`, and :code:`codeql dataset cleanup` has been deprecated. Instead, use the new :code:`--cache-cleanup` option, which has identical behavior.

Improvements
~~~~~~~~~~~~

*   Improved the diagnostic message produced when no code is processed when creating a database. If a build mode was specified using
    :code:`--build-mode`, the message is now tailored to your build mode.

Miscellaneous
~~~~~~~~~~~~~

*   The :code:`scc` tool used by the CodeQL CLI to calculate source code baseline information has been updated to version `3.2.0 <https://github.com/boyter/scc/releases/tag/v3.2.0>`__.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`java/unknown-javadoc-parameter` now accepts :code:`@param` tags that apply to the parameters of a record.

JavaScript/TypeScript
"""""""""""""""""""""

*   :code:`API::Node#getInstance()` now includes instances of subclasses, include transitive subclasses.
    The same changes applies to uses of the :code:`Instance` token in data extensions.

New Queries
~~~~~~~~~~~

Ruby
""""

*   Added a new query, :code:`rb/insecure-mass-assignment`, for finding instances of mass assignment operations accepting arbitrary parameters from remote user input.
*   Added a new query, :code:`rb/csrf-protection-not-enabled`, to detect cases where Cross-Site Request Forgery protection is not enabled in Ruby on Rails controllers.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Extracting suppress nullable warning expressions did not work when applied directly to a method call (like :code:`System.Console.Readline()!`). This has been fixed.

Golang
""""""

*   Data flow through variables declared in statements of the form :code:`x := y.(type)` at the beginning of type switches has been fixed, which may result in more alerts.
*   Added strings.ReplaceAll, http.ParseMultipartForm sanitizers and remove path sanitizer.

Java/Kotlin
"""""""""""

*   About 6,700 summary models and 6,800 neutral summary models for the JDK that were generated using data flow have been added. This may lead to new alerts being reported.

Python
""""""

*   Improved the type-tracking capabilities (and therefore also API graphs) to allow tracking items in tuples and dictionaries.

Shared Libraries
----------------

New Features
~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The :code:`PathGraph` result of a data flow computation has been augmented with model provenance information for each of the flow steps. Any qltests that include the edges relation in their output (for example, :code:`.qlref`\ s that reference path-problem queries) will need to be have their expected output updated accordingly.

Type-flow Analysis
""""""""""""""""""

*   Initial release. Adds a library to implement type-flow analysis.
