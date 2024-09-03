.. _codeql-cli-2.11.0:

==========================
CodeQL 2.11.0 (2022-09-28)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.11.0 runs a total of 353 security queries when configured with the Default suite (covering 148 CWE). The Extended suite enables an additional 109 queries (covering 30 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   The CodeQL CLI now uses Python 3 to extract both Python 2 and Python 3 databases. Correspondingly, support for using Python 2 to extract Python databases is now deprecated. Starting with version 2.11.3, you will need to install Python 3 to extract Python databases.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is bundled with the CodeQL CLI has been updated to version 17.0.4.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug in the :code:`js/type-confusion-through-parameter-tampering` query that would cause it to ignore sanitizers in branching conditions. The query should now report fewer false positives.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Modernizations from "Cleartext storage of sensitive information in buffer" (:code:`cpp/cleartext-storage-buffer`) have been ported to the "Cleartext storage of sensitive information in file" (:code:`cpp/cleartext-storage-file`), "Cleartext transmission of sensitive information" (:code:`cpp/cleartext-transmission`) and "Cleartext storage of sensitive information in an SQLite database" (:code:`cpp/cleartext-storage-database`) queries. These changes may result in more correct results and fewer false positive results from these queries.
*   The alert message of many queries have been changed to make the message consistent with other languages.

C#
""

*   A new extractor option has been introduced for disabling CIL extraction. Either pass :code:`-Ocil=false` to the :code:`codeql` CLI or set the environment variable :code:`CODEQL_EXTRACTOR_CSHARP_OPTION_CIL=false`.
*   The alert message of many queries have been changed to make the message consistent with other languages.

Golang
""""""

*   The alert message of many queries have been changed to make the message consistent with other languages.

Java/Kotlin
"""""""""""

*   The Java extractor now populates the :code:`Method` relating to a :code:`MethodAccess` consistently for calls using an explicit and implicit :code:`this` qualifier. Previously if the method :code:`foo` was inherited from a specialised generic type :code:`ParentType<String>`, then an explicit call :code:`this.foo()` would yield a :code:`MethodAccess` whose :code:`getMethod()` accessor returned the bound method :code:`ParentType<String>.foo`, whereas an implicitly-qualified :code:`foo()` :code:`MethodAccess`\ 's :code:`getMethod()` would return the unbound method :code:`ParentType.foo`. Now both scenarios produce a bound method. This means that all data-flow queries may return more results where a relevant path transits a call to such an implicitly-qualified call to a member method with a bound generic type, while queries that inspect the result of :code:`MethodAccess.getMethod()` may need to tolerate bound generic methods in more circumstances. The queries :code:`java/iterator-remove-failure`, :code:`java/non-static-nested-class`, :code:`java/internal-representation-exposure`, :code:`java/subtle-inherited-call` and :code:`java/deprecated-call` have been amended to properly handle calls to bound generic methods, and in some instances may now produce more results in the explicit-\ :code:`this` case as well.
*   Added taint model for arguments of :code:`java.net.URI` constructors to the queries :code:`java/path-injection` and :code:`java/path-injection-local`.
*   Added new sinks related to Android's :code:`AlarmManager` to the query :code:`java/android/implicit-pendingintents`.
*   The alert message of many queries have been changed to make the message consistent with other languages.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved how the JavaScript parser handles ambiguities between plain JavaScript and dialects such as Flow and E4X that use the same file extension. The parser now prefers plain JavaScript if possible, falling back to dialects only if the source code can not be parsed as plain JavaScript. Previously, there were rare cases where parsing would fail because the parser would erroneously attempt to parse dialect-specific syntax in a regular JavaScript file.
*   The :code:`js/regexp/always-matches` query will no longer report an empty regular expression as always matching, as this is often the intended behavior.
*   The alert message of many queries have been changed to make the message consistent with other languages.

Python
""""""

*   The alert message of many queries have been changed to make the message consistent with other languages.

Ruby
""""

*   The :code:`rb/unsafe-deserialization` query now includes alerts for user-controlled data passed to :code:`Hash.from_trusted_xml`, since that method can deserialize YAML embedded in the XML, which in turn can result in deserialization of arbitrary objects.
*   The alert message of many queries have been changed to make the message consistent with other languages.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new medium-precision query, :code:`cpp/missing-check-scanf`, which detects :code:`scanf` output variables that are used without a proper return-value check to see that they were actually written. A variation of this query was originally contributed as an `experimental query by @ihsinme <https://github.com/github/codeql/pull/8246>`__.

Java/Kotlin
"""""""""""

*   The query "Server-side template injection" (:code:`java/server-side-template-injection`) has been promoted from experimental to the main query pack. This query was originally `submitted as an experimental query by @porcupineyhairs <https://github.com/github/codeql/pull/5935>`__.
*   Added a new query, :code:`java/android/backup-enabled`, to detect if Android applications allow backups.

Ruby
""""

*   Added a new query, :code:`rb/hardcoded-data-interpreted-as-code`, to detect cases where hardcoded data is executed as code, a technique associated with backdoors.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Added the :code:`security-severity` tag and CWE tag to the :code:`go/insecure-hostkeycallback` query.

Java/Kotlin
"""""""""""

*   Removed the :code:`@security-severity` tag from several queries not in the :code:`Security/` folder that also had missing :code:`security` tags.

Python
""""""

*   Added the :code:`security-severity` tag the :code:`py/redos`, :code:`py/polynomial-redos`, and :code:`py/regex-injection` queries.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

C#
""

*   Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

Java/Kotlin
"""""""""""

*   Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

Python
""""""

*   Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

Ruby
""""

*   Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

Breaking Changes
~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`Member.getQualifiedName()` predicate result now includes the qualified name of the declaring type.

JavaScript/TypeScript
"""""""""""""""""""""

*   Many library models have been rewritten to use dataflow nodes instead of the AST.
    The types of some classes have been changed, and these changes may break existing code.
    Other classes and predicates have been renamed, in these cases the old name is still available as a deprecated feature.
*   The basetype of the following list of classes has changed from an expression to a dataflow node, and thus code using these classes might break.
    The fix to these breakages is usually to use :code:`asExpr()` to get an expression from a dataflow node, or to use :code:`.flow()` to get a dataflow node from an expression.

    *   DOM.qll#WebStorageWrite
    *   CryptoLibraries.qll#CryptographicOperation
    *   Express.qll#Express::RequestBodyAccess
    *   HTTP.qll#HTTP::ResponseBody
    *   HTTP.qll#HTTP::CookieDefinition
    *   HTTP.qll#HTTP::ServerDefinition
    *   HTTP.qll#HTTP::RouteSetup
    *   NoSQL.qll#NoSql::Query
    *   SQL.qll#SQL::SqlString
    *   SQL.qll#SQL::SqlSanitizer
    *   HTTP.qll#ResponseBody
    *   HTTP.qll#CookieDefinition
    *   HTTP.qll#ServerDefinition
    *   HTTP.qll#RouteSetup
    *   HTTP.qll#HTTP::RedirectInvocation
    *   HTTP.qll#RedirectInvocation
    *   Express.qll#Express::RouterDefinition
    *   AngularJSCore.qll#LinkFunction
    *   Connect.qll#Connect::StandardRouteHandler
    *   CryptoLibraries.qll#CryptographicKeyCredentialsExpr
    *   AWS.qll#AWS::Credentials
    *   Azure.qll#Azure::Credentials
    *   Connect.qll#Connect::Credentials
    *   DigitalOcean.qll#DigitalOcean::Credentials
    *   Express.qll#Express::Credentials
    *   NodeJSLib.qll#NodeJSLib::Credentials
    *   PkgCloud.qll#PkgCloud::Credentials
    *   Request.qll#Request::Credentials
    *   ServiceDefinitions.qll#InjectableFunctionServiceRequest
    *   SensitiveActions.qll#SensitiveVariableAccess
    *   SensitiveActions.qll#CleartextPasswordExpr
    *   Connect.qll#Connect::ServerDefinition
    *   Restify.qll#Restify::ServerDefinition
    *   Connect.qll#Connect::RouteSetup
    *   Express.qll#Express::RouteSetup
    *   Fastify.qll#Fastify::RouteSetup
    *   Hapi.qll#Hapi::RouteSetup
    *   Koa.qll#Koa::RouteSetup
    *   Restify.qll#Restify::RouteSetup
    *   NodeJSLib.qll#NodeJSLib::RouteSetup
    *   Express.qll#Express::StandardRouteHandler
    *   Express.qll#Express::SetCookie
    *   Hapi.qll#Hapi::RouteHandler
    *   HTTP.qll#HTTP::Servers::StandardHeaderDefinition
    *   HTTP.qll#Servers::StandardHeaderDefinition
    *   Hapi.qll#Hapi::ServerDefinition
    *   Koa.qll#Koa::AppDefinition
    *   SensitiveActions.qll#SensitiveCall

Ruby
""""

*   :code:`import ruby` no longer brings the standard Ruby AST library into scope; it instead brings a module :code:`Ast` into scope, which must be imported. Alternatively, it is also possible to import :code:`codeql.ruby.AST`.
*   Changed the :code:`HTTP::Client::Request` concept from using :code:`MethodCall` as base class, to using :code:`DataFlow::Node` as base class. Any class that extends :code:`HTTP::Client::Request::Range` must be changed, but if you only use the member predicates of :code:`HTTP::Client::Request`, no changes are required.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The virtual dispatch relation used in data flow now favors summary models over source code for dispatch to interface methods from :code:`java.util` unless there is evidence that a specific source implementation is reachable. This should provide increased precision for any projects that include, for example, custom :code:`List` or :code:`Map` implementations.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 4.8.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added new sinks to the query :code:`java/android/implicit-pendingintents` to take into account the classes :code:`androidx.core.app.NotificationManagerCompat` and :code:`androidx.core.app.AlarmManagerCompat`.
*   Added new flow steps for :code:`androidx.core.app.NotificationCompat` and its inner classes.
*   Added flow sinks, sources and summaries for the Kotlin standard library.
*   Added flow summary for :code:`org.springframework.data.repository.CrudRepository.save()`.
*   Added new flow steps for the following Android classes:

    *   :code:`android.content.ContentResolver`
    *   :code:`android.content.ContentProviderClient`
    *   :code:`android.content.ContentProviderOperation`
    *   :code:`android.content.ContentProviderOperation$Builder`
    *   :code:`android.content.ContentProviderResult`
    *   :code:`android.database.Cursor`
    
*   Added taint flow models for the :code:`java.lang.String.(charAt|getBytes)` methods.
*   Improved taint flow models for the :code:`java.lang.String.(replace|replaceFirst|replaceAll)` methods. Additional results may be found where users do not properly sanitize their inputs.

JavaScript/TypeScript
"""""""""""""""""""""

*   A model for the :code:`mermaid` library has been added. XSS queries can now detect flow through the :code:`render` method of the :code:`mermaid` library.

Python
""""""

*   Changed :code:`CallNode.getArgByName` such that it has results for keyword arguments given after a dictionary unpacking argument, as the :code:`bar=2` argument in :code:`func(foo=1, **kwargs, bar=2)`.
*   :code:`getStarArg` member-predicate on :code:`Call` and :code:`CallNode` has been changed for calls that have multiple :code:`*args` arguments (for example :code:`func(42, *my_args, *other_args)`): Instead of producing no results, it will always have a result for the *first* such :code:`*args` argument.
*   Reads of global/non-local variables (without annotations) inside functions defined on classes now works properly in the case where the class had an attribute defined with the same name as the non-local variable.

Ruby
""""

*   Uses of :code:`ActionView::FileSystemResolver` are now recognized as filesystem accesses.
*   Accesses of ActiveResource models are now recognized as HTTP requests.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

C#
""

*   Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Golang
""""""

*   Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Java/Kotlin
"""""""""""

*   The predicate :code:`Annotation.getAValue()` has been deprecated because it might lead to obtaining the value of the wrong annotation element by accident. :code:`getValue(string)` (or one of the value type specific predicates) should be used to explicitly specify the name of the annotation element.
*   The predicate :code:`Annotation.getAValue(string)` has been renamed to :code:`getAnArrayValue(string)`.
*   The predicate :code:`SuppressWarningsAnnotation.getASuppressedWarningLiteral()` has been deprecated because it unnecessarily restricts the result type; :code:`getASuppressedWarning()` should be used instead.
*   The predicates :code:`TargetAnnotation.getATargetExpression()` and :code:`RetentionAnnotation.getRetentionPolicyExpression()` have been deprecated because getting the enum constant read expression is rarely useful, instead the corresponding predicates for getting the name of the referenced enum constants should be used.

JavaScript/TypeScript
"""""""""""""""""""""

*   Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Python
""""""

*   Some unused predicates in :code:`SsaDefinitions.qll`, :code:`TObject.qll`, :code:`protocols.qll`, and the :code:`pointsto/` folder have been deprecated.
*   Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Ruby
""""

*   Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added subclasses of :code:`BuiltInOperations` for :code:`__is_same`, :code:`__is_function`, :code:`__is_layout_compatible`, :code:`__is_pointer_interconvertible_base_of`, :code:`__is_array`, :code:`__array_rank`, :code:`__array_extent`, :code:`__is_arithmetic`, :code:`__is_complete_type`, :code:`__is_compound`, :code:`__is_const`, :code:`__is_floating_point`, :code:`__is_fundamental`, :code:`__is_integral`, :code:`__is_lvalue_reference`, :code:`__is_member_function_pointer`, :code:`__is_member_object_pointer`, :code:`__is_member_pointer`, :code:`__is_object`, :code:`__is_pointer`, :code:`__is_reference`, :code:`__is_rvalue_reference`, :code:`__is_scalar`, :code:`__is_signed`, :code:`__is_unsigned`, :code:`__is_void`, and :code:`__is_volatile`.

Java/Kotlin
"""""""""""

*   Added a new predicate, :code:`allowsBackup`, in the :code:`AndroidApplicationXmlElement` class. This predicate detects if the application element does not disable the :code:`android:allowBackup` attribute.
*   The predicates of the CodeQL class :code:`Annotation` have been improved:

    *   Convenience value type specific predicates have been added, such as :code:`getEnumConstantValue(string)` or :code:`getStringValue(string)`.
    *   Convenience predicates for elements with array values have been added, such as :code:`getAnEnumConstantArrayValue(string)`. While the behavior of the existing predicates has not changed, usage of them should be reviewed (or replaced with the newly added predicate) to make sure they work correctly for elements with array values.
    *   Some internal CodeQL usage of the :code:`Annotation` predicates has been adjusted and corrected; this might affect the results of some queries.
    
*   New predicates have been added to the CodeQL class :code:`Annotatable` to support getting declared and associated annotations. As part of that, :code:`hasAnnotation()` has been changed to also consider inherited annotations, to be consistent with :code:`hasAnnotation(string, string)` and :code:`getAnAnnotation()`. The newly added predicate :code:`hasDeclaredAnnotation()` can be used as replacement for the old functionality.
*   New predicates have been added to the CodeQL class :code:`AnnotationType` to simplify getting information about usage of JDK meta-annotations, such as :code:`@Retention`.

Shared Libraries
----------------

Initial Release
~~~~~~~~~~~~~~~

Static Single Assignment (SSA)
""""""""""""""""""""""""""""""

*   Initial release. Extracted common SSA code into a library pack to share code between languages.

Database of Common Typographical Errors
"""""""""""""""""""""""""""""""""""""""

*   Initial release. Share the database of common typographical errors between languages.
