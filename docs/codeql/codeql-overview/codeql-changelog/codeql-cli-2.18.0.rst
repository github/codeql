.. _codeql-cli-2.18.0:

==========================
CodeQL 2.18.0 (2024-07-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.18.0 runs a total of 415 security queries when configured with the Default suite (covering 161 CWE). The Extended suite enables an additional 131 queries (covering 35 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   A number of breaking changes have been made to the C and C++ CodeQL test environment as used by :code:`codeql test run`\ :

    *   The test environment no longer defines any GNU-specific builtin macros. If these macros are still needed by a test, please define them via :code:`semmle-extractor-options`.
        
    *   The :code:`--force-recompute` option is no longer directly supported by
        :code:`semmle-extractor-options`. Instead, :code:`--edg --force-recompute` should be specified.
        
    *   The :code:`--gnu_version` and :code:`--microsoft_version` options that can be specified via :code:`semmle-extractor-options` are now synonyms, and only one should be specified as part of :code:`semmle-extractor-options`.
        Furthermore,  is also no longer possible to specify these options via the following syntax.

        *   :code:`--edg --gnu_version --edg <version number>`, and
        *   :code:`--edg --microsoft_version --edg <version number>`
        
        The shorter :code:`--gnu_version <version number>` and
        :code:`--microsoft_version <version number>` should be used.

*   The :code:`--build_error_dir` and :code:`--predefined_macros` command line options have been removed from the C/C++ extractor. It has never been possible to pass these options through the CLI, but some customers with advanced setups may have been passing them through internal undocumented interfaces.
    Passing the option :code:`--build_error_dir` did not have any effect, and it is safe to remove the option. The :code:`--predefined_macros` option should have been unnecessary, as long as the extractor was invoked with the
    :code:`--mimic` option.

Bug Fixes
~~~~~~~~~

*   Where a MacOS unsigned binary cannot be signed, CodeQL will now continue trying to trace compiler invocations created by that process and its children. In particular this means that Bazel builds on MacOS are now traceable.
*   Fixed a bug where test discovery would fail if there is a syntax error in a qlpack file. Now, a warning message will be printed and discovery will continue.

Improvements
~~~~~~~~~~~~

*   Introduced the :code:`--include-logs` option to the :code:`codeql database bundle` command. This new feature allows users to include logs in the generated database bundle, allowing for a more complete treatment of the bundle, and bringing the tool capabilities up-to-speed with the documentation.
*   :code:`codeql database init` and :code:`codeql database create` now support the
    :code:`--force-overwrite` option. When this option is specified, the command will delete the specified database directory even if it does not look like a database directory. This option is only recommended for automation. For directcommand line commands, it is recommended to use the :code:`--overwrite` option, which includes extra protection and will refuse to delete a directory that does not look like a database directory.
*   Extract :code:`.xsaccess`, :code:`*.xsjs` and :code:`*.xsjslib` files for SAP HANA XS as Javascript.
*   We have updated many compiler error messages and warnings to improve their readability and standardize their grammar.
    Where necessary, please use the :code:`--learn` option for the :code:`codeql test run` command.

Known Issues
~~~~~~~~~~~~

*   Compilation of QL queries is about 30% slower than in previous releases. This only affects users who write custom queries, and only at compilation time, not at run time. This regression will be fixed in the upcoming 2.18.1 release.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The query :code:`java/weak-cryptographic-algorithm` no longer alerts about :code:`RSA/ECB` algorithm strings.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The query :code:`java/tainted-permissions-check` now uses threat models. This means that :code:`local` sources are no longer included by default for this query, but can be added by enabling the :code:`local` threat model.
*   Added more :code:`org.apache.commons.io.FileUtils`\ -related sinks to the path injection query.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added a new experimental query, :code:`js/cors-misconfiguration`, which detects misconfigured CORS HTTP headers in the :code:`cors` and :code:`apollo` libraries.

Python
""""""

*   Adding Python support for Hardcoded Credentials as Models as Data
*   Additional sanitizers have been added to the :code:`py/full-ssrf` and :code:`py/partial-ssrf` queries for methods that verify a string contains only a certain set of characters, such as :code:`.isalnum()` as well as regular expression tests.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   Fixed dataflow via global variables other than via a direct write: for example, via a side-effect on a global, such as :code:`io.copy(SomeGlobal, ...)` or via assignment to a field or array or slice cell of a global. This means that any data-flow query may return more results where global variables are involved.

Java/Kotlin
"""""""""""

*   Support for :code:`codeql test run` for Kotlin sources has been fixed.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 5.5.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The queries "Potential double free" (:code:`cpp/double-free`) and "Potential use after free" (:code:`cpp/use-after-free`) now produce fewer false positives.
*   The "Guards" library (:code:`semmle.code.cpp.controlflow.Guards`) now also infers guards from calls to the builtin operation :code:`__builtin_expect`. As a result, some queries may produce fewer false positives.

Golang
""""""

*   DataFlow queries which previously used :code:`RemoteFlowSource` to define their sources have been modified to instead use :code:`ThreatModelFlowSource`. This means these queries will now respect threat model configurations. The default threat model configuration is equivalent to :code:`RemoteFlowSource`, so there should be no change in results for users using the default.
*   Added the :code:`ThreatModelFlowSource` class to :code:`FlowSources.qll`. The :code:`ThreatModelFlowSource` class can be used to include sources which match the current *threat model* configuration. This is the first step in supporting threat modeling for Go.

Java/Kotlin
"""""""""""

*   Added models for the following packages:

    *   io.undertow.server.handlers.resource
    *   jakarta.faces.context
    *   javax.faces.context
    *   javax.servlet
    *   org.jboss.vfs
    *   org.springframework.core.io
    
*   A bug has been fixed in the heuristic identification of uncertain control flow, which is used to filter data flow in order to improve performance and reduce false positives. This fix means that slightly more code is identified and hence pruned from data flow.
    
*   Excluded reverse DNS from the loopback address as a source of untrusted data.

JavaScript/TypeScript
"""""""""""""""""""""

*   Enabled type-tracking to follow content through array methods
*   Improved modeling of :code:`Array.prototype.splice` for when it is called with more than two arguments

Python
""""""

*   A number of Python queries now support sinks defined using data extensions. The format of data extensions for Python has been documented.

Ruby
""""

*   Element references with blocks, such as :code:`foo[:bar] { |x| puts x}`, are now parsed correctly.
*   The :code:`CleartextSources.qll` library, used by :code:`rb/clear-text-logging-sensitive-data` and :code:`rb/clear-text-logging-sensitive-data`, has been updated to consider heuristics for additional categories of sensitive data.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   The syntax for models-as-data rows has been extended to make it easier to select sources, sinks, and summaries that involve templated functions and classes. Additionally, the syntax has also been extended to make it easier to specify models with arbitrary levels of indirection. See :code:`dataflow/ExternalFlow.qll` for the updated documentation and specification for the model format.
*   It is now possible to extend the classes :code:`AllocationFunction` and :code:`DeallocationFunction` via data extensions. Extensions of these classes should be added to the :code:`lib/ext/allocation` and :code:`lib/ext/deallocation` directories respectively.
