.. _codeql-cli-2.14.1:

==========================
CodeQL 2.14.1 (2023-07-27)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.14.1 runs a total of 392 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 127 queries (covering 33 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/uninitialized-local` query now excludes uninitialized uses that are explicitly cast to void and are expression statements. As a result, the query will report less false positives.

Java/Kotlin
"""""""""""

*   The query "Unsafe resource fetching in Android WebView" (:code:`java/android/unsafe-android-webview-fetch`) now recognizes WebViews where :code:`setJavascriptEnabled`, :code:`setAllowFileAccess`, :code:`setAllowUniversalAccessFromFileURLs`, and/or :code:`setAllowFileAccessFromFileURLs` are set inside the function block of the Kotlin :code:`apply` function.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`fs/promises` package is now recognised as an alias for :code:`require('fs').promises`.
*   The :code:`js/path-injection` query can now track taint through calls to :code:`path.join()` with a spread argument, such as :code:`path.join(baseDir, ...args)`.

Python
""""""

*   Fixed modeling of :code:`aiohttp.ClientSession` so we properly handle :code:`async with` uses. This can impact results of server-side request forgery queries (:code:`py/full-ssrf`, :code:`py/partial-ssrf`).

Ruby
""""

*   Improved resolution of calls performed on an object created with :code:`Proc.new`.

New Queries
~~~~~~~~~~~

Ruby
""""

*   Added a new experimental query, :code:`rb/xpath-injection`, to detect cases where XPath statements are constructed from user input in an unsafe manner.

Swift
"""""

*   Added new query "Regular expression injection" (:code:`swift/regex-injection`). The query finds places where user input is used to construct a regular expression without proper escaping.
*   Added new query "Inefficient regular expression" (:code:`swift/redos`). This query finds regular expressions that require exponential time to match certain inputs and may make an application vulnerable to denial-of-service attacks.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ruby
""""

*   The API graph library (:code:`codeql.ruby.ApiGraphs`) has been significantly improved, with better support for inheritance,
    and data-flow nodes can now be converted to API nodes by calling :code:`.track()` or :code:`.backtrack()` on the node.
    API graphs allow for efficient modelling of how a given value is used by the code base, or how values produced by the code base are consumed by a library. See the documentation for :code:`API::Node` for details and examples.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Data flow configurations can now include a predicate :code:`neverSkip(Node node)` in order to ensure inclusion of certain nodes in the path explanations. The predicate defaults to the end-points of the additional flow steps provided in the configuration, which means that such steps now always are visible by default in path explanations.
*   The :code:`IRGuards` library has improved handling of pointer addition and subtraction operations.

C#
""

*   Data flow configurations can now include a predicate :code:`neverSkip(Node node)` in order to ensure inclusion of certain nodes in the path explanations. The predicate defaults to the end-points of the additional flow steps provided in the configuration, which means that such steps now always are visible by default in path explanations.

Golang
""""""

*   Data flow configurations can now include a predicate :code:`neverSkip(Node node)` in order to ensure inclusion of certain nodes in the path explanations. The predicate defaults to the end-points of the additional flow steps provided in the configuration, which means that such steps now always are visible by default in path explanations.
*   Parameter nodes now exist for unused parameters as well as used parameters.
*   Add support for v4 of the `Go Micro framework <https://github.com/go-micro/go-micro>`__.
*   Support for the `Bun framework <https://bun.uptrace.dev/>`__ has been added.
*   Support for `gqlgen <https://github.com/99designs/gqlgen>`__ has been added.
*   Support for the `go-pg framework <https://github.com/go-pg/pg>`__ has been improved.

Java/Kotlin
"""""""""""

*   Data flow configurations can now include a predicate :code:`neverSkip(Node node)` in order to ensure inclusion of certain nodes in the path explanations. The predicate defaults to the end-points of the additional flow steps provided in the configuration, which means that such steps now always are visible by default in path explanations.
    
*   Added models for Apache Commons Lang3 :code:`ToStringBuilder.reflectionToString` method.
    
*   Added support for the Kotlin method :code:`apply`.
    
*   Added models for the following packages:

    *   java.io
    *   java.lang
    *   java.net
    *   java.nio.channels
    *   java.nio.file
    *   java.util.zip
    *   okhttp3
    *   org.gradle.api.file
    *   retrofit2

Python
""""""

*   Data flow configurations can now include a predicate :code:`neverSkip(Node node)` in order to ensure inclusion of certain nodes in the path explanations. The predicate defaults to the end-points of the additional flow steps provided in the configuration, which means that such steps now always are visible by default in path explanations.
*   Add support for Models as Data for Reflected XSS query
*   Parameters with a default value are now considered a :code:`DefinitionNode`. This improvement was motivated by allowing type-tracking and API graphs to follow flow from such a default value to a use by a captured variable.

Ruby
""""

*   Data flow configurations can now include a predicate :code:`neverSkip(Node node)` in order to ensure inclusion of certain nodes in the path explanations. The predicate defaults to the end-points of the additional flow steps provided in the configuration, which means that such steps now always are visible by default in path explanations.
*   The :code:`'QUERY_STRING'` field of a Rack :code:`env` parameter is now recognized as a source of remote user input.
*   Query parameters and cookies from :code:`Rack::Response` objects are recognized as potential sources of remote flow input.
*   Calls to :code:`Rack::Utils.parse_query` now propagate taint.

Swift
"""""

*   Data flow configurations can now include a predicate :code:`neverSkip(Node node)` in order to ensure inclusion of certain nodes in the path explanations. The predicate defaults to the end-points of the additional flow steps provided in the configuration, which means that such steps now always are visible by default in path explanations.
*   The regular expression library now understands mode flags specified by :code:`Regex` methods and the :code:`NSRegularExpression` initializer.
*   The regular expression library now understands mode flags specified at the beginning of a regular expression (for example :code:`(?is)`).
*   Added detail to the taint model for :code:`URL`.
*   Added new heuristics to :code:`SensitiveExprs.qll`, enhancing detection from the library.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The library :code:`semmle.code.cpp.dataflow.DataFlow` has been deprecated. Please use :code:`semmle.code.cpp.dataflow.new.DataFlow` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   The :code:`DataFlow::StateConfigSig` signature module has gained default implementations for :code:`isBarrier/2` and :code:`isAdditionalFlowStep/4`.
    Hence it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.

C#
""

*   The :code:`DataFlow::StateConfigSig` signature module has gained default implementations for :code:`isBarrier/2` and :code:`isAdditionalFlowStep/4`.
    Hence it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.

Golang
""""""

*   The :code:`DataFlow::StateConfigSig` signature module has gained default implementations for :code:`isBarrier/2` and :code:`isAdditionalFlowStep/4`.
    Hence it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.

Java/Kotlin
"""""""""""

*   The :code:`DataFlow::StateConfigSig` signature module has gained default implementations for :code:`isBarrier/2` and :code:`isAdditionalFlowStep/4`.
    Hence it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.
*   A :code:`Class.isFileClass()` predicate, to identify Kotlin file classes, has been added.

Python
""""""

*   The :code:`DataFlow::StateConfigSig` signature module has gained default implementations for :code:`isBarrier/2` and :code:`isAdditionalFlowStep/4`.
    Hence it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.

Ruby
""""

*   The :code:`DataFlow::StateConfigSig` signature module has gained default implementations for :code:`isBarrier/2` and :code:`isAdditionalFlowStep/4`.
    Hence it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.

Swift
"""""

*   The :code:`DataFlow::StateConfigSig` signature module has gained default implementations for :code:`isBarrier/2` and :code:`isAdditionalFlowStep/4`.
    Hence it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.

Shared Libraries
----------------

Deprecated APIs
~~~~~~~~~~~~~~~

Utility Classes
"""""""""""""""

*   The :code:`InlineExpectationsTest` class has been deprecated. Use :code:`TestSig` and :code:`MakeTest` instead.
