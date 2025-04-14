.. _codeql-cli-2.13.4:

==========================
CodeQL 2.13.4 (2023-06-19)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.13.4 runs a total of 390 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 125 queries (covering 32 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed an issue where indirect build tracing did not work in Azure DevOps pipeline jobs in Windows containers. To use indirect build tracing in such environments, ensure both the :code:`--begin-tracing` and
    :code:`--trace-process-name=CExecSvc.exe` arguments are passed to
    :code:`codeql database init`.
*   Improved the error message for the :code:`codeql pack create` command when the pack being published has a dependency with no scope in its name.

New Features
~~~~~~~~~~~~

*   Temporary files and folders created by the CodeQL CLI will now be cleaned up when each CLI command (and its internal JVM) shuts down normally.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

Python
""""""

*   The display name (:code:`@name`) of the :code:`py/unsafe-deserialization` query has been updated in favor of consistency with other languages.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`java/summary/lines-of-code` query now only counts lines of Java code. The new :code:`java/summary/lines-of-code-kotlin` counts lines of Kotlin code.

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed an issue where calls to a method named :code:`search` would lead to false positive alerts related to regular expressions.
    This happened when the call was incorrectly seen as a call to :code:`String.prototype.search`, since this function converts its first argument to a regular expression. The analysis is now more restrictive about when to treat :code:`search` calls as regular expression sinks.

Ruby
""""

*   Fixed a bug that would occur when an :code:`initialize` method returns :code:`self` or one of its parameters.
    In such cases, the corresponding calls to :code:`new` would be associated with an incorrect return type.
    This could result in inaccurate call target resolution and cause false positive alerts.
*   Fixed an issue where calls to :code:`delete` or :code:`assoc` with a constant-valued argument would be analyzed imprecisely,
    as if the argument value was not a known constant.

Swift
"""""

*   Fixed some false positive results from the :code:`swift/string-length-conflation` query, caused by imprecise sinks.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new query, :code:`cpp/overrun-write`, to detect buffer overflows in C-style functions that manipulate buffers.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Swift
"""""

*   Fixed a number of inconsistencies in the abstract syntax tree (AST) and in the control-flow graph (CFG). This may lead to more results in queries that use these libraries, or libraries that depend on them (such as dataflow).

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The extractor has been changed to run after the traced compiler call. This allows inspecting compiler generated files, such as the output of source generators. With this change, :code:`.cshtml` files and their generated :code:`.cshtml.g.cs` counterparts are extracted on dotnet 6 and above.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 5.1.

Swift
"""""

*   Incorporated the cross-language :code:`SensitiveDataHeuristics.qll` heuristics library into the Swift :code:`SensitiveExprs.qll` library. This adds a number of new heuristics enhancing detection from the library.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Deleted the deprecated :code:`hasCopyConstructor` predicate from the :code:`Class` class in :code:`Class.qll`.
*   Deleted many deprecated predicates and classes with uppercase :code:`AST`, :code:`SSA`, :code:`CFG`, :code:`API`, etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`CodeDuplication.qll` file.

C#
""

*   C#: Analysis of the :code:`dotnet test` command supplied with a :code:`dll` or :code:`exe` file as argument no longer fails due to the addition of an erroneous :code:`-p:SharedCompilation=false` argument.
*   Deleted the deprecated :code:`WebConfigXML`, :code:`ConfigurationXMLElement`, :code:`LocationXMLElement`, :code:`SystemWebXMLElement`, :code:`SystemWebServerXMLElement`, :code:`CustomErrorsXMLElement`, and :code:`HttpRuntimeXMLElement` classes from :code:`WebConfig.qll`. The non-deprecated names with PascalCased Xml suffixes should be used instead.
*   Deleted the deprecated :code:`Record` class from both :code:`Types.qll` and :code:`Type.qll`.
*   Deleted the deprecated :code:`StructuralComparisonConfiguration` class from :code:`StructuralComparison.qll`, use :code:`sameGvn` instead.
*   Deleted the deprecated :code:`isParameterOf` predicate from the :code:`ParameterNode` class.
*   Deleted the deprecated :code:`SafeExternalAPICallable`, :code:`ExternalAPIDataNode`, :code:`UntrustedDataToExternalAPIConfig`, :code:`UntrustedExternalAPIDataNode`, and :code:`ExternalAPIUsedWithUntrustedData` classes from :code:`ExternalAPIsQuery.qll`. The non-deprecated names with PascalCased Api suffixes should be used instead.
*   Updated the following C# sink kind names. Any custom data extensions that use these sink kinds will need to be updated accordingly in order to continue working.

    *   :code:`code` to :code:`code-injection`
    *   :code:`sql` to :code:`sql-injection`
    *   :code:`html` to :code:`html-injection`
    *   :code:`xss` to :code:`js-injection`
    *   :code:`remote` to :code:`file-content-store`

Java/Kotlin
"""""""""""

*   Added flow through the block arguments of :code:`kotlin.io.use` and :code:`kotlin.with`.
    
*   Added models for the following packages:

    *   com.alibaba.druid.sql
    *   com.fasterxml.jackson.databind
    *   com.jcraft.jsch
    *   io.netty.handler.ssl
    *   okhttp3
    *   org.antlr.runtime
    *   org.fusesource.leveldbjni
    *   org.influxdb
    *   org.springframework.core.io
    *   org.yaml.snakeyaml
    
*   Deleted the deprecated :code:`getRHS` predicate from the :code:`LValue` class, use :code:`getRhs` instead.
    
*   Deleted the deprecated :code:`getCFGNode` predicate from the :code:`SsaVariable` class, use :code:`getCfgNode` instead.
    
*   Deleted many deprecated predicates and classes with uppercase :code:`XML`, :code:`JSON`, :code:`URL`, :code:`API`, etc. in their names. Use the PascalCased versions instead.
    
*   Added models for the following packages:

    *   java.lang
    *   java.nio.file
    
*   Added dataflow models for the Gson deserialization library.
    
*   Added models for the following packages:

    *   okhttp3
    
*   Added more dataflow models for the Play Framework.
    
*   Modified the models related to :code:`java.nio.file.Files.copy` so that generic :code:`[Input|Output]Stream` arguments are not considered file-related sinks.
    
*   Dataflow analysis has a new flow step through constructors of transitive subtypes of :code:`java.io.InputStream` that wrap an underlying data source. Previously, the step only existed for direct subtypes of :code:`java.io.InputStream`.
    
*   Path creation sinks modeled in :code:`PathCreation.qll` have been added to the models-as-data sink kind :code:`path-injection`.
    
*   Updated the regular expression in the :code:`HostnameSanitizer` sanitizer in the :code:`semmle.code.java.security.RequestForgery` library to better detect strings prefixed with a hostname.
    
*   Changed the :code:`android-widget` Java source kind to :code:`remote`. Any custom data extensions that use the :code:`android-widget` source kind will need to be updated accordingly in order to continue working.
    
*   Updated the following Java sink kind names. Any custom data extensions will need to be updated accordingly in order to continue working.

    *   :code:`sql` to :code:`sql-injection`
    *   :code:`url-redirect` to :code:`url-redirection`
    *   :code:`xpath` to :code:`xpath-injection`
    *   :code:`ssti` to :code:`template-injection`
    *   :code:`logging` to :code:`log-injection`
    *   :code:`groovy` to :code:`groovy-injection`
    *   :code:`jexl` to :code:`jexl-injection`
    *   :code:`mvel` to :code:`mvel-injection`
    *   :code:`xslt` to :code:`xslt-injection`
    *   :code:`ldap` to :code:`ldap-injection`
    *   :code:`pending-intent-sent` to :code:`pending-intents`
    *   :code:`intent-start` to :code:`intent-redirection`
    *   :code:`set-hostname-verifier` to :code:`hostname-verification`
    *   :code:`header-splitting` to :code:`response-splitting`
    *   :code:`xss` to :code:`html-injection` and :code:`js-injection`
    *   :code:`write-file` to :code:`file-system-store`
    *   :code:`create-file` and :code:`read-file` to :code:`path-injection`
    *   :code:`open-url` and :code:`jdbc-url` to :code:`request-forgery`

JavaScript/TypeScript
"""""""""""""""""""""

*   Deleted many deprecated predicates and classes with uppercase :code:`XML`, :code:`JSON`, :code:`URL`, :code:`API`, etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`localTaintStep` predicate from :code:`DataFlow.qll`.
*   Deleted the deprecated :code:`stringStep`, and :code:`localTaintStep` predicates from :code:`TaintTracking.qll`.
*   Deleted many modules that started with a lowercase letter. Use the versions that start with an uppercase letter instead.
*   Deleted the deprecated :code:`HtmlInjectionConfiguration` and :code:`JQueryHtmlOrSelectorInjectionConfiguration` classes from :code:`DomBasedXssQuery.qll`, use :code:`Configuration` instead.
*   Deleted the deprecated :code:`DefiningIdentifier` class and the :code:`Definitions.qll` file it was in. Use :code:`SsaDefinition` instead.
*   Deleted the deprecated :code:`definitionReaches`, :code:`localDefinitionReaches`, :code:`getAPseudoDefinitionInput`, :code:`nextDefAfter`, and :code:`localDefinitionOverwrites` predicates from :code:`DefUse.qll`.
*   Updated the following JavaScript sink kind names. Any custom data extensions that use these sink kinds will need to be updated accordingly in order to continue working.

    *   :code:`command-line-injection` to :code:`command-injection`
    *   :code:`credentials[kind]` to :code:`credentials-kind`
    
*   Added a support of sub modules in :code:`node_modules`.

Ruby
""""

*   Deleted many deprecated predicates and classes with uppercase :code:`URL`, :code:`XSS`, etc. in their names. Use the PascalCased versions instead.
*   Deleted the deprecated :code:`getValueText` predicate from the :code:`Expr`, :code:`StringComponent`, and :code:`ExprCfgNode` classes. Use :code:`getConstantValue` instead.
*   Deleted the deprecated :code:`VariableReferencePattern` class, use :code:`ReferencePattern` instead.
*   Deleted all deprecated aliases in :code:`StandardLibrary.qll`, use :code:`codeql.ruby.frameworks.Core` and :code:`codeql.ruby.frameworks.Stdlib` instead.
*   Support for the :code:`sequel` gem has been added. Method calls that execute queries against a database that may be vulnerable to injection attacks will now be recognized.
*   Support for the :code:`mysql2` gem has been added. Method calls that execute queries against an MySQL database that may be vulnerable to injection attacks will now be recognized.
*   Support for the :code:`pg` gem has been added. Method calls that execute queries against a PostgreSQL database that may be vulnerable to injection attacks will now be recognized.

Swift
"""""

*   Some models for the :code:`Data` class have been generalized to :code:`DataProtocol` so that they apply more widely.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Kotlin versions up to 1.9.0 are now supported.
