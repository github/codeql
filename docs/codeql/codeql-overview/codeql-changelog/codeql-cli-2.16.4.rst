.. _codeql-cli-2.16.4:

==========================
CodeQL 2.16.4 (2024-03-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.16.4 runs a total of 409 security queries when configured with the Default suite (covering 160 CWE). The Extended suite enables an additional 132 queries (covering 34 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   A number of internal command line options (:code:`--builtin_functions_file`, :code:`--clang_builtin_functions`,
    :code:`--disable-objc-default-synthesize-properties`, :code:`--list_builtin_functions`, :code:`--memory-limit-bytes`,
    :code:`--mimic_config`, and :code:`--objc`) has been removed from the C/C++ extractor. It has never been possible to pass these options through the CLI itself, but some customers with advanced setups may have been passing them through internal undocumented interfaces. All of the removed options were already no-ops, and will now generate errors.
    
    The :code:`--verbosity` command line option has also been removed. The option was an alias for
    :code:`--codeql-verbosity`, which should be used instead.

Bug Fixes
~~~~~~~~~

*   When parsing user-authored YAML files such as :code:`codeql-pack.yml`,
    :code:`qlpack.yml`, :code:`codeql-workspace.yml`, and any YAML file defining a data extension, unquoted string values starting with a :code:`*` character are now correctly interpreted as YAML aliases. Previously, they were interpreted as strings, but with the first character skipped.
    
    If you see a parse error similar to :code:`while scanning an alias... unexpected` :code:`character found *(42)`,it likely means that you need to add quotes around the indicated string value. The most common cause is unquoted glob patterns that start with :code:`*`, such as :code:`include: **/*.yml`, which will need to be quoted as :code:`include: "**/*.yml"`.

Improvements
~~~~~~~~~~~~

*   The frontend of the C/C++ extractor has been updated, improving the extractor's reliability and increasing its ability to extract source code.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "non-constant format string" query (:code:`cpp/non-constant-format`) has been converted to a :code:`path-problem` query.
*   The new C/C++ dataflow and taint-tracking libraries (:code:`semmle.code.cpp.dataflow.new.DataFlow` and :code:`semmle.code.cpp.dataflow.new.TaintTracking`) now implicitly assume that dataflow and taint modelled via :code:`DataFlowFunction` and :code:`TaintFunction` always fully overwrite their buffers and thus act as flow barriers. As a result, many dataflow and taint-tracking queries now produce fewer false positives. To remove this assumption and go back to the previous behavior for a given model, one can override the new :code:`isPartialWrite` predicate.

C#
""

*   Most data flow queries that track flow from *remote* flow sources now use the current *threat model* configuration instead. This doesn't lead to any changes in the produced alerts (as the default configuration is *remote* flow sources) unless the threat model configuration is changed. The changed queries are :code:`cs/code-injection`, :code:`cs/command-line-injection`, :code:`cs/user-controlled-bypass`, :code:`cs/count-untrusted-data-external-api`, :code:`cs/untrusted-data-to-external-api`, :code:`cs/ldap-injection`, :code:`cs/log-forging`, :code:`cs/xml/missing-validation`, :code:`cs/redos`, :code:`cs/regex-injection`, :code:`cs/resource-injection`, :code:`cs/sql-injection`, :code:`cs/path-injection`, :code:`cs/unsafe-deserialization-untrusted-input`, :code:`cs/web/unvalidated-url-redirection`, :code:`cs/xml/insecure-dtd-handling`, :code:`cs/xml/xpath-injection`, :code:`cs/web/xss`, and :code:`cs/uncontrolled-format-string`.

Java/Kotlin
"""""""""""

*   To reduce the number of false positives in the query "Insertion of sensitive information into log files" (:code:`java/sensitive-log`), variables with names that contain "null" (case-insensitively) are no longer considered sources of sensitive information.

Ruby
""""

*   Calls to :code:`Object#method`, :code:`Object#public_method` and :code:`Object#singleton_method` with untrusted data are now recognised as sinks for code injection.
*   Added additional request sources for Ruby on Rails.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query :code:`java/android/insecure-local-key-gen` for finding instances of keys generated for biometric authentication in an insecure way.

Python
""""""

*   The query :code:`py/nosql-injection` for finding NoSQL injection vulnerabilities is now part of the default security suite.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   Fixed dataflow out of a :code:`map` using a :code:`range` statement.

Java/Kotlin
"""""""""""

*   Fixed the Java autobuilder overriding the version of Maven used by a project when the Maven wrapper :code:`mvnw` is in use and the :code:`maven-wrapper.jar` file is not present in the repository.
*   Some flow steps related to :code:`android.text.Editable.toString` that were accidentally disabled have been re-enabled.

Swift
"""""

*   Fixed an issue where :code:`TypeDecl.getFullName` would get stuck in an loop and fail when minor database inconsistencies are present.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Improved support for flow through captured variables that properly adheres to inter-procedural control flow.
*   We no longer make use of CodeQL database stats, which may affect join-orders in custom queries. It is therefore recommended to test performance of custom queries after upgrading to this version.

Golang
""""""

*   We have significantly improved the Go autobuilder to understand a greater range of project layouts, which allows Go source files to be analysed that could previously not be processed.
*   Go 1.22 has been included in the range of supported Go versions.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added destructors for named objects to the intermediate representation.

C#
""

*   C# 12: Add QL library support (:code:`ExperimentalAttribute`) for the experimental attribute.
*   C# 12: Add extractor and QL library support for :code:`ref readonly` parameters.
*   C#: The table :code:`expr_compiler_generated` has been deleted and its content has been added to :code:`compiler_generated`.
*   Data flow via get only properties like :code:`public object Obj { get; }` is now captured by the data flow library.

Java/Kotlin
"""""""""""

*   Java expressions with erroneous types (e.g. the result of a call whose callee couldn't be resolved during extraction) are now given a CodeQL :code:`ErrorType` more often.

Python
""""""

*   Fixed missing flow for dictionary updates (:code:`d[<key>] = ...`) when :code:`<key>` is a string constant not used in dictionary literals or as name of keyword-argument.
*   Fixed flow for iterable unpacking (:code:`a,b = my_tuple`) when it occurs on top-level (module) scope.

Ruby
""""

*   Calls to :code:`I18n.translate` as well as Rails helper translate methods now propagate taint from their keyword arguments. The Rails translate methods are also recognized as XSS sanitizers when using keys marked as html safe.
*   Calls to :code:`Arel::Nodes::SqlLiteral.new` are now modeled as instances of the :code:`SqlConstruction` concept, as well as propagating taint from their argument.
*   Additional arguments beyond the first of calls to the  :code:`ActiveRecord` methods :code:`select`, :code:`reselect`, :code:`order`, :code:`reorder`, :code:`joins`, :code:`group`, and :code:`pluck` are now recognized as sql injection sinks.
*   Calls to several methods of :code:`ActiveRecord::Connection`, such as :code:`ActiveRecord::Connection#exec_query`, are now recognized as SQL executions, including those via subclasses.
