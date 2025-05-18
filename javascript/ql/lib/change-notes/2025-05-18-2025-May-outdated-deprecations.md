---
category: breaking
---
* Deleted the deprecated `getImportAssertion` predicate from the `ImportDeclaration` class, use `getImportAttributes` instead.
* Deleted the deprecated `getImportAssertion` predicate from the `ExportDeclaration` class, use `getImportAttributes` instead.
* Deleted the deprecated `getImportAttributes` predicate from the `DynamicImportExpr` class, use `getImportOptions` instead.
* Deleted the deprecated `Configuration` class from the `BrokenCryptoAlgorithmQuery.qll`, use the `BrokenCryptoAlgorithmFlow` module instead.
* Deleted the deprecated `Configuration` class from the `BuildArtifactLeakQuery.qll`, use the `BuildArtifactLeakFlow` module instead.
* Deleted the deprecated `getLabel` predicate from the `CleartextLoggingCustomizations.qll`.
* Deleted the deprecated `getLabel` predicate from the `Sink` class.
* Deleted the deprecated `isSanitizerEdge` predicate from the `CleartextLoggingCustomizations.qll`, use `Barrier` instead, sanitized have been replaced by sanitized nodes.
* Deleted the deprecated `Configuration` class from the `CleartextLoggingQuery.qll`, use the `CleartextLoggingFlow` module instead.
* Deleted the deprecated `Configuration` class from the `CleartextStorageQuery.qll`, use the `ClearTextStorageFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ClientSideRequestForgeryQuery.qll`, use the `ClientSideRequestForgeryFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ClientSideUrlRedirectQuery.qll`.
* Deleted the deprecated `Configuration` class from the `CodeInjectionQuery.qll`, use the `CodeInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `CommandInjectionQuery.qll`, use the `CommandInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ConditionalBypassQuery.qll`, use the `ConditionalBypassFlow` module instead.
* Deleted the deprecated `Configuration` class from the `CorsMisconfigurationForCredentialsQuery.qll`, use the `CorsMisconfigurationFlow` module instead.
* Deleted the deprecated `Configuration` class from the `DeepObjectResourceExhaustionQuery.qll`, use the `DeepObjectResourceExhaustionFlow` module instead.
* Deleted the deprecated `isOptionallySanitizedEdge` predicate from the `DomBasedXssCustomizations.qll`, use the `isOptionallySanitizedNode` module instead.
* Deleted the deprecated `Configuration` class from the `DomBasedXssQuery.qll`, use the `DomBasedXssFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ExceptionXssQuery.qll`, use the `ExceptionXssFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ExternalAPIUsedWithUntrustedDataQuery.qll`, use the `ExternalAPIUsedWithUntrustedDataFlow` module instead.
* Deleted the deprecated `Configuration` class from the `FileAccessToHttpQuery.qll`, use the `FileAccessToHttpFlow` module instead.
* Deleted the deprecated `Configuration` class from the `HardcodedCredentialsQuery.qll`, use the `HardcodedCredentials` module instead.
* Deleted the deprecated `Configuration` class from the `HardcodedDataInterpretedAsCodeQuery.qll`, use the `HardcodedDataInterpretedAsCodeFlow` module instead.
* Deleted the deprecated `Configuration` class from the `HostHeaderPoisoningInEmailGenerationQuery.qll`, use the `HostHeaderPoisoningFlow` module instead.
* Deleted the deprecated `Configuration` class from the `HttpToFileAccessQuery.qll`, use the `HttpToFileAccessFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ImproperCodeSanitizationQuery.qll`, use the `ImproperCodeSanitizationFlow` module instead.
* Deleted the deprecated `Configuration` class from the `IncompleteHtmlAttributeSanitizationQuery.qll`, use the `IncompleteHtmlAttributeSanitizationFlow` module instead.
* Deleted the deprecated `Configuration` class from the `IndirectCommandInjectionQuery.qll`, use the `IndirectCommandInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `InsecureDownloadQuery.qll`, use the `InsecureDownload` module instead.
* Deleted the deprecated `Configuration` class from the `InsecureRandomnessQuery.qll`, use the `InsecureRandomnessFlow` module instead.
* Deleted the deprecated `Configuration` class from the `InsufficientPasswordHashQuery.qll`, use the `InsufficientPasswordHashFlow` module instead.
* Deleted the deprecated `Configuration` class from the `LogInjectionQuery.qll`, use the `LogInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `LoopBoundInjectionQuery.qll`, use the `LoopBoundInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `NosqlInjectionQuery.qll`, use the `NosqlInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `PostMessageStarQuery.qll`, use the `PostMessageStarFlow` module instead.
* Deleted the deprecated `Configuration` class from the `PrototypePollutingAssignmentQuery.qll`, use the `PrototypePollutingAssignmentFlow` module instead.
* Deleted the deprecated `Configuration` class from the `PrototypePollutionQuery.qll`, use the `PrototypePollutionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `RegExpInjectionQuery.qll`, use the `RegExpInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `RemotePropertyInjectionQuery.qll`, use the `RemotePropertyInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `RequestForgeryQuery.qll`, use the `RequestForgeryFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ResourceExhaustionQuery.qll`, use the `ResourceExhaustionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `SecondOrderCommandInjectionQuery.qll`, use the `SecondOrderCommandInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ShellCommandInjectionFromEnvironmentQuery.qll`, use the `ShellCommandInjectionFromEnvironmentFlow` module instead.
* Deleted the deprecated `Configuration` class from the `SqlInjectionQuery.qll`, use the `SqlInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `StackTraceExposureQuery.qll`, use the `StackTraceExposureFlow` module instead.
* Deleted the deprecated `Configuration` class from the `StoredXssQuery.qll`, use the `StoredXssFlow` module instead.
* Deleted the deprecated `Configuration` class from the `TaintedFormatStringQuery.qll`, use the `TaintedFormatStringFlow` module instead.
* Deleted the deprecated `BarrierGuardNode` class from the `TaintedPathCustomizations.qll`.
* Deleted the deprecated `Configuration` class from the `TaintedPathQuery.qll`, use the `TaintedPathFlow` module instead.
* Deleted the deprecated `Configuration` class from the `TemplateObjectInjectionQuery.qll`, use the `TemplateObjInjectionConfig` module instead.
* Deleted the deprecated `Configuration` class from the `TypeConfusionThroughParameterTamperingQuery.qll`, use the `TypeConfusionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `UnsafeCodeConstruction.qll`, use the `UnsafeCodeConstructionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `UnsafeDeserializationQuery.qll`, use the `UnsafeDeserializationFlow` module instead.
* Deleted the deprecated `Configuration` class from the `UnsafeDynamicMethodAccessQuery.qll`, use the `UnsafeDynamicMethodAccessFlow` module instead.
* Deleted the deprecated `Configration` class from the `UnsafeHtmlConstructionQuery.qll`.
* Deleted the deprecated `Configuration` class from the `UnsafeJQueryPluginQuery.qll`, use the `UnsafeJQueryPluginFlow` module instead.
* Deleted the deprecated `Configuration` class from the `UnsafeShellCommandConstructionQuery.qll`, use the `UnsafeShellCommandConstructionFlow` module instead.
* Deleted the deprecated `sanitizes` predicate from the `UnvalidatedDynamicMethodCallCustomizations.qll`.
* Deleted the deprecated `Configuration` class from the `UnvalidatedDynamicMethodCallQuery.qll`, use the `UnvalidatedDynamicMethodCallFlow` module instead.
* Deleted the deprecated `Configuration` class from the `XmlBombQuery.qll`, use the `XmlBombFlow` module instead.
* Deleted the deprecated `Configuration` class from the `XpathInjectionQuery.qll`, use the `XpathInjectionFlow` module instead.
* Deleted the deprecated `Configuration` class from the `XssThroughDomQuery.qll`, use the `XssThroughDomFlow` module instead.
* Deleted the deprecated `Configuration` class from the `XxeQuery.qll`, use the `XxeFlow` module instead.
* Deleted the deprecated `Configuration` class from the `ZipSlipQuery.qll`.
* Deleted the deprecated `Configuration` class from the `PolynomialReDoSQuery.qll`, use the `PolynomialReDoSFlow` module instead.
* Deleted the deprecated `Configuration` class from the `SSRF.qll`, use the `SsrfFlow` module instead.
