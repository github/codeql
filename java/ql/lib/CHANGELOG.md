## 0.5.5

### New Features

* Added support for merging two `PathGraph`s via disjoint union to allow results from multiple data flow computations in a single `path-problem` query.

### Major Analysis Improvements

* Removed low-confidence call edges to known neutral call targets from the call graph used in data flow analysis. This includes, for example, custom `List.contains` implementations when the best inferrable type at the call site is simply `List`.
* Added more sink and summary dataflow models for the following packages:
  * `java.io`
  * `java.lang`
  * `java.sql`
  * `javafx.scene.web`
  * `org.apache.commons.compress.archivers.tar`
  * `org.apache.http.client.utils`
  * `org.codehaus.cargo.container.installer`
* The main data flow and taint tracking APIs have been changed. The old APIs
  remain in place for now and translate to the new through a
  backwards-compatible wrapper. If multiple configurations are in scope
  simultaneously, then this may affect results slightly. The new API is quite
  similar to the old, but makes use of a configuration module instead of a
  configuration class.

### Minor Analysis Improvements

* Deleted the deprecated `getPath` and `getFolder` predicates from the `XmlFile` class.
* Deleted the deprecated `getRepresentedString` predicate from the `StringLiteral` class.
* Deleted the deprecated `ServletWriterSource` class.
* Deleted the deprecated `getGroupID`, `getArtefactID`, and `artefactMatches` predicates from the `MavenRepoJar` class.

## 0.5.4

### Minor Analysis Improvements

