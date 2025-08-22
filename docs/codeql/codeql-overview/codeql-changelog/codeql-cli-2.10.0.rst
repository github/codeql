.. _codeql-cli-2.10.0:

==========================
CodeQL 2.10.0 (2022-06-27)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.10.0 runs a total of 339 security queries when configured with the Default suite (covering 142 CWE). The Extended suite enables an additional 104 queries (covering 30 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The :code:`--format=stats` option of :code:`codeql generate log-summary` has been renamed to :code:`--format=overall`. It now produces a richer JSON object that, in addition to the previous statistics about the run (which can be found in the :code:`stats` property) also records the most expensive predicates in the evaluation run.

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The :code:`codeql resolve ml-model` command now requires one or more query specifications as command line arguments in order to determine the set of starting packs from which to initiate the resolution process. The command will locate all ML models in any qlpack that is a transitive dependency of any of the starting packs. Also, the output of the command has been expanded to include for each model the containing package's name, version, and path.
    
*   The :code:`buildMetadata` inside of compiled CodeQL packs no longer contains a :code:`creationTime` property. This was removed in order to ensure that the content of a CodeQL pack is identical when it is re-compiled.
    
*   The :code:`codeql pack download` command, when used with the :code:`--dir` option,
    now downloads requested packs in directories corresponding to their version numbers. Previously,
    :code:`codeql pack download --dir ./somewhere codeql/java-queries@0.1.2` would download the pack into the :code:`./somewhere/codeql/java-queries` directory. Now, it will download the pack into the
    :code:`./somewhere/codeql/java-queries/0.1.2` directory. This allows you to download multiple versions of the same pack using a single command.

Bug Fixes
~~~~~~~~~

*   Fixed a bug where :code:`codeql pack download`, when used with the :code:`--dir` option, would not download a pack that is in the global package cache.
    
*   Fixed a bug where some versions of a CodeQL package could not be downloaded if there are more than 100 versions of this package in the package registry.
    
*   Fixed a bug where the :code:`--also-match` option for :code:`codeql resolve files` and :code:`codeql database index-files` does not work with relative paths.
    
*   Fixed a bug that caused :code:`codeql query decompile` to ignore the
    :code:`--output` option when producing bytecode output (:code:`--kind=bytecode`),
    writing only to :code:`stdout`.

New Features
~~~~~~~~~~~~

*   You can now include diagnostic messages in the summary produced by the :code:`--print-diagnostics-summary` option of the
    :code:`codeql database interpret-results` and :code:`codeql database analyze` commands by running these commands at high verbosity levels.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Improved library modeling for the query "Request without certificate validation" (:code:`py/request-without-cert-validation`), so it now also covers :code:`httpx`, :code:`aiohttp.client`, and :code:`urllib3`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The syntax of the (source|sink|summary)model CSV format has been changed slightly for Java and C#. A new column called :code:`provenance` has been introduced, where the allowed values are :code:`manual` and :code:`generated`. The value used to indicate whether a model as been written by hand (:code:`manual`) or create by the CSV model generator (:code:`generated`).
*   All auto implemented public properties with public getters and setters on ASP.NET Core remote flow sources are now also considered to be tainted.

Java/Kotlin
"""""""""""

*   The query :code:`java/log-injection` now reports problems at the source (user-controlled data) instead of at the ultimate logging call. This was changed because user functions that wrap the ultimate logging call could result in most alerts being reported in an uninformative location.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/resource-exhaustion` query no longer treats the 3-argument version of :code:`Buffer.from` as a sink,
    since it does not allocate a new buffer.

Python
""""""

*   The query "Use of a broken or weak cryptographic algorithm" (:code:`py/weak-cryptographic-algorithm`) now reports if a cryptographic operation is potentially insecure due to use of a weak block mode.

Ruby
""""

*   The query "Use of a broken or weak cryptographic algorithm" (:code:`rb/weak-cryptographic-algorithm`) now reports if a cryptographic operation is potentially insecure due to use of a weak block mode.

New Queries
~~~~~~~~~~~

Ruby
""""

*   Added a new query, :code:`rb/improper-memoization`. The query finds cases where the parameter of a memoization method is not used in the memoization key.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`kind` query metadata was changed to :code:`diagnostic` on :code:`cs/compilation-error`, :code:`cs/compilation-message`, :code:`cs/extraction-error`, and :code:`cs/extraction-message`.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   :code:`UserType.getADeclarationEntry()` now yields all forward declarations when the user type is a :code:`class`, :code:`struct`, or :code:`union`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 4.7.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a flow step for :code:`String.valueOf` calls on tainted :code:`android.text.Editable` objects.

JavaScript/TypeScript
"""""""""""""""""""""

*   All new ECMAScript 2022 features are now supported.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new :code:`BarrierGuard` parameterized module.

C#
""

*   The :code:`BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new :code:`BarrierGuard` parameterized module.

Golang
""""""

*   The :code:`BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new :code:`BarrierGuard` parameterized module.

Java/Kotlin
"""""""""""

*   The :code:`BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new :code:`BarrierGuard` parameterized module.

Python
""""""

*   The :code:`BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new :code:`BarrierGuard` parameterized module.

Ruby
""""

*   The :code:`BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new :code:`BarrierGuard` parameterized module.
