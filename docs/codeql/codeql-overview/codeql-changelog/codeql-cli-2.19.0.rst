.. _codeql-cli-2.19.0:

==========================
CodeQL 2.19.0 (2024-09-18)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.19.0 runs a total of 426 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   :code:`codeql database analyze` and :code:`codeql database interpret-results` now support the :code:`--sarif-run-property` option. You can provide this option when using a SARIF output format to add a key-value pair to the property bag of the run object.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.4.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added a new query (:code:`js/actions/actions-artifact-leak`) to detect GitHub Actions artifacts that may leak the GITHUB_TOKEN token.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Removed false positives caused by buffer accesses in unreachable code
*   Removed false positives caused by inconsistent type checking
*   Add modeling of C functions that don't throw, thereby increasing the precision of the :code:`cpp/incorrect-allocation-error-handling` ("Incorrect allocation-error handling") query. The query now produces additional true positives.

Python
""""""

*   The :code:`py/clear-text-logging-sensitive-data` and :code:`py/clear-text-storage-sensitive-data` queries have been updated to exclude the :code:`certificate` classification of sensitive sources, which often do not contain sensitive data.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   Golang vendor directories not at the root of a repository are now correctly excluded from the baseline Go file count. This means code coverage information will be more accurate.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted many deprecated taint-tracking configurations based on :code:`TaintTracking::Configuration`.
*   Deleted many deprecated dataflow configurations based on :code:`DataFlow::Configuration`.
*   Deleted the deprecated :code:`hasQualifiedName` and :code:`isDefined` predicates from the :code:`Declaration` class, use :code:`hasGlobalName` and :code:`hasDefinition` respectively instead.
*   Deleted the :code:`getFullSignature` predicate from the :code:`Function` class, use :code:`getIdentityString(Declaration)` from :code:`semmle.code.cpp.Print` instead.
*   Deleted the deprecated :code:`freeCall` predicate from :code:`Alloc.qll`. Use :code:`DeallocationExpr` instead.
*   Deleted the deprecated :code:`explorationLimit` predicate from :code:`DataFlow::Configuration`, use :code:`FlowExploration<explorationLimit>` instead.
*   Deleted the deprecated :code:`getFieldExpr` predicate from :code:`ClassAggregateLiteral`, use :code:`getAFieldExpr` instead.
*   Deleted the deprecated :code:`getElementExpr` predicate from :code:`ArrayOrVectorAggregateLiteral`, use :code:`getAnElementExpr` instead.

C#
""

*   Deleted many deprecated taint-tracking configurations based on :code:`TaintTracking::Configuration`.
*   Deleted many deprecated dataflow configurations based on :code:`DataFlow::Configuration`.
*   Deleted the deprecated :code:`explorationLimit` predicate from :code:`DataFlow::Configuration`, use :code:`FlowExploration<explorationLimit>` instead.

Golang
""""""

*   Deleted many deprecated taint-tracking configurations based on :code:`TaintTracking::Configuration`.
*   Deleted the deprecated :code:`explorationLimit` predicate from :code:`DataFlow::Configuration`, use :code:`FlowExploration<explorationLimit>` instead.

Java/Kotlin
"""""""""""

*   Deleted the deprecated :code:`ProcessBuilderConstructor`, :code:`MethodProcessBuilderCommand`, and :code:`MethodRuntimeExec` from :code:`JDK.qll`.
*   Deleted the deprecated :code:`explorationLimit` predicate from :code:`DataFlow::Configuration`, use :code:`FlowExploration<explorationLimit>` instead.
*   Deleted many deprecated taint-tracking configurations based on :code:`TaintTracking::Configuration`.
*   Deleted the deprecated :code:`getURI` predicate from :code:`CamelJavaDslToDecl` and :code:`SpringCamelXmlToElement`, use :code:`getUri` instead.
*   Deleted the deprecated :code:`ExecCallable` class from :code:`ExternalProcess.qll`.
*   Deleted many deprecated dataflow configurations based on :code:`DataFlow::Configuration`.
*   Deleted the deprecated :code:`PathCreation.qll` file.
*   Deleted the deprecated :code:`WebviewDubuggingEnabledQuery.qll` file.

JavaScript/TypeScript
"""""""""""""""""""""

