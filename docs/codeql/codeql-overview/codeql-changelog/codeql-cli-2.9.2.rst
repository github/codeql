.. _codeql-cli-2.9.2:

=========================
CodeQL 2.9.2 (2022-05-16)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.9.2 runs a total of 330 security queries when configured with the Default suite (covering 141 CWE). The Extended suite enables an additional 104 queries (covering 29 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug that could make it unpredictable whether the QL compiler reports problems about query metadata tags, and thereby make :code:`codeql test run` fail spuriously in some cases.

New Features
~~~~~~~~~~~~

*   The tables produced by :code:`codeql database analyze` summarizing the results of any diagnostic and metric queries that were run now exclude the results of queries tagged :code:`telemetry`.
    
*   Uploading SARIF results using the :code:`codeql github upload-results` command now has a timeout of 5 minutes.
    
*   Downloading CodeQL packs using the :code:`codeql pack download`,
    :code:`codeql pack install` and related commands now have a timeout of 5 minutes and will retry 3 times before failing. Similar behavior has been added to the :code:`codeql pack publish` command.
    
*   The :code:`codeql generate log-summary` command will now print progress updates to :code:`stderr`.

Removed Features
~~~~~~~~~~~~~~~~

*   The table printed by :code:`codeql database analyze` to summarize the results of metric queries that were part of the analysis now reports a single row per metric name independently of the verbosity level of the command. Previously, at higher verbosity levels, this table would contain multiple rows for metric names with multiple values.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "XML external entity expansion" (:code:`cpp/external-entity-expansion`) query has been extended to support a broader selection of XML libraries and interfaces.

Java/Kotlin
"""""""""""

*   Query :code:`java/insecure-cookie` now tolerates setting a cookie's secure flag to :code:`request.isSecure()`. This means servlets that intentionally accept unencrypted connections will no longer raise an alert.
*   The query :code:`java/non-https-urls` has been simplified and no longer requires its sinks to be :code:`MethodAccess`\ es.
*   The logic to detect :code:`WebView`\ s with JavaScript (and optionally file access) enabled in the query :code:`java/android/unsafe-android-webview-fetch` has been improved.

New Queries
~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/missing-origin-check` query has been added. It highlights "message" event handlers that do not check the origin of the event.
    
    The query previously existed as the experimental :code:`js/missing-postmessageorigin-verification` query.

Python
""""""

*   "XML external entity expansion" (:code:`py/xxe`). Results will appear by default. This query was based on `an experimental query by @jorgectf <https://github.com/github/codeql/pull/6112>`__.
*   "XML internal entity expansion" (:code:`py/xml-bomb`). Results will appear by default. This query was based on `an experimental query by @jorgectf <https://github.com/github/codeql/pull/6112>`__.
*   The query "CSRF protection weakened or disabled" (:code:`py/csrf-protection-disabled`) has been implemented. Its results will now appear by default.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Query :code:`java/predictable-seed` now has a tag for CWE-337.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Ruby
""""

*   The Tree-sitter Ruby grammar has been updated; this fixes several issues where Ruby code was parsed incorrectly.

Breaking Changes
~~~~~~~~~~~~~~~~

Python
""""""

*   The imports made available from :code:`import python` are no longer exposed under :code:`DataFlow::` after doing :code:`import semmle.python.dataflow.new.DataFlow`, for example using :code:`DataFlow::Add` will now cause a compile error.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added models for the libraries OkHttp and Retrofit.
*   Add taint models for the following :code:`File` methods:

    *   :code:`File::getAbsoluteFile`
    *   :code:`File::getCanonicalFile`
    *   :code:`File::getAbsolutePath`
    *   :code:`File::getCanonicalPath`
    
*   Added a flow step for :code:`toString` calls on tainted :code:`android.text.Editable` objects.
*   Added a data flow step for tainted Android intents that are sent to other activities and accessed there via :code:`getIntent()`.
*   Added modeling of MyBatis (:code:`org.apache.ibatis`) Providers, resulting in additional sinks for the queries :code:`java/ognl-injection`, :code:`java/sql-injection`, :code:`java/sql-injection-local` and :code:`java/concatenated-sql-query`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The `cash <https://github.com/fabiospampinato/cash>`__ library is now modelled as an alias for JQuery.
    
    Sinks and sources from cash should now be handled by all XSS queries.
*   Added the :code:`Selection` api as a DOM text source in the :code:`js/xss-through-dom` query.
*   The security queries now recognize drag and drop data as a source, enabling the queries to flag additional alerts.
*   The security queries now recognize ClipboardEvent function parameters as a source, enabling the queries to flag additional alerts.

Python
""""""

*   The modeling of :code:`request.files` in Flask has been fixed, so we now properly handle assignments to local variables (such as :code:`files = request.files; files['key'].filename`).
*   Added taint propagation for :code:`io.StringIO` and :code:`io.BytesIO`. This addition was originally `submitted as part of an experimental query by @jorgectf <https://github.com/github/codeql/pull/6112>`__.

Deprecated APIs
~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`ReflectedXss`, :code:`StoredXss`, :code:`XssThroughDom`, and :code:`ExceptionXss` modules from :code:`Xss.qll` have been deprecated.
    
    Use the :code:`Customizations.qll` file belonging to the query instead.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   A number of new classes and methods related to the upcoming Kotlin support have been added. These are not yet stable, as Kotlin support is still under development.

    *   :code:`File::isSourceFile`
    *   :code:`File::isJavaSourceFile`
    *   :code:`File::isKotlinSourceFile`
    *   :code:`Member::getKotlinType`
    *   :code:`Element::isCompilerGenerated`
    *   :code:`Expr::getKotlinType`
    *   :code:`LambdaExpr::isKotlinFunctionN`
    *   :code:`Callable::getReturnKotlinType`
    *   :code:`Callable::getParameterKotlinType`
    *   :code:`Method::isLocal`
    *   :code:`Method::getKotlinName`
    *   :code:`Field::getKotlinType`
    *   :code:`Modifiable::isSealedKotlin`
    *   :code:`Modifiable::isInternal`
    *   :code:`Variable::getKotlinType`
    *   :code:`LocalVariableDecl::getKotlinType`
    *   :code:`Parameter::getKotlinType`
    *   :code:`Parameter::isExtensionParameter`
    *   :code:`Compilation` class
    *   :code:`Diagnostic` class
    *   :code:`KtInitializerAssignExpr` class
    *   :code:`ValueEQExpr` class
    *   :code:`ValueNEExpr` class
    *   :code:`ValueOrReferenceEqualsExpr` class
    *   :code:`ValueOrReferenceNotEqualsExpr` class
    *   :code:`ReferenceEqualityTest` class
    *   :code:`CastingExpr` class
    *   :code:`SafeCastExpr` class
    *   :code:`ImplicitCastExpr` class
    *   :code:`ImplicitNotNullExpr` class
    *   :code:`ImplicitCoercionToUnitExpr` class
    *   :code:`UnsafeCoerceExpr` class
    *   :code:`PropertyRefExpr` class
    *   :code:`NotInstanceOfExpr` class
    *   :code:`ExtensionReceiverAccess` class
    *   :code:`WhenExpr` class
    *   :code:`WhenBranch` class
    *   :code:`ClassExpr` class
    *   :code:`StmtExpr` class
    *   :code:`StringTemplateExpr` class
    *   :code:`NotNullExpr` class
    *   :code:`TypeNullPointerException` class
    *   :code:`KtComment` class
    *   :code:`KtCommentSection` class
    *   :code:`KotlinType` class
    *   :code:`KotlinNullableType` class
    *   :code:`KotlinNotnullType` class
    *   :code:`KotlinTypeAlias` class
    *   :code:`Property` class
    *   :code:`DelegatedProperty` class
    *   :code:`ExtensionMethod` class
    *   :code:`KtInitializerNode` class
    *   :code:`KtLoopStmt` class
    *   :code:`KtBreakContinueStmt` class
    *   :code:`KtBreakStmt` class
    *   :code:`KtContinueStmt` class
    *   :code:`ClassObject` class
    *   :code:`CompanionObject` class
    *   :code:`LiveLiteral` class
    *   :code:`LiveLiteralMethod` class
    *   :code:`CastConversionContext` renamed to :code:`CastingConversionContext`
    
*   The QL class :code:`ValueDiscardingExpr` has been added, representing expressions for which the value of the expression as a whole is discarded.
