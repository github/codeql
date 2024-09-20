.. _codeql-cli-2.16.0:

==========================
CodeQL 2.16.0 (2024-01-16)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.16.0 runs a total of 405 security queries when configured with the Default suite (covering 160 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The Python extractor will no longer extract dependencies by default. See https://github.blog/changelog/2023-07-12-code-scanning-with-codeql-no-longer-installs-python-dependencies-automatically-for-new-users/ for more context. In versions until 2.17.0, it will be possible to restore the old behavior by setting :code:`CODEQL_EXTRACTOR_PYTHON_FORCE_ENABLE_LIBRARY_EXTRACTION_UNTIL_2_17_0=1`.
    
*   The :code:`--ram` option to :code:`codeql database run-queries` and other commands that execute queries is now interpreted more strictly.
    Previously it was mostly a rough hint for how much memory to use,
    and the actual memory footprint of the CodeQL process could be hundreds of megabytes higher. From this release, CodeQL tries harder to keep its *total* memory consumption during evaluation below the given limit.
    
    The new behavior yields more predictable memory use, but since it works by allocating less RAM, it can lead to more use of *disk*
    storage for intermediate results compared to earlier releases with the same :code:`--ram` value, and consequently a slight performance loss. In rare cases, for large databases, analysis may fail with a Java :code:`OutOfMemoryError`.
    
    The cure for this is to increase :code:`--ram` to be closer to the amount of memory actually available for CodeQL. As a rule of thumb, it will usually be possible to increase the value of :code:`--ram` by 700 MB or more, without actually using more resources than release 2.15.x would with the old setting. An exact amount cannot stated, however,
    since the actual memory footprint in earlier releases depended on factors such as the size of the databases that were not fully taken into account.
    
    If you use the CodeQL Action, you do not need to do anything unless you have manually overridden the Action's RAM setting. The Action will automatically select a :code:`--ram` setting that matches the version of the CLI it uses.

New Features
~~~~~~~~~~~~

*   Users specifying extra tracing configurations may now use the :code:`GetRegisteredMatchers(languageId)` Lua function to retrieve the existing table of matchers registered to a given language.

Improvements
~~~~~~~~~~~~

*   The :code:`Experimental` flag has been removed from all packaging and related commands.
*   The RA pretty-printer omits names of internal RA nodes and pretty-prints binary unions with nested internal unions as n-ary unions. VS Code extension v1.11.0 or newer is required to compute join order badness metrics in VS Code for the new RA format.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

Java/Kotlin
"""""""""""

*   The three queries :code:`java/insufficient-key-size`, :code:`java/server-side-template-injection`, and :code:`java/android/implicit-pendingintents` had accidentally general extension points allowing arbitrary string-based flow state. This has been fixed and the old extension points have been deprecated where possible, and otherwise updated.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/badly-bounded-write` query could report false positives when a pointer was first initialized with a literal and later assigned a dynamically allocated array. These false positives now no longer occur.

C#
""

*   Fixed a Log forging false positive when using :code:`String.Replace` to sanitize the input.
*   Fixed a URL redirection from remote source false positive when guarding a redirect with :code:`HttpRequestBase.IsUrlLocalToHost()`

Golang
""""""

*   There was a bug in the query :code:`go/incorrect-integer-conversion` which meant that upper bound checks using a strict inequality (:code:`<`) and comparing against :code:`math.MaxInt` or :code:`math.MaxUint` were not considered correctly, which led to false positives. This has now been fixed.

Java/Kotlin
"""""""""""

*   Modified the :code:`java/potentially-weak-cryptographic-algorithm` query to include the use of weak cryptographic algorithms from configuration values specified in properties files.
*   The query :code:`java/android/missing-certificate-pinning` should no longer alert about requests pointing to the local filesystem.
*   Removed some spurious sinks related to :code:`com.opensymphony.xwork2.TextProvider.getText` from the query :code:`java/ognl-injection`.

Swift
"""""

*   Added additional sinks for the "Cleartext logging of sensitive information" (:code:`swift/cleartext-logging`) query. Some of these sinks are heuristic (imprecise) in nature.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new query, :code:`cpp/use-of-unique-pointer-after-lifetime-ends`, to detect uses of the contents unique pointers that will be destroyed immediately.
*   The :code:`cpp/incorrectly-checked-scanf` query has been added. This finds results where the return value of scanf is not checked correctly. Some of these were previously found by :code:`cpp/missing-check-scanf` and will no longer be reported there.

Java/Kotlin
"""""""""""

*   Added the :code:`java/insecure-randomness` query to detect uses of weakly random values which an attacker may be able to predict. Also added the :code:`crypto-parameter` sink kind for sinks which represent the parameters and keys of cryptographic operations.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Under certain circumstances a function declaration that is not also a definition could be associated with a :code:`Function` that did not have the definition as a :code:`FunctionDeclarationEntry`. This is now fixed when only one definition exists, and a unique :code:`Function` will exist that has both the declaration and the definition as a :code:`FunctionDeclarationEntry`.

Python
""""""

*   We would previously confuse all captured variables into a single scope entry node. Now they each get their own node so they can be tracked properly.
*   The dataflow graph no longer contains SSA variables. Instead, flow is directed via the corresponding controlflow nodes. This should make the graph and the flow simpler to understand. Minor improvements in flow computation has been observed, but in general negligible changes to alerts are expected.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Added support for global data-flow through captured variables.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Changed the output of :code:`Node.toString` to better reflect how many indirections a given dataflow node has.
*   Added a new predicate :code:`Node.asDefinition` on :code:`DataFlow::Node`\ s for selecting the dataflow node corresponding to a particular definition.
*   The deprecated :code:`DefaultTaintTracking` library has been removed.
*   The :code:`Guards` library has been replaced with the API-compatible :code:`IRGuards` implementation, which has better precision in some cases.

C#
""

*   The :code:`Call::getArgumentForParameter` predicate has been reworked to add support for arguments passed to :code:`params` parameters.
*   The dataflow models for the :code:`System.Text.StringBuilder` class have been reworked. New summaries have been added for :code:`Append` and :code:`AppendLine`. With the changes, we expect queries that use taint tracking to find more results when interpolated strings or :code:`StringBuilder` instances are passed to :code:`Append` or :code:`AppendLine`.
*   Additional support for :code:`Amazon.Lambda` SDK

Golang
""""""

*   The diagnostic query :code:`go/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Go files, now considers any Go file seen during extraction, even one with some errors, to be extracted / scanned.
*   The XPath library, which is used for the XPath injection query (:code:`go/xml/xpath-injection`), now includes support for :code:`Parser` sinks from the `libxml2 <https://github.com/lestrrat-go/libxml2>`__ package.
*   :code:`CallNode::getACallee` and related predicates now recognise more callees accessed via a function variable, in particular when the callee is stored into a global variable or is captured by an anonymous function. This may lead to new alerts where data-flow into such a callee is relevant.

Java/Kotlin
"""""""""""

*   Added the :code:`Map#replace` and :code:`Map#replaceAll` methods to the :code:`MapMutator` class in :code:`semmle.code.java.Maps`.
    
*   Taint tracking now understands Kotlin's :code:`Array.get` and :code:`Array.set` methods.
    
*   Added a sink model for the :code:`createRelative` method of the :code:`org.springframework.core.io.Resource` interface.
    
*   Added source models for methods of the :code:`org.springframework.web.util.UrlPathHelper` class and removed their taint flow models.
    
*   Added models for the following packages:

    *   com.google.common.io
    *   hudson
    *   hudson.console
    *   java.lang
    *   java.net
    *   java.util.logging
    *   javax.imageio.stream
    *   org.apache.commons.io
    *   org.apache.hadoop.hive.ql.exec
    *   org.apache.hadoop.hive.ql.metadata
    *   org.apache.tools.ant.taskdefs
    
*   Added models for the following packages:

    *   com.alibaba.druid.sql.repository
    *   jakarta.persistence
    *   jakarta.persistence.criteria
    *   liquibase.database.jvm
    *   liquibase.statement.core
    *   org.apache.ibatis.mapping
    *   org.keycloak.models.map.storage

Python
""""""

*   Captured subclass relationships ahead-of-time for most popular PyPI packages so we are able to resolve subclass relationships even without having the packages installed. For example we have captured that :code:`flask_restful.Resource` is a subclass of :code:`flask.views.MethodView`, so our Flask modeling will still consider a function named :code:`post` on a :code:`class Foo(flask_restful.Resource):` as a HTTP request handler.
*   Python now makes use of the shared type tracking library, exposed as :code:`semmle.python.dataflow.new.TypeTracking`. The existing type tracking library, :code:`semmle.python.dataflow.new.TypeTracker`, has consequently been deprecated.

Ruby
""""

*   Parsing of division operators (:code:`/`) at the end of a line has been improved. Before they were wrongly interpreted as the start of a regular expression literal (:code:`/.../`) leading to syntax errors.
*   Parsing of :code:`case` statements that are formatted with the value expression on a different line than the :code:`case` keyword  has been improved and should no longer lead to syntax errors.
*   Ruby now makes use of the shared type tracking library, exposed as :code:`codeql.ruby.typetracking.TypeTracking`. The existing type tracking library, :code:`codeql.ruby.typetracking.TypeTracker`, has consequently been deprecated.

Swift
"""""

*   Expanded flow models for :code:`UnsafePointer` and similar classes.
*   Added flow models for non-member :code:`withUnsafePointer` and similar functions.
*   Added flow models for :code:`withMemoryRebound`, :code:`assumingMemoryBound` and :code:`bindMemory` member functions of library pointer classes.
*   Added a sensitive data model for :code:`SecKeyCopyExternalRepresentation`.
*   Added imprecise flow models for :code:`append` and :code:`insert` methods, and initializer calls with a :code:`data` argument.
*   Tyes for patterns are now included in the database and made available through the :code:`Pattern::getType()` method.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`isUserInput`, :code:`userInputArgument`, and :code:`userInputReturned` predicates from :code:`SecurityOptions` have been deprecated. Use :code:`FlowSource` instead.

Java/Kotlin
"""""""""""

*   Imports of the old dataflow libraries (e.g. :code:`semmle.code.java.dataflow.DataFlow2`) have been deprecated in the libraries under the :code:`semmle.code.java.security` namespace.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   :code:`UserDefineLiteral` and :code:`DeductionGuide` classes have been added, representing C++11 user defined literals and C++17 deduction guides.

Shared Libraries
----------------

Deprecated APIs
~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The old configuration-class based data flow api has been deprecated. The configuration-module based api should be used instead. For details, see https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries/.