* Added new sinks for `java/hardcoded-credential-api-call` to identify the use of hardcoded secrets in the creation and verification of JWT tokens using `com.auth0.jwt`. These sinks are from [an experimental query submitted by @luchua](https://github.com/github/codeql/pull/9036).
* The Java extractor now supports builds against JDK 20.
* The query `java/hardcoded-credential-api-call` now recognizes methods that accept user and password from the SQLServerDataSource class of the Microsoft JDBC Driver for SQL Server.

## 0.5.3

### New Features

* Kotlin versions up to 1.8.20 are now supported.

### Minor Analysis Improvements

* Removed the first argument of `java.nio.file.Files#createTempDirectory(String,FileAttribute[])` as a "create-file" sink.
* Added the first argument of `java.nio.file.Files#copy` as a "read-file" sink for the `java/path-injection` query.
* The data flow library now disregards flow through code that is dead based on some basic constant propagation, for example, guards like `if (1+1>3)`.

## 0.5.2

### Minor Analysis Improvements

* Added sink models for the `createQuery`, `createNativeQuery`, and `createSQLQuery` methods of the `org.hibernate.query.QueryProducer` interface.

## 0.5.1

### Minor Analysis Improvements

* Added sink models for the constructors of `org.springframework.jdbc.object.MappingSqlQuery` and `org.springframework.jdbc.object.MappingSqlQueryWithParameters`.
* Added more dataflow models for frequently-used JDK APIs.
* Removed summary model for `java.lang.String#endsWith(String)` and added neutral model for this API.
* Added additional taint step for `java.lang.String#endsWith(String)` to `ConditionalBypassFlowConfig`.
* Added `AllowContentAccessMethod` to represent the `setAllowContentAccess` method of the `android.webkit.WebSettings` class.
* Added an external flow source for the parameters of methods annotated with `android.webkit.JavascriptInterface`.

## 0.5.0

### Minor Analysis Improvements

* Added more dataflow models for frequently-used JDK APIs.
* The extraction of Kotlin extension methods has been improved when default parameter values are present. The dispatch and extension receiver parameters are extracted in the correct order. The `ExtensionMethod::getExtensionReceiverParameterIndex` predicate has been introduced to facilitate getting the correct extension parameter index.
* The query `java/insecure-cookie` now uses global dataflow to track secure cookies being set to the HTTP response object.
* The library `PathSanitizer.qll` has been improved to detect more path validation patterns in Kotlin.
* Models as Data models for Java are defined as data extensions instead of being inlined in the code. New models should be added in the `lib/ext` folder.
* Added a taint model for the method `java.nio.file.Path.getParent`.
* Fixed a problem in the taint model for the method `java.nio.file.Paths.get`.
* Deleted the deprecated `LocalClassDeclStmtNode` and `LocalClassDeclStmt` classes from `PrintAst.qll` and `Statement.qll` respectively.
* Deleted the deprecated `getLocalClass` predicate from `LocalTypeDeclStmt`, and the deprecated `getLocalClassDeclStmt` predicate from `LocalClassOrInterface`.
* Added support for Android Manifest `<activity-aliases>` elements in data flow sources. 

### Bug Fixes

* We now correctly handle empty block comments, like `/**/`. Previously these could be mistaken for Javadoc comments and led to attribution of Javadoc tags to the wrong declaration.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

### New Features

* Kotlin support is now in beta. This means that Java analyses will also include Kotlin code by default. Kotlin support can be disabled by setting `CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN` to `true` in the environment.
* The new `string Compilation.getInfo(string)` predicate provides access to some information about compilations.

### Minor Analysis Improvements

* The ReDoS libraries in `semmle.code.java.security.regexp` has been moved to a shared pack inside the `shared/` folder, and the previous location has been deprecated.
* Added data flow summaries for tainted Android intents sent to activities via `Activity.startActivities`.

## 0.4.3

No user-facing changes.

## 0.4.2

### Deprecated APIs

* Deprecated `ContextStartActivityMethod`. Use `StartActivityMethod` instead.

### New Features

* Added a new predicate, `hasIncompletePermissions`, in the `AndroidProviderXmlElement` class. This predicate detects if a provider element does not provide both read and write permissions.

### Minor Analysis Improvements

* Added support for common patterns involving `Stream.collect` and common collectors like `Collectors.toList()`.
* The class `TypeVariable` now also extends `Modifiable`.
* Added data flow steps for tainted Android intents that are sent to services and receivers.
* Improved the data flow step for tainted Android intents that are sent to activities so that more cases are covered.

## 0.4.1

### Minor Analysis Improvements

* Added external flow sources for the intents received in exported Android services.

## 0.4.0

### Breaking Changes

* The `Member.getQualifiedName()` predicate result now includes the qualified name of the declaring type.

### Deprecated APIs

* The predicate `Annotation.getAValue()` has been deprecated because it might lead to obtaining the value of the wrong annotation element by accident. `getValue(string)` (or one of the value type specific predicates) should be used to explicitly specify the name of the annotation element.
* The predicate `Annotation.getAValue(string)` has been renamed to `getAnArrayValue(string)`.
* The predicate `SuppressWarningsAnnotation.getASuppressedWarningLiteral()` has been deprecated because it unnecessarily restricts the result type; `getASuppressedWarning()` should be used instead.
* The predicates `TargetAnnotation.getATargetExpression()` and `RetentionAnnotation.getRetentionPolicyExpression()` have been deprecated because getting the enum constant read expression is rarely useful, instead the corresponding predicates for getting the name of the referenced enum constants should be used.

### New Features

* Added a new predicate, `allowsBackup`, in the `AndroidApplicationXmlElement` class. This predicate detects if the application element does not disable the `android:allowBackup` attribute.
* The predicates of the CodeQL class `Annotation` have been improved:
  * Convenience value type specific predicates have been added, such as `getEnumConstantValue(string)` or `getStringValue(string)`.
  * Convenience predicates for elements with array values have been added, such as `getAnEnumConstantArrayValue(string)`. While the behavior of the existing predicates has not changed, usage of them should be reviewed (or replaced with the newly added predicate) to make sure they work correctly for elements with array values.
  * Some internal CodeQL usage of the `Annotation` predicates has been adjusted and corrected; this might affect the results of some queries.
* New predicates have been added to the CodeQL class `Annotatable` to support getting declared and associated annotations. As part of that, `hasAnnotation()` has been changed to also consider inherited annotations, to be consistent with `hasAnnotation(string, string)` and `getAnAnnotation()`. The newly added predicate `hasDeclaredAnnotation()` can be used as replacement for the old functionality.
* New predicates have been added to the CodeQL class `AnnotationType` to simplify getting information about usage of JDK meta-annotations, such as `@Retention`.

### Major Analysis Improvements

* The virtual dispatch relation used in data flow now favors summary models over source code for dispatch to interface methods from `java.util` unless there is evidence that a specific source implementation is reachable. This should provide increased precision for any projects that include, for example, custom `List` or `Map` implementations.

### Minor Analysis Improvements

* Added new sinks to the query `java/android/implicit-pendingintents` to take into account the classes `androidx.core.app.NotificationManagerCompat` and `androidx.core.app.AlarmManagerCompat`.
* Added new flow steps for `androidx.core.app.NotificationCompat` and its inner classes.
* Added flow sinks, sources and summaries for the Kotlin standard library.
* Added flow summary for `org.springframework.data.repository.CrudRepository.save()`.
* Added new flow steps for the following Android classes:
  * `android.content.ContentResolver`
  * `android.content.ContentProviderClient`
  * `android.content.ContentProviderOperation`
  * `android.content.ContentProviderOperation$Builder`
  * `android.content.ContentProviderResult`
  * `android.database.Cursor`
* Added taint flow models for the `java.lang.String.(charAt|getBytes)` methods.
* Improved taint flow models for the `java.lang.String.(replace|replaceFirst|replaceAll)` methods. Additional results may be found where users do not properly sanitize their inputs.

### Bug Fixes

* Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

## 0.3.5

## 0.3.4

### Deprecated APIs

* Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.
* The utility files previously in the `semmle.code.java.security.performance` package have been moved to the `semmle.code.java.security.regexp` package.  
  The previous files still exist as deprecated aliases.

### New Features

* Added a new predicate, `requiresPermissions`, in the `AndroidComponentXmlElement` and `AndroidApplicationXmlElement` classes to detect if the element has explicitly set a value for its `android:permission` attribute.
* Added a new predicate, `hasAnIntentFilterElement`, in the `AndroidComponentXmlElement` class to detect if a component contains an intent filter element.
* Added a new predicate, `hasExportedAttribute`, in the `AndroidComponentXmlElement` class to detect if a component has an `android:exported` attribute.
* Added a new class, `AndroidCategoryXmlElement`, to represent a category element in an Android manifest file.
* Added a new predicate, `getACategoryElement`, in the `AndroidIntentFilterXmlElement` class to get a category element of an intent filter.
* Added a new predicate, `isInBuildDirectory`, in the `AndroidManifestXmlFile` class. This predicate detects if the manifest file is located in a build directory.
* Added a new predicate, `isDebuggable`, in the `AndroidApplicationXmlElement` class. This predicate detects if the application element has its `android:debuggable` attribute enabled.

### Minor Analysis Improvements

* Added new flow steps for the classes `java.nio.file.Path` and `java.nio.file.Paths`.
* The class `AndroidFragment` now also models the Android Jetpack version of the `Fragment` class (`androidx.fragment.app.Fragment`).
* Java 19 builds can now be extracted. There are no non-preview new language features in this release, so the only user-visible change is that the CodeQL extractor will now correctly trace compilations using the JDK 19 release of `javac`.
* Classes and methods that are seen with several different paths during the extraction process (for example, packaged into different JAR files) now report an arbitrarily selected location via their `getLocation` and `hasLocationInfo` predicates, rather than reporting all of them. This may lead to reduced alert duplication.
* The query `java/hardcoded-credential-api-call` now recognises methods that consume usernames, passwords and keys from the JSch, Ganymed, Apache SSHD, sshj, Trilead SSH-2, Apache FTPClient and MongoDB projects. 

## 0.3.3

### Minor Analysis Improvements

* Improved analysis of the Android class `AsyncTask` so that data can properly flow through its methods according to the life-cycle steps described here: https://developer.android.com/reference/android/os/AsyncTask#the-4-steps.
* Added a data-flow model for the `setProperty` method of `java.util.Properties`. Additional results may be found where relevant data is stored in and then retrieved from a `Properties` instance.

## 0.3.2

### New Features

* The QL predicate `Expr::getUnderlyingExpr` has been added. It can be used to look through casts and not-null expressions and obtain the underlying expression to which they apply.

### Minor Analysis Improvements

* The JUnit5 version of `AssertNotNull` is now recognized, which removes related false positives in the nullness queries.
* Added data flow models for `java.util.Scanner`.

## 0.3.1

### New Features

* Added an `ErrorType` class. An instance of this class will be used if an extractor is unable to extract a type, or if an up/downgrade script is unable to provide a type.

### Minor Analysis Improvements

* Added data-flow models for `java.util.Properties`. Additional results may be found where relevant data is stored in and then retrieved from a `Properties` instance.
* Added `Modifier.isInline()`.
* Removed Kotlin-specific database and QL structures for loops and `break`/`continue` statements. The Kotlin extractor was changed to reuse the Java structures for these constructs.
* Added additional flow sources for uses of external storage on Android. 

## 0.3.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

### Minor Analysis Improvements

Added a flow step for `String.valueOf` calls on tainted `android.text.Editable` objects. 

## 0.2.3

## 0.2.2

### Deprecated APIs

* The QL class `FloatingPointLiteral` has been renamed to `FloatLiteral`.

### Minor Analysis Improvements

* Fixed a sanitizer of the query `java/android/intent-redirection`. Now, for an intent to be considered
  safe against intent redirection, both its package name and class name must be checked.

## 0.2.1

### New Features

* A number of new classes and methods related to the upcoming Kotlin
  support have been added. These are not yet stable, as Kotlin support
  is still under development.
   * `File::isSourceFile`
   * `File::isJavaSourceFile`
   * `File::isKotlinSourceFile`
   * `Member::getKotlinType`
   * `Element::isCompilerGenerated`
   * `Expr::getKotlinType`
   * `LambdaExpr::isKotlinFunctionN`
   * `Callable::getReturnKotlinType`
   * `Callable::getParameterKotlinType`
   * `Method::isLocal`
   * `Method::getKotlinName`
   * `Field::getKotlinType`
   * `Modifiable::isSealedKotlin`
   * `Modifiable::isInternal`
   * `Variable::getKotlinType`
   * `LocalVariableDecl::getKotlinType`
   * `Parameter::getKotlinType`
   * `Parameter::isExtensionParameter`
   * `Compilation` class
   * `Diagnostic` class
   * `KtInitializerAssignExpr` class
   * `ValueEQExpr` class
   * `ValueNEExpr` class
   * `ValueOrReferenceEqualsExpr` class
   * `ValueOrReferenceNotEqualsExpr` class
   * `ReferenceEqualityTest` class
   * `CastingExpr` class
   * `SafeCastExpr` class
   * `ImplicitCastExpr` class
   * `ImplicitNotNullExpr` class
   * `ImplicitCoercionToUnitExpr` class
   * `UnsafeCoerceExpr` class
   * `PropertyRefExpr` class
   * `NotInstanceOfExpr` class
   * `ExtensionReceiverAccess` class
   * `WhenExpr` class
   * `WhenBranch` class
   * `ClassExpr` class
   * `StmtExpr` class
   * `StringTemplateExpr` class
   * `NotNullExpr` class
   * `TypeNullPointerException` class
   * `KtComment` class
   * `KtCommentSection` class
   * `KotlinType` class
   * `KotlinNullableType` class
   * `KotlinNotnullType` class
   * `KotlinTypeAlias` class
   * `Property` class
   * `DelegatedProperty` class
   * `ExtensionMethod` class
   * `KtInitializerNode` class
   * `KtLoopStmt` class
   * `KtBreakContinueStmt` class
   * `KtBreakStmt` class
   * `KtContinueStmt` class
   * `ClassObject` class
   * `CompanionObject` class
   * `LiveLiteral` class
   * `LiveLiteralMethod` class
   * `CastConversionContext` renamed to `CastingConversionContext`
* The QL class `ValueDiscardingExpr` has been added, representing expressions for which the value of the expression as a whole is discarded.

### Minor Analysis Improvements

* Added models for the libraries OkHttp and Retrofit.
* Add taint models for the following `File` methods:
   * `File::getAbsoluteFile`
   * `File::getCanonicalFile`
   * `File::getAbsolutePath`
   * `File::getCanonicalPath`
* Added a flow step for `toString` calls on tainted `android.text.Editable` objects. 
* Added a data flow step for tainted Android intents that are sent to other activities and accessed there via `getIntent()`.
* Added modeling of MyBatis (`org.apache.ibatis`) Providers, resulting in additional sinks for the queries `java/ognl-injection`, `java/sql-injection`, `java/sql-injection-local` and `java/concatenated-sql-query`.

## 0.2.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

### Minor Analysis Improvements

* Improved the data flow support for the Android class `SharedPreferences$Editor`. Specifically, the fluent logic of some of its methods is now taken into account when calculating data flow.
  * Added flow sources and steps for JMS versions 1 and 2.
  * Added flow sources and steps for RabbitMQ.
  * Added flow steps for `java.io.DataInput` and `java.io.ObjectInput` implementations.
* Added data-flow models for the Spring Framework component `spring-beans`.

### Bug Fixes

* The QL class `JumpStmt` has been made the superclass of `BreakStmt`, `ContinueStmt` and `YieldStmt`. This allows directly using its inherited predicates without having to explicitly cast to `JumpStmt` first.

## 0.1.0

### Breaking Changes

* The recently added flow-state versions of `isBarrierIn`, `isBarrierOut`, `isSanitizerIn`, and `isSanitizerOut` in the data flow and taint tracking libraries have been removed.
* The `getUrl` predicate of `DeclaredRepository` in `MavenPom.qll` has been renamed to `getRepositoryUrl`. 

### New Features

* There are now QL classes ErrorExpr and ErrorStmt. These may be generated by upgrade or downgrade scripts when databases cannot be fully converted.

### Minor Analysis Improvements

* Added guard precondition support for assertion methods for popular testing libraries (e.g. Junit 4, Junit 5, TestNG).

## 0.0.13

## 0.0.12

### Breaking Changes

* The flow state variants of `isBarrier` and `isAdditionalFlowStep` are no longer exposed in the taint tracking library. The `isSanitizer` and `isAdditionalTaintStep` predicates should be used instead.

### Deprecated APIs

* Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* The data flow and taint tracking libraries have been extended with versions of `isBarrierIn`, `isBarrierOut`, and `isBarrierGuard`, respectively `isSanitizerIn`, `isSanitizerOut`, and `isSanitizerGuard`, that support flow states.

### Minor Analysis Improvements

 * Added new guards `IsWindowsGuard`, `IsSpecificWindowsVariant`, `IsUnixGuard`, and `IsSpecificUnixVariant` to detect OS specific guards.
 * Added a new predicate `getSystemProperty` that gets all expressions that retrieve system properties from a variety of sources (eg. alternative JDK API's, Google Guava, Apache Commons, Apache IO, etc.).
 * Added support for detection of SSRF via JDBC database URLs, including connections made using the standard library (`java.sql`), Hikari Connection Pool, JDBI and Spring JDBC.
 * Re-removed support for `CharacterLiteral` from `CompileTimeConstantExpr.getStringValue()` to restore the convention that that predicate only applies to `String`-typed constants.
* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.0.11

### New Features

* Added `hasDescendant(RefType anc, Type sub)`
* Added `RefType.getADescendant()`
* Added `RefType.getAStrictAncestor()`

### Minor Analysis Improvements

 * Add support for `CharacterLiteral` in `CompileTimeConstantExpr.getStringValue()`

## 0.0.10

### New Features

* Added predicates `ClassOrInterface.getAPermittedSubtype` and `isSealed` exposing information about sealed classes.

## 0.0.9

## 0.0.8

### Deprecated APIs

* The `codeql/java-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/java-all` CodeQL pack.

## 0.0.7

## 0.0.6

### Major Analysis Improvements

* Data flow now propagates taint from remote source `Parameter` types to read steps of their fields (e.g. `tainted.publicField` or `tainted.getField()`). This also applies to their subtypes and the types of their fields, recursively.

## 0.0.5

### Bug Fixes

* `CharacterLiteral`'s `getCodePointValue` predicate now returns the correct value for UTF-16 surrogates.
* The `RangeAnalysis` module now properly handles comparisons with Unicode surrogate character literals.

## 0.0.4

### Bug Fixes

* `CharacterLiteral`'s `getCodePointValue` predicate now returns the correct value for UTF-16 surrogates.
* The `RangeAnalysis` module and the `java/constant-comparison` queries no longer raise false alerts regarding comparisons with Unicode surrogate character literals.
* The predicate `Method.overrides(Method)` was accidentally transitive. This has been fixed. This fix also affects `Method.overridesOrInstantiates(Method)` and `Method.getASourceOverriddenMethod()`.
