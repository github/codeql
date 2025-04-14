.. _codeql-cli-2.14.0:

==========================
CodeQL 2.14.0 (2023-07-13)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.14.0 runs a total of 390 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 127 queries (covering 33 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The legacy option :code:`--search-path` will now be used, if provided, when searching for the dependencies of packages that have no lock file.
*   CodeQL query packs that specify their dependencies using the legacy
    :code:`libraryPathDependencies` property in :code:`qlpack.yml`\ /\ :code:`codeql-pack.yml` files are no longer permitted to contain a :code:`codeql-pack.lock.yml` lock file.
    This will lead to a compilation error. This change is intended to prevent confusing behavior arising from a mix of legacy (unversioned) and modern
    (versioned) package dependencies. To fix this error, either delete the lock file, or convert :code:`libraryPathDependencies` to :code:`dependencies`.
*   CodeQL CLI commands that create packages or update package lock files, such as :code:`codeql pack publish` and :code:`codeql pack create`, will no longer work on query packs that specify their dependencies using the legacy
    :code:`libraryPathDependencies` property. To fix this error, convert
    :code:`libraryPathDependencies` to :code:`dependencies`.

Bug Fixes
~~~~~~~~~

*   Fixed super calls on final base classes (or final aliases) so that they are now dispatched the same way as super calls on instanceof supertypes.
*   Fixed a bug where running :code:`codeql database finalize` with a large number of threads would fail due to running out of file descriptors.
*   Fixed a bug where :code:`codeql database create --overwrite` would not work with database clusters.
*   Fixed a bug where the CodeQL documentation coverage statistics were incorrect.
*   Fixed a bug where the generated CodeQL libarary documentation could generate invalid uris on windows.

Deprecations
~~~~~~~~~~~~

*   Missing override annotations on class member predicates now raise errors rather than warnings. This is to avoid confusion with the shadowing behaviour in the presence of final member predicates.

    ..  code-block:: ql
    
        class Foo extends Base {
          final predicate foo() { ... }
        
          predicate bar() { ... }
        }
        
        class Bar extends Foo {
          // This method shadows Foo::foo.
          predicate foo() { ... }
        
          // This used to override Foo::bar with a warning, now raises error.
          predicate bar() { ... }
        }

Improvements
~~~~~~~~~~~~

*   Unqualified imports can now be marked as deprecated to indicate that the import may be removed in the future. Usage of names only reachable through deprecated imports will generate deprecation warnings.
*   Classes declared inside a parameterized modules can final extend parameters of the module as well as types that are declared outside the parameterized module.
*   Fields are fully functional when extending types from within a module instantiation.
*   Files with a :code:`.yaml` extension will now be included in compiled CodeQL packs. Previously, files with this extension were excluded even though :code:`.yml` files were included.
*   When interpreting results (e.g., using :code:`bqrs interpret` or
    :code:`database interpret-results`), extra placeholders in alert messages are treated as normal text. Previously, results with more placeholders than placeholder values were skipped.
*   Windows users of the CodeQL extension for VS Code will see faster start times.
*   In VS Code, errors in the current file are rechecked when dependencies change.
*   In VS Code, autocomplete in large QL files is now faster.
*   Member predicates can shadow final member predicates of the same arity even when the signatures are not fully matching.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

C#
""

*   The query "Arbitrary file write during zip extraction ("Zip Slip")" (:code:`cs/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

Golang
""""""

*   The query "Arbitrary file write during zip extraction ("zip slip")" (:code:`go/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

Java/Kotlin
"""""""""""

*   The query "Arbitrary file write during archive extraction ("Zip Slip")" (:code:`java/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

JavaScript/TypeScript
"""""""""""""""""""""

*   The query "Arbitrary file write during zip extraction ("Zip Slip")" (:code:`js/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

Python
""""""

*   The query "Arbitrary file write during archive extraction ("Zip Slip")" (:code:`py/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

Ruby
""""

*   The experimental query "Arbitrary file write during zipfile/tarfile extraction" (:code:`ruby/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

Swift
"""""

*   Functions and methods modeled as flow summaries are no longer shown in the path of :code:`path-problem` queries. This results in more succinct paths for most security queries.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/comparison-with-wider-type` query now correctly handles relational operations on signed operators. As a result the query may find more results.

Java/Kotlin
"""""""""""

*   New models have been added for :code:`org.apache.commons.lang`.
*   The query :code:`java/unsafe-deserialization` has been updated to take into account :code:`SerialKiller`, a library used to prevent deserialization of arbitrary classes.

Ruby
""""

*   Fixed a bug in how :code:`map_filter` calls are analyzed. Previously, such calls would appear to the return the receiver of the call, but now the return value of the callback is properly taken into account.

New Queries
~~~~~~~~~~~

C#
""

*   Added a new query, :code:`cs/web/missing-function-level-access-control`, to find instances of missing authorization checks.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Swift
"""""

*   The :code:`BraceStmt` AST node's :code:`AstNode getElement(index)` member predicate no longer returns :code:`VarDecl`\ s after the :code:`PatternBindingDecl` that declares them. Instead, a new :code:`VarDecl getVariable(index)` predicate has been introduced for accessing the variables declared in a :code:`BraceStmt`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The data flow library now performs type strengthening. This increases precision for all data flow queries by excluding paths that can be inferred to be impossible due to incompatible types.

Java/Kotlin
"""""""""""

*   The data flow library now performs type strengthening. This increases precision for all data flow queries by excluding paths that can be inferred to be impossible due to incompatible types.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the deprecated :code:`getURL` predicate from the :code:`Container`, :code:`Folder`, and :code:`File` classes. Use the :code:`getLocation` predicate instead.

C#
""

*   Additional support for :code:`command-injection`, :code:`ldap-injection`, :code:`log-injection`, and :code:`url-redirection` sink kinds for Models as Data.

Golang
""""""

*   When a result of path query flows through a function modeled using :code:`DataFlow::FunctionModel` or :code:`TaintTracking::FunctionModel`, the path now includes nodes corresponding to the input and output to the function. This brings it in line with functions modeled using Models-as-Data.

Java/Kotlin
"""""""""""

*   Added automatically-generated dataflow models for :code:`javax.portlet`.
*   Added a missing summary model for the method :code:`java.net.URL.toString`.
*   Added automatically-generated dataflow models for the following frameworks and libraries:

    *   :code:`hudson`
    *   :code:`jenkins`
    *   :code:`net.sf.json`
    *   :code:`stapler`
    
*   Added more models for the Hudson framework.
*   Added more models for the Stapler framework.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added models for the Webix Framework.

Python
""""""

*   Deleted many models that used the old dataflow library, the new models can be found in the :code:`python/ql/lib/semmle/python/frameworks` folder.
*   More precise modeling of several container functions (such as :code:`sorted`, :code:`reversed`) and methods (such as :code:`set.add`, :code:`list.append`).
*   Added modeling of taint flow through the template argument of :code:`flask.render_template_string` and :code:`flask.stream_template_string`.
*   Deleted many deprecated predicates and classes with uppercase :code:`API`, :code:`HTTP`, :code:`XSS`, :code:`SQL`, etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`getName()` predicate from the :code:`Container` class, use :code:`getAbsolutePath()` instead.
*   Deleted many deprecated module names that started with a lowercase letter, use the versions that start with an uppercase letter instead.
*   Deleted many deprecated predicates in :code:`PointsTo.qll`.
*   Deleted many deprecated files from the :code:`semmle.python.security` package.
*   Deleted the deprecated :code:`BottleRoutePointToExtension` class from :code:`Extensions.qll`.
*   Type tracking is now aware of flow summaries. This leads to a richer API graph, and may lead to more results in some queries.

Ruby
""""

*   More kinds of rack applications are now recognized.
*   Rack::Response instances are now recognized as potential responses from rack applications.
*   HTTP redirect responses from Rack applications are now recognized as a potential sink for open redirect alerts.
*   Additional sinks for :code:`rb/unsafe-deserialization` have been added. This includes various methods from the :code:`yaml` and :code:`plist` gems, which deserialize YAML and Property List data, respectively.

Swift
"""""

*   Added a data flow model for :code:`swap(_:_:)`.

Deprecated APIs
~~~~~~~~~~~~~~~

Golang
""""""

*   The :code:`LogInjection::Configuration` taint flow configuration class has been deprecated. Use the :code:`LogInjection::Flow` module instead.

Java/Kotlin
"""""""""""

*   The :code:`ExecCallable` class in :code:`ExternalProcess.qll` has been deprecated.

Ruby
""""

*   The :code:`Configuration` taint flow configuration class from :code:`codeql.ruby.security.InsecureDownloadQuery` has been deprecated. Use the :code:`Flow` module instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   The :code:`ProductFlow::StateConfigSig` signature now includes default predicates for :code:`isBarrier1`, :code:`isBarrier2`, :code:`isAdditionalFlowStep1`, and :code:`isAdditionalFlowStep1`. Hence, it is no longer needed to provide :code:`none()` implementations of these predicates if they are not needed.

Python
""""""

*   It is now possible to specify flow summaries in the format "MyPkg;Member[list_map];Argument[1].ListElement;Argument[0].Parameter[0];value"

Swift
"""""

*   Added new libraries :code:`Regex.qll` and :code:`RegexTreeView.qll` for reasoning about regular expressions in Swift code and places where they are evaluated.
