## 1.1.1

No user-facing changes.

## 1.1.0

### Major Analysis Improvements

* The precision of virtual dispatch has been improved. This increases precision in general for all data flow queries. 

### Minor Analysis Improvements

* Support for Eclipse Compiler for Java (ecj) has been fixed to work with (a) runs that don't pass `-noExit` and (b) runs that use post-Java-9 command-line arguments.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### Major Analysis Improvements

* Added support for data flow through side-effects on static fields. For example, when a static field containing an array is updated.

### Minor Analysis Improvements

* JDK version detection based on Gradle projects has been improved. Java extraction using build-modes `autobuild` or `none` is more likely to pick an appropriate JDK version, particularly when the Android Gradle Plugin or Spring Boot Plugin are in use.

## 0.11.0

### Breaking Changes

* The Java extractor no longer supports the `ODASA_JAVA_LAYOUT`, `ODASA_TOOLS` and `ODASA_HOME` legacy environment variables.
* The Java extractor no longer supports the `ODASA_BUILD_ERROR_DIR` legacy environment variable.

## 0.10.0

### Breaking Changes

* Deleted the deprecated `AssignLShiftExpr`, `AssignRShiftExpr`, `AssignURShiftExpr`, `LShiftExpr`, `RShiftExpr`, and `URShiftExpr` aliases.

## 0.9.1

### Minor Analysis Improvements

* About 6,700 summary models and 6,800 neutral summary models for the JDK that were generated using data flow have been added. This may lead to new alerts being reported.

## 0.9.0

### Breaking Changes

* The Java extractor no longer supports the `ODASA_SNAPSHOT` legacy environment variable.

### Minor Analysis Improvements

* Increased the precision of some dataflow models of the class `java.net.URL` by distinguishing the parts of a URL.
* The Java extractor and QL libraries now support Java 22, including support for anonymous variables, lambda parameters and patterns.
* Pattern cases with multiple patterns and that fall through to or from other pattern cases are now supported. The `PatternCase` class gains the new `getPatternAtIndex` and `getAPattern` predicates, and deprecates `getPattern`.
* Added a `path-injection` sink for the `open` methods of the `android.os.ParcelFileDescriptor` class.

## 0.8.12

No user-facing changes.

## 0.8.11

No user-facing changes.

## 0.8.10

### Minor Analysis Improvements

