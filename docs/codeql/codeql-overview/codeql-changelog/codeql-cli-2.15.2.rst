.. _codeql-cli-2.15.2:

==========================
CodeQL 2.15.2 (2023-11-13)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.15.2 runs a total of 399 security queries when configured with the Default suite (covering 158 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   C++ extraction has been updated to output more accurate C++ value categories.
    This may cause unexpected alerts on databases extracted with an up-to-date CodeQL when the queries are part of a query pack that was compiled with an earlier CodeQL.
    To resolve this, please recompile the query pack with the latest CodeQL.

Bug Fixes
~~~~~~~~~

*   Fixed a bug where :code:`codeql github upload-results` would report a 403 error when attempting to upload to a GitHub Enterprise Server instance.
*   Fixed a bug in Python extraction where UTF-8 characters would cause logging to fail on systems with non-UTF-8 default system encoding (for example, Windows systems).
*   The :code:`resolve qlpacks --kind extension` command no longer resolves extensions packs from the search path. This matches the behavior of
    :code:`resolve extensions-by-pack` and will ensure that extensions which are resolved by :code:`resolve qlpacks --kind extension` can also be resolved by
    :code:`resolve extensions-by-pack`.

New Features
~~~~~~~~~~~~

*   :code:`codeql database analyze` and :code:`codeql database interpret-results` can now output human-readable analysis summaries in a new format. This format provides file coverage information and improves the way that diagnostic messages are displayed. The new format also includes a link to the tool status page when the :code:`GITHUB_SERVER_URL` and :code:`GITHUB_REPOSITORY` environment variables are set. Note that that page only exists on GitHub.com, or in GitHub Enterprise Server version 3.9.0 or later. To enable this new format, pass the :code:`--analysis-summary-v2` flag.
*   CodeQL now supports distinguishing file coverage information between related languages C and C++, Java and Kotlin,
    and JavaScript and TypeScript. By default, file coverage information for each of these pairs of languages is grouped together. To enable specific file coverage information for these languages, pass the
    :code:`--sublanguage-file-coverage` flag when initializing the database (with :code:`codeql database create` or :code:`codeql database init`) and when analyzing the database (with :code:`codeql database analyze` or :code:`codeql database interpret-results`). If you are uploading results to a GitHub instance, this flag requires GitHub.com or GitHub Enterprise Server version 3.12 or later.
*   All CLI commands now support :code:`--common-caches`, which controls the location of the cached data that is persisted between several runs of the CLI, such as downloaded QL packs and compiled query plans.

Improvements
~~~~~~~~~~~~

*   Model packs that are used in an analysis will now be included in an output SARIF results file. All model packs now include the :code:`isCodeQLModelPack: true` property in their tool component property bag.
*   The default formatting of DIL now more closely resembles equivalent QL code.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The query :code:`go/incorrect-integer-conversion` now correctly recognizes more guards of the form :code:`if val <= x` to protect a conversion :code:`uintX(val)`.

Java/Kotlin
"""""""""""

*   java/summary/lines-of-code now gives the total number of lines of Java and Kotlin code, and is the only query tagged :code:`lines-of-code`. java/summary/lines-of-code-java and java/summary/lines-of-code-kotlin give the per-language counts.
*   The query :code:`java/spring-disabled-csrf-protection` has been improved to detect more ways of disabling CSRF in Spring.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added modeling for importing :code:`express-rate-limit` using a named import.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   Fixed a bug where data flow nodes in files that are not in the project being analyzed (such as libraries) and are not contained within a function were not given an enclosing :code:`Callable`. Note that for nodes that are not contained within a function, the enclosing callable is considered to be the file itself. This may cause some minor changes to results.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`Container` and :code:`Folder` classes now derive from :code:`ElementBase` instead of :code:`Locatable`, and no longer expose the :code:`getLocation` predicate. Use :code:`getURL` instead.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   More field accesses are identified as :code:`ImplicitThisFieldAccess`.
*   Added support for new floating-point types in C23 and C++23.

Golang
""""""

*   Added `Request.Cookie <https://pkg.go.dev/net/http#Request.Cookie>`__ to reflected XSS sanitizers.

Java/Kotlin
"""""""""""

*   Java classes :code:`MethodAccess`, :code:`LValue` and :code:`RValue` were renamed to :code:`MethodCall`, :code:`VarWrite` and :code:`VarRead` respectively, along with related predicates and class names. The old names remain usable for the time being but are deprecated and should be replaced.
    
*   New class :code:`NewClassExpr` was added to represent specifically an explicit :code:`new ClassName(...)` invocation, in contrast to :code:`ClassInstanceExpr` which also includes expressions that implicitly instantiate classes, such as defining a lambda or taking a method reference.
    
*   Added up to date models related to Spring Framework 6's :code:`org.springframework.http.ResponseEntity`.
    
*   Added models for the following packages:

    *   com.alibaba.fastjson2
    *   javax.management
    *   org.apache.http.client.utils

Python
""""""

*   Added support for functions decorated with :code:`contextlib.contextmanager`.
*   Namespace packages in the form of regular packages with missing :code:`__init__.py`\ -files are now allowed. This enables the analysis to resolve modules and functions inside such packages.

Swift
"""""

*   Improved support for flow through captured variables that properly adheres to inter-procedural control flow.
*   Added children of :code:`UnspecifiedElement`, which will be present only in certain downgraded databases.
*   Collection content is now automatically read at taint flow sinks. This removes the need to define an :code:`allowImplicitRead` predicate on data flow configurations where the sink might be an array, set or similar type with tainted contents. Where that step had not been defined, taint may find additional results now.
*   Added taint models for :code:`StringProtocol.appendingFormat` and :code:`String.decodeCString`.
*   Added taint flow models for members of :code:`Substring`.
*   Added taint flow models for :code:`RawRepresentable`.
*   The contents of autoclosure function parameters are now included in the control flow graph and data flow libraries.
*   Added models of :code:`StringProtocol` and :code:`NSString` methods that evaluate regular expressions.
*   Flow through 'open existential expressions', implicit expressions created by the compiler when a method is called on a protocol. This may apply, for example, when the method is a modelled taint source.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a new class :code:`AdditionalCallTarget` for specifying additional call targets.

Shared Libraries
----------------

Bug Fixes
~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The API for debugging flow using partial flow has changed slightly. Instead of using :code:`module Partial = FlowExploration<limit/0>` and choosing between :code:`Partial::partialFlow` and :code:`Partial::partialFlowRev`, you now choose between :code:`module Partial = FlowExplorationFwd<limit/0>` and :code:`module Partial = FlowExplorationRev<limit/0>`, and then always use :code:`Partial::partialFlow`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Range Analysis
""""""""""""""

*   Initial release. Moves the range analysis library into its own qlpack.

New Features
~~~~~~~~~~~~

Utility Classes
"""""""""""""""

*   Added :code:`FilePath` API for normalizing filepaths.