*   Deleted the deprecated :code:`isHTMLElement` and :code:`getDOMName` predicates from the JSX library, use :code:`isHtmlElement` and :code:`getDomName` respectively instead.
*   Deleted the deprecated :code:`getPackageJSON` predicate from the :code:`SourceMappingComment` class, use :code:`SourceMappingComment` instead.
*   Deleted many deprecated directives from the :code:`Stmt.qll` file, use the :code:`Directive::` module instead.
*   Deleted the deprecated :code:`YAMLNode`, :code:`YAMLValue`, and :code:`YAMLScalar` classes from the YAML libraries, use :code:`YamlNode`, :code:`YamlValue`, and :code:`YamlScalar` respectively instead.
*   Deleted the deprecated :code:`getARouteHandlerExpr` predicate from :code:`Connect.qll`, use :code:`getARouteHandlerNode` instead.
*   Deleted the deprecated :code:`getGWTVersion` predicate from :code:`GWT.qll`, use :code:`getGwtVersion` instead.
*   Deleted the deprecated :code:`getOwnOptionsObject` predicate from  :code:`Vue.qll`, use :code:`getOwnOptions().getASink()` instead.

Python
""""""

*   Deleted the deprecated :code:`explorationLimit` predicate from :code:`DataFlow::Configuration`, use :code:`FlowExploration<explorationLimit>` instead.
*   Deleted the deprecated :code:`semmle.python.RegexTreeView` module, use :code:`semmle.python.regexp.RegexTreeView` instead.
*   Deleted the deprecated :code:`RegexString` class from  :code:`regex.qll`.
*   Deleted the deprecated :code:`Regex` class, use :code:`RegExp` instead.
*   Deleted the deprecated :code:`semmle/python/security/SQL.qll` file.
*   Deleted the deprecated :code:`useSSL` predicates from the LDAP libraries, use :code:`useSsl` instead.

Ruby
""""

*   Deleted the deprecated :code:`getURL` predicate the :code:`Http::Request` class, use :code:`getAUrlPart` instead.
*   Deleted the deprecated :code:`getNode` predicate from the :code:`CfgNode` class, use :code:`getAstNode` instead.
*   Deleted the deprecated :code:`explorationLimit` predicate from :code:`DataFlow::Configuration`, use :code:`FlowExploration<explorationLimit>` instead.
*   Deleted many deprecated dataflow configurations based on :code:`DataFlow::Configuration`.
*   Deleted many deprecated taint-tracking configurations based on :code:`TaintTracking::Configuration`.

Swift
"""""

*   Deleted the deprecated :code:`explorationLimit` predicate from :code:`DataFlow::Configuration`, use :code:`FlowExploration<explorationLimit>` instead.
*   Deleted the deprecated :code:`getDerivedTypeDecl` predicate from the :code:`TypeDecl` class, use :code:`getADerivedTypeDecl` or :code:`getABaseTypeDecl` instead.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   A generated (Models as Data) summary model is no longer used, if there exists a source code alternative. This primarily affects the analysis, when the analysis includes generated models for the source code being analysed.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 5.6.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added a data flow model for :code:`swap` member functions, which were previously modeled as taint tracking functions. This change improves the precision of queries where flow through :code:`swap` member functions might affect the results.
*   Added a data flow model for :code:`realloc`\ -like functions, which were previously modeled as a taint tracking functions. This change improves the precision of queries where flow through :code:`realloc`\ -like functions might affect the results.

C#
""

*   Parameters of public methods in abstract controller-like classes are now considered remote flow sources.
*   The reported location of :code:`partial` methods has been changed from the definition to the implementation part.

Golang
""""""

*   When a function or type has more than one anonymous type parameters, they were mistakenly being treated as the same type parameter. This has now been fixed.
*   Local source models for reading and parsing environment variables have been added for the following libraries:

    *   os
    *   syscall
    *   github.com/caarlos0/env
    *   github.com/gobuffalo/envy
    *   github.com/hashicorp/go-envparse
    *   github.com/joho/godotenv
    *   github.com/kelseyhightower/envconfig
    
*   Local source models have been added for the APIs which open files in the :code:`io/fs`, :code:`io/ioutil` and :code:`os` packages in the Go standard library. You can optionally include threat models as appropriate when using the CodeQL CLI and in GitHub code scanning. For more information, see `Analyzing your code with CodeQL queries <https://docs.github.com/code-security/codeql-cli/getting-started-with-the-codeql-cli/analyzing-your-code-with-codeql-queries#including-model-packs-to-add-potential-sources-of-tainted-data%3E>`__ and `Customizing your advanced setup for code scanning <https://docs.github.com/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models>`__.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a class :code:`C11GenericExpr` to represent C11 generic selection expressions. The generic selection is represented as a :code:`Conversion` on the expression that will be selected.
*   Added subclasses of :code:`BuiltInOperations` for the :code:`__is_scoped_enum`, :code:`__is_trivially_equality_comparable`, and :code:`__is_trivially_relocatable` builtin operations.
*   Added a subclass of :code:`Expr` for :code:`__datasizeof` expressions.
