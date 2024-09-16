.. _codeql-cli-2.13.1:

==========================
CodeQL 2.13.1 (2023-05-03)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.13.1 runs a total of 389 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 125 queries (covering 32 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug in :code:`codeql database upload-results` where the subcommand would fail with "A fatal error occurred: Invalid SARIF.", reporting an :code:`InvalidDefinitionException`. This issue occurred when the SARIF file contained certain kinds of diagnostic information.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is bundled with the CodeQL CLI has been updated to version 17.0.7.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixes an issue that would cause TypeScript extraction to hang in rare cases when extracting code containing recursive generic type aliases.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Additional sinks modelling writes to unencrypted local files have been added to :code:`ExternalLocationSink`, used by the :code:`cs/cleartext-storage` and :code:`cs/exposure-of-sensitive-information` queries.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved the call graph to better handle the case where a function is stored on a plain object and subsequently copied to a new host object via an :code:`extend` call.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   A new query :code:`cpp/double-free` has been added. The query finds possible cases of deallocating the same pointer twice. The precision of the query has been set to "medium".
*   The query :code:`cpp/use-after-free` has been modernized and assigned the precision "medium". The query finds cases of where a pointer is dereferenced after its memory has been deallocated.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The Yaml.qll library was moved into a shared library pack named :code:`codeql/yaml` to make it possible for other languages to re-use it. This change should be backwards compatible for existing JavaScript queries.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Taking a slice is now considered a sanitizer for :code:`SafeUrlFlow`.

Java/Kotlin
"""""""""""

*   Changed some models of Spring's :code:`FileCopyUtils.copy` to be path injection sinks instead of summaries.
*   Added models for the following packages:

    *   java.nio.file
    
*   Added models for `Apache HttpComponents <https://hc.apache.org/>`__ versions 4 and 5.
*   Added sanitizers that recognize line breaks to the query :code:`java/log-injection`.
*   Added new flow steps for :code:`java.util.StringJoiner`.

Python
""""""

*   Added support for querying the contents of YAML files.

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`sensitiveResultReceiver` predicate in :code:`SensitiveResultReceiverQuery.qll` has been deprecated and replaced with :code:`isSensitiveResultReceiver` in order to use the new dataflow API.

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

YAML Data Analysis
""""""""""""""""""

*   Initial release. Extracted YAML related code into a library pack to share code between languages.