* Java expressions with erroneous types (e.g. the result of a call whose callee couldn't be resolved during extraction) are now given a CodeQL `ErrorType` more often.

### Bug Fixes

* Fixed the Java autobuilder overriding the version of Maven used by a project when the Maven wrapper `mvnw` is in use and the `maven-wrapper.jar` file is not present in the repository.
* Some flow steps related to `android.text.Editable.toString` that were accidentally disabled have been re-enabled.

## 0.8.9

### Deprecated APIs

* The `PathCreation` class in `PathCreation.qll` has been deprecated.

### Minor Analysis Improvements

* An extension point for sanitizers of the query `java/unvalidated-url-redirection` has been added.
* Added models for the following packages:

  * java.io
  * java.lang
  * java.net
  * java.net.http
  * java.nio.file
  * java.util.zip
  * javax.servlet
  * org.apache.commons.io
  * org.apache.hadoop.fs
  * org.apache.hadoop.fs.s3a
  * org.eclipse.jetty.client
  * org.gradle.api.file

## 0.8.8

### Minor Analysis Improvements

* Added models for the following packages:

  * com.fasterxml.jackson.databind
  * javax.servlet
* Added the `java.util.Date` and `java.util.UUID` classes to the list of types in the `SimpleTypeSanitizer` class in `semmle.code.java.security.Sanitizers`.

## 0.8.7

### New Features

* Added a new library `semmle.code.java.security.Sanitizers` which contains a new sanitizer class `SimpleTypeSanitizer`, which represents nodes which cannot realistically carry taint for most queries (e.g. primitives, their boxed equivalents, and numeric types).
* Converted definitions of `isBarrier` and sanitizer classes to use `SimpleTypeSanitizer` instead of checking if `node.getType()` is `PrimitiveType` or `BoxedType`.

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `EJB`, `JMX`, `NFE`, `DNS` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `semmle/code/java/security/OverlyLargeRangeQuery.qll`, `semmle/code/java/security/regexp/ExponentialBackTracking.qll`, `semmle/code/java/security/regexp/NfaUtils.qll`, and `semmle/code/java/security/regexp/NfaUtils.qll` files.
* Improved models for `java.lang.Throwable` and `java.lang.Exception`, and the `valueOf` method of `java.lang.String`.
* Added taint tracking for the following GSON methods:
  * `com.google.gson.stream.JsonReader` constructor
  * `com.google.gson.stream.JsonWriter` constructor
  * `com.google.gson.JsonObject.getAsJsonArray`
  * `com.google.gson.JsonObject.getAsJsonObject`
  * `com.google.gson.JsonObject.getAsJsonPrimitive`
  * `com.google.gson.JsonParser.parseReader`
  * `com.google.gson.JsonParser.parseString`
* Added a dataflow model for `java.awt.Desktop.browse(URI)`.

### Bug Fixes

* Fixed regular expressions containing flags not being parsed correctly in some cases.

## 0.8.6

### Deprecated APIs

* Imports of the old dataflow libraries (e.g. `semmle.code.java.dataflow.DataFlow2`) have been deprecated in the libraries under the `semmle.code.java.security` namespace.

### Minor Analysis Improvements

* Added the `Map#replace` and `Map#replaceAll` methods to the `MapMutator` class in `semmle.code.java.Maps`.
* Taint tracking now understands Kotlin's `Array.get` and `Array.set` methods.
* Added a sink model for the `createRelative` method of the `org.springframework.core.io.Resource` interface.
* Added source models for methods of the `org.springframework.web.util.UrlPathHelper` class and removed their taint flow models.
* Added models for the following packages:

  * com.google.common.io
  * hudson
  * hudson.console
  * java.lang
  * java.net
  * java.util.logging
  * javax.imageio.stream
  * org.apache.commons.io
  * org.apache.hadoop.hive.ql.exec
  * org.apache.hadoop.hive.ql.metadata
  * org.apache.tools.ant.taskdefs
* Added models for the following packages:

  * com.alibaba.druid.sql.repository
  * jakarta.persistence
  * jakarta.persistence.criteria
  * liquibase.database.jvm
  * liquibase.statement.core
  * org.apache.ibatis.mapping
  * org.keycloak.models.map.storage

## 0.8.5

No user-facing changes.

## 0.8.4

### Minor Analysis Improvements

* The diagnostic query `java/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Java files, now considers any Java file seen during extraction, even one with some errors, to be extracted / scanned.
* Switch cases using binding patterns and `case null[, default]` are now supported. Classes `PatternCase` and `NullDefaultCase` are introduced to represent new kinds of case statement.
* Both switch cases and instanceof expressions using record patterns are now supported. The new class `RecordPatternExpr` is introduced to represent record patterns, and `InstanceOfExpr` gains `getPattern` to replace `getLocalVariableDeclExpr`.
* The control-flow graph and therefore dominance information regarding switch blocks in statement context but with an expression rule (e.g. `switch(...) { case 1 -> System.out.println("Hello world!") }`) has been fixed. This reduces false positives and negatives from various queries relating to functions featuring such statements.

## 0.8.3

### Deprecated APIs

* In `SensitiveApi.qll`, `javaApiCallablePasswordParam`, `javaApiCallableUsernameParam`, `javaApiCallableCryptoKeyParam`, and `otherApiCallableCredentialParam` predicates have been deprecated. They have been replaced with a new class `CredentialsSinkNode` and its child classes `PasswordSink`, `UsernameSink`, and `CryptoKeySink`. The predicates have been changed to using the new classes, so there may be minor changes in results relying on these predicates.

### Minor Analysis Improvements

* The types `java.util.SequencedCollection`, `SequencedSet` and `SequencedMap`, as well as the related `Collections.unmodifiableSequenced*` methods are now modelled. This means alerts may be raised relating to data flow through these types and methods.

## 0.8.2

### Minor Analysis Improvements

* Java classes `MethodAccess`, `LValue` and `RValue` were renamed to `MethodCall`, `VarWrite` and `VarRead` respectively, along with related predicates and class names. The old names remain usable for the time being but are deprecated and should be replaced.
* New class `NewClassExpr` was added to represent specifically an explicit `new ClassName(...)` invocation, in contrast to `ClassInstanceExpr` which also includes expressions that implicitly instantiate classes, such as defining a lambda or taking a method reference.
* Added up to date models related to Spring Framework 6's `org.springframework.http.ResponseEntity`.
* Added models for the following packages:

  * com.alibaba.fastjson2
  * javax.management
  * org.apache.http.client.utils

## 0.8.1

### New Features

* Added predicate `MemberRefExpr::getReceiverExpr`

### Minor Analysis Improvements

* The `isBarrier`, `isBarrierIn`, `isBarrierOut`, and `isAdditionalFlowStep` methods of the taint-tracking configurations for local queries in the `ArithmeticTaintedLocalQuery`, `ExternallyControlledFormatStringLocalQuery`, `ImproperValidationOfArrayIndexQuery`, `NumericCastTaintedQuery`, `ResponseSplittingLocalQuery`, `SqlTaintedLocalQuery`, and `XssLocalQuery` libraries have been changed to match their remote counterpart configurations.
* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.
* Deleted the deprecated `getAValue` predicate from the `Annotation` class.
* Deleted the deprecated alias `FloatingPointLiteral`, use `FloatLiteral` instead.
* Deleted the deprecated `getASuppressedWarningLiteral` predicate from the `SuppressWarningsAnnotation` class.
* Deleted the deprecated `getATargetExpression` predicate form the `TargetAnnotation` class.
* Deleted the deprecated `getRetentionPolicyExpression` predicate from the `RetentionAnnotation` class.
* Deleted the deprecated `conditionCheck` predicate from `Preconditions.qll`.
* Deleted the deprecated `semmle.code.java.security.performance` folder, use `semmle.code.java.security.regexp` instead.
* Deleted the deprecated `ExternalAPI` class from `ExternalApi.qll`, use `ExternalApi` instead.
* Modified the `EnvInput` class in `semmle.code.java.dataflow.FlowSources` to include `environment` and `file` source nodes.
  There are no changes to results unless you add source models using the `environment` or `file` source kinds.
* Added `environment` source models for the following methods:
  * `java.lang.System#getenv`
  * `java.lang.System#getProperties`
  * `java.lang.System#getProperty`
  * `java.util.Properties#get`
  * `java.util.Properties#getProperty`
* Added `file` source models for the following methods:
  * the `java.io.FileInputStream` constructor
  * `hudson.FilePath#newInputStreamDenyingSymlinkAsNeeded`
  * `hudson.FilePath#openInputStream`
  * `hudson.FilePath#read`
  * `hudson.FilePath#readFromOffset`
  * `hudson.FilePath#readToString`
* Modified the `DatabaseInput` class in `semmle.code.java.dataflow.FlowSources` to include `database` source nodes.
  There are no changes to results unless you add source models using the `database` source kind.
* Added `database` source models for the following method:
  * `java.sql.ResultSet#getString`

## 0.8.0

### New Features

* Kotlin versions up to 1.9.20 are now supported.

### Minor Analysis Improvements

* Fixed a control-flow bug where case rule statements would incorrectly include a fall-through edge.
* Added support for default cases as proper guards in switch expressions to match switch statements.
* Improved the class `ArithExpr` of the `Overflow.qll` module to also include compound operators. Because of this, new alerts may be raised in queries related to overflows/underflows.
* Added new dataflow models for the Apache CXF framework.
* Regular expressions containing multiple parse mode flags are now interpretted correctly. For example `"(?is)abc.*"` with both the `i` and `s` flags.

### Bug Fixes

* The regular expressions library no longer incorrectly matches mode flag characters against the input.

## 0.7.5

No user-facing changes.

## 0.7.4

### New Features

* Kotlin versions up to 1.9.10 are now supported.

### Minor Analysis Improvements

* Fixed the MaD signature specifications to use proper nested type names.
* Added new sanitizer to Java command injection model
* Added more dataflow models for JAX-RS.
* The predicate `JaxWsEndpoint::getARemoteMethod` no longer requires the result to be annotated with `@WebMethod`. Instead, the requirements listed in the JAX-RPC Specification 1.1 for required parameter and return types are used. Applications using JAX-RS may see an increase in results.

## 0.7.3

### Major Analysis Improvements

* Improved support for flow through captured variables that properly adheres to inter-procedural control flow.

### Minor Analysis Improvements

* Modified the `getSecureAlgorithmName` predicate in `Encryption.qll` to also include `SHA-256` and `SHA-512`. Previously only the versions of the names without dashes were considered secure.
* Add support for `WithElement` and `WithoutElement` for MaD access paths.

## 0.7.2

### New Features

* A `Diagnostic.getCompilationInfo()` predicate has been added.

### Minor Analysis Improvements

* Fixed a typo in the `StdlibRandomSource` class in `RandomDataSource.qll`, which caused the class to improperly model calls to the `nextBytes` method. Queries relying on `StdlibRandomSource` may see an increase in results.
* Improved the precision of virtual dispatch of `java.io.InputStream` methods. Now, calls to these methods will not dispatch to arbitrary implementations of `InputStream` if there is a high-confidence alternative (like a models-as-data summary).
* Added more dataflow steps for `java.io.InputStream`s that wrap other `java.io.InputStream`s.
* Added models for the Struts 2 framework.
* Improved the modeling of Struts 2 sources of untrusted data by tainting the whole object graph of the objects unmarshaled from an HTTP request.

## 0.7.1

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.
* A `Class.isFileClass()` predicate, to identify Kotlin file classes, has been added.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.
* Added models for Apache Commons Lang3 `ToStringBuilder.reflectionToString` method.
* Added support for the Kotlin method `apply`.
* Added models for the following packages:

  * java.io
  * java.lang
  * java.net
  * java.nio.channels
  * java.nio.file
  * java.util.zip
  * okhttp3
  * org.gradle.api.file
  * retrofit2

## 0.7.0

### Deprecated APIs

* The `ExecCallable` class in `ExternalProcess.qll` has been deprecated.

### Major Analysis Improvements

* The data flow library now performs type strengthening. This increases precision for all data flow queries by excluding paths that can be inferred to be impossible due to incompatible types.

### Minor Analysis Improvements

* Added automatically-generated dataflow models for `javax.portlet`.
* Added a missing summary model for the method `java.net.URL.toString`.
* Added automatically-generated dataflow models for the following frameworks and libraries:
  * `hudson`
  * `jenkins`
  * `net.sf.json`
  * `stapler`
* Added more models for the Hudson framework.
* Added more models for the Stapler framework.

## 0.6.4

No user-facing changes.

## 0.6.3

### New Features

* Kotlin versions up to 1.9.0 are now supported.

### Minor Analysis Improvements

* Added flow through the block arguments of `kotlin.io.use` and `kotlin.with`.
* Added models for the following packages:

  * com.alibaba.druid.sql
  * com.fasterxml.jackson.databind
  * com.jcraft.jsch
  * io.netty.handler.ssl
  * okhttp3
  * org.antlr.runtime
  * org.fusesource.leveldbjni
  * org.influxdb
  * org.springframework.core.io
  * org.yaml.snakeyaml
* Deleted the deprecated `getRHS` predicate from the `LValue` class, use `getRhs` instead.
* Deleted the deprecated `getCFGNode` predicate from the `SsaVariable` class, use `getCfgNode` instead.
* Deleted many deprecated predicates and classes with uppercase `XML`, `JSON`, `URL`, `API`, etc. in their names. Use the PascalCased versions instead.
* Added models for the following packages:

  * java.lang
  * java.nio.file
* Added dataflow models for the Gson deserialization library.
* Added models for the following packages:

  * okhttp3
* Added more dataflow models for the Play Framework.
* Modified the models related to `java.nio.file.Files.copy` so that generic `[Input|Output]Stream` arguments are not considered file-related sinks.
* Dataflow analysis has a new flow step through constructors of transitive subtypes of `java.io.InputStream` that wrap an underlying data source. Previously, the step only existed for direct subtypes of `java.io.InputStream`.
* Path creation sinks modeled in `PathCreation.qll` have been added to the models-as-data sink kind `path-injection`.
* Updated the regular expression in the `HostnameSanitizer` sanitizer in the `semmle.code.java.security.RequestForgery` library to better detect strings prefixed with a hostname.
* Changed the `android-widget` Java source kind to `remote`. Any custom data extensions that use the `android-widget` source kind will need to be updated accordingly in order to continue working.
* Updated the following Java sink kind names. Any custom data extensions will need to be updated accordingly in order to continue working.
  * `sql` to `sql-injection`
  * `url-redirect` to `url-redirection`
  * `xpath` to `xpath-injection`
  * `ssti` to `template-injection`
  * `logging` to `log-injection`
  * `groovy` to `groovy-injection`
  * `jexl` to `jexl-injection`
  * `mvel` to `mvel-injection`
  * `xslt` to `xslt-injection`
  * `ldap` to `ldap-injection`
  * `pending-intent-sent` to `pending-intents`
  * `intent-start` to `intent-redirection`
  * `set-hostname-verifier` to `hostname-verification`
  * `header-splitting` to `response-splitting`
  * `xss` to `html-injection` and `js-injection`
  * `write-file` to `file-system-store`
  * `create-file` and `read-file` to `path-injection`
  * `open-url` and `jdbc-url` to `request-forgery`

## 0.6.2

### Minor Analysis Improvements

* Added SQL injection sinks for Spring JDBC's `NamedParameterJdbcOperations`.
* Added models for the following packages:

  * org.apache.hadoop.fs
* Added the `ArithmeticCommon.qll` library to provide predicates for reasoning about arithmetic operations.
* Added the `ArithmeticTaintedLocalQuery.qll` library to provide the `ArithmeticTaintedLocalOverflowFlow` and `ArithmeticTaintedLocalUnderflowFlow` taint-tracking modules to reason about arithmetic with unvalidated user input.
* Added the `ArithmeticTaintedQuery.qll` library to provide the `RemoteUserInputOverflow` and `RemoteUserInputUnderflow` taint-tracking modules to reason about arithmetic with unvalidated user input.
* Added the `ArithmeticUncontrolledQuery.qll` library to provide the `ArithmeticUncontrolledOverflowFlow`  and `ArithmeticUncontrolledUnderflowFlow` taint-tracking modules to reason about arithmetic with uncontrolled user input.
* Added the `ArithmeticWithExtremeValuesQuery.qll` library to provide the `MaxValueFlow` and `MinValueFlow` dataflow modules to reason about arithmetic with extreme values.
* Added the `BrokenCryptoAlgorithmQuery.qll` library to provide the `InsecureCryptoFlow` taint-tracking module to reason about broken cryptographic algorithm vulnerabilities.
* Added the `ExecTaintedLocalQuery.qll` library to provide the `LocalUserInputToArgumentToExecFlow` taint-tracking module to reason about command injection vulnerabilities caused by local data flow.
* Added the `ExternallyControlledFormatStringLocalQuery.qll` library to provide the `ExternallyControlledFormatStringLocalFlow` taint-tracking module to reason about format string vulnerabilities caused by local data flow.
* Added the `ImproperValidationOfArrayConstructionCodeSpecifiedQuery.qll` library to provide the `BoundedFlowSourceFlow` dataflow module to reason about improper validation of code-specified sizes used for array construction.
* Added the `ImproperValidationOfArrayConstructionLocalQuery.qll` library to provide the `ImproperValidationOfArrayConstructionLocalFlow` taint-tracking module to reason about improper validation of local user-provided sizes used for array construction caused by local data flow.
* Added the `ImproperValidationOfArrayConstructionQuery.qll` library to provide the `ImproperValidationOfArrayConstructionFlow` taint-tracking module to reason about improper validation of user-provided size used for array construction.
* Added the `ImproperValidationOfArrayIndexCodeSpecifiedQuery.qll` library to provide the `BoundedFlowSourceFlow` data flow module to reason about about improper validation of code-specified array index.
* Added the `ImproperValidationOfArrayIndexLocalQuery.qll` library to provide the `ImproperValidationOfArrayIndexLocalFlow` taint-tracking module to reason about improper validation of a local user-provided array index.
* Added the `ImproperValidationOfArrayIndexQuery.qll` library to provide the `ImproperValidationOfArrayIndexFlow` taint-tracking module to reason about improper validation of user-provided array index.
* Added the `InsecureCookieQuery.qll` library to provide the `SecureCookieFlow` taint-tracking module to reason about insecure cookie vulnerabilities.
* Added the `MaybeBrokenCryptoAlgorithmQuery.qll` library to provide the `InsecureCryptoFlow` taint-tracking module to reason about broken cryptographic algorithm vulnerabilities.
* Added the `NumericCastTaintedQuery.qll` library to provide the `NumericCastTaintedFlow` taint-tracking module to reason about numeric cast vulnerabilities.
* Added the `ResponseSplittingLocalQuery.qll` library to provide the `ResponseSplittingLocalFlow` taint-tracking module to reason about response splitting vulnerabilities caused by local data flow.
* Added the `SqlConcatenatedQuery.qll` library to provide the `UncontrolledStringBuilderSourceFlow` taint-tracking module to reason about SQL injection vulnerabilities caused by concatenating untrusted strings.
* Added the `SqlTaintedLocalQuery.qll` library to provide the `LocalUserInputToArgumentToSqlFlow` taint-tracking module to reason about SQL injection vulnerabilities caused by local data flow.
* Added the `StackTraceExposureQuery.qll` library to provide the `printsStackExternally`, `stringifiedStackFlowsExternally`, and `getMessageFlowsExternally` predicates to reason about stack trace exposure vulnerabilities.
* Added the `TaintedPermissionQuery.qll` library to provide the `TaintedPermissionFlow` taint-tracking module to reason about tainted permission vulnerabilities.
* Added the `TempDirLocalInformationDisclosureQuery.qll` library to provide the `TempDirSystemGetPropertyToCreate` taint-tracking module to reason about local information disclosure vulnerabilities caused by local data flow.
* Added the `UnsafeHostnameVerificationQuery.qll` library to provide the `TrustAllHostnameVerifierFlow` taint-tracking module to reason about insecure hostname verification vulnerabilities.
* Added the `UrlRedirectLocalQuery.qll` library to provide the `UrlRedirectLocalFlow` taint-tracking module to reason about URL redirection vulnerabilities caused by local data flow.
* Added the `UrlRedirectQuery.qll` library to provide the `UrlRedirectFlow` taint-tracking module to reason about URL redirection vulnerabilities.
* Added the `XPathInjectionQuery.qll` library to provide the `XPathInjectionFlow` taint-tracking module to reason about XPath injection vulnerabilities.
* Added the `XssLocalQuery.qll` library to provide the `XssLocalFlow` taint-tracking module to reason about XSS vulnerabilities caused by local data flow.
* Moved the `url-open-stream` sink models to experimental and removed `url-open-stream` as a sink option from the [Customizing Library Models for Java](https://github.com/github/codeql/blob/733a00039efdb39c3dd76ddffad5e6d6c85e6774/docs/codeql/codeql-language-guides/customizing-library-models-for-java.rst#customizing-library-models-for-java) documentation.
* Added models for the Apache Commons Net library.
* Updated the `neutralModel` extensible predicate to include a `kind` column.
* Added models for the `io.jsonwebtoken` library.

## 0.6.1

### Deprecated APIs

* The `sensitiveResultReceiver` predicate in `SensitiveResultReceiverQuery.qll` has been deprecated and replaced with `isSensitiveResultReceiver` in order to use the new dataflow API.

### Minor Analysis Improvements

* Changed some models of Spring's `FileCopyUtils.copy` to be path injection sinks instead of summaries.
* Added models for the following packages:
  * java.nio.file
* Added models for [Apache HttpComponents](https://hc.apache.org/) versions 4 and 5.
* Added sanitizers that recognize line breaks to the query `java/log-injection`.
* Added new flow steps for `java.util.StringJoiner`.

## 0.6.0

### Deprecated APIs

* The `execTainted` predicate in `CommandLineQuery.qll` has been deprecated and replaced with the predicate `execIsTainted`.
* The recently introduced new data flow and taint tracking APIs have had a
  number of module and predicate renamings. The old APIs remain in place for
  now.
* The `WebViewDubuggingQuery` library has been renamed to `WebViewDebuggingQuery` to fix the typo in the file name. `WebViewDubuggingQuery` is now deprecated. 

### New Features

* Predicates `Compilation.getExpandedArgument` and `Compilation.getAnExpandedArgument` has been added.

### Minor Analysis Improvements

* Fixed a bug in the regular expression used to identify sensitive information in `SensitiveActions::getCommonSensitiveInfoRegex`. This may affect the results of the queries `java/android/sensitive-communication`, `java/android/sensitive-keyboard-cache`, and `java/sensitive-log`. 
* Added a summary model for the `java.lang.UnsupportedOperationException(String)` constructor.
* The filenames embedded in `Compilation.toString()` now use `/` as the path separator on all platforms.
* Added models for the following packages:
  * `java.lang`
  * `java.net`
  * `java.nio.file`
  * `java.io`
  * `java.lang.module`
  * `org.apache.commons.httpclient.util`
  * `org.apache.commons.io`
  * `org.apache.http.client`
  * `org.eclipse.jetty.client`
  * `com.google.common.io`
  * `kotlin.io`
* Added the `TaintedPathQuery.qll` library to provide the `TaintedPathFlow` and `TaintedPathLocalFlow` taint-tracking modules to reason about tainted path vulnerabilities.
* Added the `ZipSlipQuery.qll` library to provide the `ZipSlipFlow` taint-tracking module to reason about zip-slip vulnerabilities.
* Added the `InsecureBeanValidationQuery.qll` library to provide the `BeanValidationFlow` taint-tracking module to reason about bean validation vulnerabilities.
* Added the `XssQuery.qll` library to provide the `XssFlow` taint-tracking module to reason about cross site scripting vulnerabilities.
* Added the `LdapInjectionQuery.qll` library to provide the `LdapInjectionFlow` taint-tracking module to reason about LDAP injection vulnerabilities.
* Added the `ResponseSplittingQuery.qll` library to provide the `ResponseSplittingFlow` taint-tracking module to reason about response splitting vulnerabilities.
* Added the `ExternallyControlledFormatStringQuery.qll` library to provide the `ExternallyControlledFormatStringFlow` taint-tracking module to reason about externally controlled format string vulnerabilities.
* Improved the handling of addition in the range analysis. This can cause in minor changes to the results produced by `java/index-out-of-bounds` and `java/constant-comparison`.
* A new models as data sink kind `command-injection` has been added.
* The queries `java/command-line-injection` and `java/concatenated-command-line` now can be extended using the `command-injection` models as data sink kind.
* Added more sink and summary dataflow models for the following packages:
  * `java.net`
  * `java.nio.file`
  * `javax.imageio.stream`
  * `javax.naming`
  * `javax.servlet`
  * `org.geogebra.web.full.main`
  * `hudson`
  * `hudson.cli`
  * `hudson.lifecycle`
  * `hudson.model`
  * `hudson.scm`
  * `hudson.util`
  * `hudson.util.io`
* Added the extensible abstract class `JndiInjectionSanitizer`. Now this class can be extended to add more sanitizers to the `java/jndi-injection` query.
* Added a summary model for the `nativeSQL` method of the `java.sql.Connection` interface.
* Added sink and summary dataflow models for the Jenkins and Netty frameworks.
* The Models as Data syntax for selecting the qualifier has been changed from `-1` to `this` (e.g. `Argument[-1]` is now written as `Argument[this]`).
* Added sources and flow step models for the Netty framework up to version 4.1.
* Added more dataflow models for frequently-used JDK APIs.

### Bug Fixes

* Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular `DataFlow::hasFlowPath`, `DataFlow::hasFlow`, `DataFlow::hasFlowTo`, and `DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

## 0.5.6

No user-facing changes.

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
