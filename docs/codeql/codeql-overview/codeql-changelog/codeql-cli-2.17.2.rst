.. _codeql-cli-2.17.2:

==========================
CodeQL 2.17.2 (2024-05-07)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.17.2 runs a total of 413 security queries when configured with the Default suite (covering 161 CWE). The Extended suite enables an additional 130 queries (covering 34 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   When uploading a SARIF file to GitHub using :code:`codeql github upload-results`, the CodeQL CLI now waits for the file to be processed by GitHub. If any errors occurred during processing of the analysis results, the command will log these and return a non-zero exit code. To disable this behaviour, pass the
    :code:`--no-wait-for-processing` flag.
    
    By default, the command will wait for the SARIF file to be processed for a maximum of 2 minutes, however this is configurable with the
    :code:`--wait-for-processing-timeout` option.
    
*   The build tracer is no longer enabled when using the |link-code-none-build-mode-1|_
    to analyze a compiled language, thus improving performance.

Known Issues
~~~~~~~~~~~~

*   The beta support for analyzing Swift in this release and all previous releases requires :code:`g++-13` when running on Linux. Users analyzing Swift using the :code:`ubuntu-latest`, :code:`ubuntu-22.04`, or
    :code:`ubuntu-20.04` runner images for GitHub Actions should update their workflows to install :code:`g++-13`. For more information, see `the runner images announcement <https://github.com/actions/runner-images/issues/9679>`__.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Uncontrolled data used in path expression" query (:code:`cpp/path-injection`) query produces fewer near-duplicate results.
*   The "Global variable may be used before initialization" query (:code:`cpp/global-use-before-init`) no longer raises an alert on global variables that are initialized when they are declared.
*   The "Inconsistent null check of pointer" query (:code:`cpp/inconsistent-nullness-testing`) query no longer raises an alert when the guarded check is in a macro expansion.

Golang
""""""

*   The query :code:`go/incomplete-hostname-regexp` now recognizes more sources involving concatenation of string literals and also follows flow through string concatenation. This may lead to more alerts.
*   Added some more barriers to flow for :code:`go/incorrect-integer-conversion` to reduce false positives, especially around type switches.

JavaScript/TypeScript
"""""""""""""""""""""

*   The JavaScript extractor will on longer report syntax errors related to "strict mode".
    Files containing such errors are now being fully analyzed along with other sources files.
    This improves our support for source files that technically break the "strict mode" rules,
    but where a build steps transforms the code such that it ends up working at runtime.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the deprecated :code:`GlobalValueNumberingImpl.qll` implementation.

C#
""

*   Deleted the deprecated :code:`getAssemblyName` predicate from the :code:`Operator` class. Use :code:`getFunctionName` instead.
*   Deleted the deprecated :code:`LShiftOperator`, :code:`RShiftOperator`, :code:`AssignLShiftExpr`, :code:`AssignRShiftExpr`, :code:`LShiftExpr`, and :code:`RShiftExpr` aliases.
*   Deleted the deprecated :code:`getCallableDescription` predicate from the :code:`ExternalApiDataNode` class. Use :code:`hasQualifiedName` instead.

Golang
""""""

*   Deleted the deprecated :code:`CsvRemoteSource` alias. Use :code:`MaDRemoteSource` instead.

Java/Kotlin
"""""""""""

*   Deleted the deprecated :code:`AssignLShiftExpr`, :code:`AssignRShiftExpr`, :code:`AssignURShiftExpr`, :code:`LShiftExpr`, :code:`RShiftExpr`, and :code:`URShiftExpr` aliases.

JavaScript/TypeScript
"""""""""""""""""""""

*   Deleted the deprecated :code:`getInput` predicate from the :code:`CryptographicOperation` class. Use :code:`getAnInput` instead.
*   Deleted the deprecated :code:`RegExpPatterns` module from :code:`Regexp.qll`.
*   Deleted the deprecated :code:`semmle/javascript/security/BadTagFilterQuery.qll`, :code:`semmle/javascript/security/OverlyLargeRangeQuery.qll`, :code:`semmle/javascript/security/regexp/RegexpMatching.qll`, and :code:`Security/CWE-020/HostnameRegexpShared.qll` files.

Python
""""""

*   Deleted the deprecated :code:`RegExpPatterns` module from :code:`Regexp.qll`.
*   Deleted the deprecated :code:`Security/CWE-020/HostnameRegexpShared.qll` file.

Ruby
""""

*   Deleted the deprecated :code:`RegExpPatterns` module from :code:`Regexp.qll`.
*   Deleted the deprecated :code:`security/cwe-020/HostnameRegexpShared.qll` file.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Source models have been added for the standard library function :code:`getc` (and variations).
*   Source, sink and flow models for the ZeroMQ (ZMQ) networking library have been added.
*   Parameters of functions without definitions now have :code:`ParameterNode`\ s.
*   The alias analysis used internally by various libraries has been improved to answer alias questions more conservatively. As a result, some queries may report fewer false positives.

C#
""

*   Generated .NET Runtime models for properties with both getters and setters have been removed as this is now handled by the data flow library.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved detection of whether a file uses CommonJS module system.

Deprecated APIs
~~~~~~~~~~~~~~~

Golang
""""""

*   To make Go consistent with other language libraries, the :code:`UntrustedFlowSource` name has been deprecated throughout. Use :code:`RemoteFlowSource` instead, which replaces it.
*   Where modules have classes named :code:`UntrustedFlowAsSource`, these are also deprecated and the :code:`Source` class in the same module or the :code:`RemoteFlowSource` class should be used instead.

Python
""""""

*   Renamed the :code:`StrConst` class to :code:`StringLiteral`, for greater consistency with other languages. The :code:`StrConst` and :code:`Str` classes are now deprecated and will be removed in a future release.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Models-as-Data support has been added for C/C++. This feature allows flow sources, sinks and summaries to be expressed in compact strings as an alternative to modelling each source / sink / summary with explicit QL. See :code:`dataflow/ExternalFlow.qll` for documentation and specification of the model format, and :code:`models/implementations/ZMQ.qll` for a simple example of models. Importing models from :code:`.yml` is not yet supported.

Shared Libraries
----------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The data flow library performs heuristic filtering of code paths that have a high degree of control-flow uncertainty for improved performance in cases that are deemed unlikely to yield true positive flow paths. This filtering can be controlled with the :code:`fieldFlowBranchLimit` predicate in configurations. Two bugs have been fixed in relation to this: Some cases of high uncertainty were not being correctly identified. This fix improves performance in certain scenarios. Another group of cases of low uncertainty were also being misidentified, which led to false negatives. Taken together, we generally expect some additional query results with more true positives and fewer false positives.

.. |link-code-none-build-mode-1| replace:: :code:`none` build mode
.. _link-code-none-build-mode-1: https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/codeql-code-scanning-for-compiled-languages#codeql-build-modes

