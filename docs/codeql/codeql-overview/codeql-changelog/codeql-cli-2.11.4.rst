.. _codeql-cli-2.11.4:

==========================
CodeQL 2.11.4 (2022-11-24)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.11.4 runs a total of 361 security queries when configured with the Default suite (covering 150 CWE). The Extended suite enables an additional 112 queries (covering 32 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   CodeQL 2.11.1 to 2.11.3 contained a bug in `indirect build tracing <https://codeql.github.com/docs/codeql-cli/creating-codeql-databases/#using-indirect-build-tracing>`__ on Windows when using :code:`codeql database init` with the |link-code-trace-process-level-1|_ flag.
    In these versions, when :code:`--trace-process-level` was set to a value greater than zero,
    (or left at the default value of 1), CodeQL attempted to inject its build tracer at a higher level in the process tree than the requested process level.
    This could lead to errors of the form "No source code found" or
    "Process tree ended before reaching required level".
    From 2.11.4 onwards, the CodeQL build tracer is injected at the requested process level.

Deprecations
~~~~~~~~~~~~

*   The :code:`--[no-]fast-compilation` option to :code:`codeql test run` is now deprecated.

New Features
~~~~~~~~~~~~

*   Kotlin support is now in beta. This means that Java analyses will also include Kotlin code by default. Kotlin support can be disabled by setting :code:`CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN` to :code:`true` in the environment.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug that would cause the extractor to crash when an :code:`import` type is used in the :code:`extends` clause of an :code:`interface`.
*   Fixed an issue with multi-line strings in YAML files being associated with an invalid location,
    causing alerts related to such strings to appear at the top of the YAML file.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for :code:`@hapi/glue` and Hapi plugins to the :code:`frameworks/Hapi.qll` library.

Ruby
""""

*   The :code:`rb/sql-injection` query now considers consider SQL constructions, such as calls to :code:`Arel.sql`, as sinks.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The query :code:`java/insufficient-key-size` has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @luchua-bc <https://github.com/github/codeql/pull/4926>`__.
*   Added a new query, :code:`java/android/sensitive-keyboard-cache`, to detect instances of sensitive information possibly being saved to the Android keyboard cache.

Ruby
""""

*   Added a new query, :code:`rb/shell-command-constructed-from-input`, to detect libraries that unsafely construct shell commands from their inputs.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 4.9.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`[Summary|Sink|Source]ModelCsv` classes have been deprecated and Models as Data models are defined as data extensions instead.

Java/Kotlin
"""""""""""

*   The ReDoS libraries in :code:`semmle.code.java.security.regexp` has been moved to a shared pack inside the :code:`shared/` folder, and the previous location has been deprecated.
*   Added data flow summaries for tainted Android intents sent to activities via :code:`Activity.startActivities`.

Python
""""""

*   The ReDoS libraries in :code:`semmle.code.python.security.regexp` have been moved to a shared pack inside the :code:`shared/` folder, and the previous location has been deprecated.

Ruby
""""

*   Data flow through the :code:`ActiveSupport` extension :code:`Enumerable#index_by` is now modeled.
*   The :code:`codeql.ruby.Concepts` library now has a :code:`SqlConstruction` class, in addition to the existing :code:`SqlExecution` class.
*   Calls to :code:`Arel.sql` are now modeled as instances of the new :code:`SqlConstruction` concept.
*   Arguments to RPC endpoints (public methods) on subclasses of :code:`ActionCable::Channel::Base` are now recognized as sources of remote user input.
*   Taint flow through the :code:`ActiveSupport` extensions :code:`Hash#reverse_merge` and :code:`Hash:reverse_merge!`, and their aliases, is now modeled more generally, where previously it was only modeled in the context of :code:`ActionController` parameters.
*   Calls to :code:`logger` in :code:`ActiveSupport` actions are now recognised as logger instances.
*   Calls to :code:`send_data` in :code:`ActiveSupport` actions are recognised as HTTP responses.
*   Calls to :code:`body_stream` in :code:`ActiveSupport` actions are recognised as HTTP request accesses.
*   The :code:`ActiveSupport` extensions :code:`Object#try` and :code:`Object#try!` are now recognised as code executions.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Kotlin support is now in beta. This means that Java analyses will also include Kotlin code by default. Kotlin support can be disabled by setting :code:`CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN` to :code:`true` in the environment.
*   The new :code:`string Compilation.getInfo(string)` predicate provides access to some information about compilations.

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Regular Expression Analysis
"""""""""""""""""""""""""""

*   Initial release. Extracted common regex related code, including the ReDoS analysis, into a library pack to share code between languages.

.. |link-code-trace-process-level-1| replace:: :code:`--trace-process-level`\ 
.. _link-code-trace-process-level-1: https://codeql.github.com/docs/codeql-cli/manual/database-init/#cmdoption-codeql-database-init-trace-process-level

