/**
 * Provides predicates that expose the knowledge of models
 * in the core CodeQL JavaScript libraries.
 */

private import javascript
private import semmle.javascript.security.dataflow.XxeCustomizations
private import semmle.javascript.security.dataflow.RemotePropertyInjectionCustomizations
private import semmle.javascript.security.dataflow.TypeConfusionThroughParameterTamperingCustomizations
private import semmle.javascript.security.dataflow.ZipSlipCustomizations
private import semmle.javascript.security.dataflow.TaintedPathCustomizations
private import semmle.javascript.security.dataflow.CleartextLoggingCustomizations
private import semmle.javascript.security.dataflow.XpathInjectionCustomizations
private import semmle.javascript.security.dataflow.Xss::Shared as Xss
private import semmle.javascript.security.dataflow.StackTraceExposureCustomizations
private import semmle.javascript.security.dataflow.ClientSideUrlRedirectCustomizations
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations
private import semmle.javascript.security.dataflow.RequestForgeryCustomizations
private import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentialsCustomizations
private import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentCustomizations
private import semmle.javascript.security.dataflow.DifferentKindsComparisonBypassCustomizations
private import semmle.javascript.security.dataflow.CommandInjectionCustomizations
private import semmle.javascript.security.dataflow.PrototypePollutionCustomizations
private import semmle.javascript.security.dataflow.UnvalidatedDynamicMethodCallCustomizations
private import semmle.javascript.security.dataflow.TaintedFormatStringCustomizations
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
private import semmle.javascript.security.dataflow.PostMessageStarCustomizations
private import semmle.javascript.security.dataflow.RegExpInjectionCustomizations
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations
private import semmle.javascript.security.dataflow.InsecureRandomnessCustomizations
private import semmle.javascript.security.dataflow.XmlBombCustomizations
private import semmle.javascript.security.dataflow.InsufficientPasswordHashCustomizations
private import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations
private import semmle.javascript.security.dataflow.HardcodedCredentialsCustomizations
private import semmle.javascript.security.dataflow.FileAccessToHttpCustomizations
private import semmle.javascript.security.dataflow.UnsafeDynamicMethodAccessCustomizations
private import semmle.javascript.security.dataflow.UnsafeDeserializationCustomizations
private import semmle.javascript.security.dataflow.HardcodedDataInterpretedAsCodeCustomizations
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
private import semmle.javascript.security.dataflow.IndirectCommandInjectionCustomizations
private import semmle.javascript.security.dataflow.ConditionalBypassCustomizations
private import semmle.javascript.security.dataflow.HttpToFileAccessCustomizations
private import semmle.javascript.security.dataflow.BrokenCryptoAlgorithmCustomizations
private import semmle.javascript.security.dataflow.LoopBoundInjectionCustomizations
private import semmle.javascript.security.dataflow.CleartextStorageCustomizations

/**
 * Holds if the node `n` is a known sink in a modeled library.
 */
predicate isKnownLibrarySink(DataFlow::Node n) {
  n instanceof Xxe::Sink or
  n instanceof ZipSlip::Sink or
  n instanceof TaintedPath::Sink or
  n instanceof CleartextLogging::Sink or
  n instanceof XpathInjection::Sink or
  n instanceof Xss::Sink or
  n instanceof StackTraceExposure::Sink or
  n instanceof ClientSideUrlRedirect::Sink or
  n instanceof CodeInjection::Sink or
  n instanceof RequestForgery::Sink or
  n instanceof CorsMisconfigurationForCredentials::Sink or
  n instanceof ShellCommandInjectionFromEnvironment::Sink or
  n instanceof CommandInjection::Sink or
  n instanceof PrototypePollution::Sink or
  n instanceof UnvalidatedDynamicMethodCall::Sink or
  n instanceof TaintedFormatString::Sink or
  n instanceof NosqlInjection::Sink or
  n instanceof PostMessageStar::Sink or
  n instanceof RegExpInjection::Sink or
  n instanceof SqlInjection::Sink or
  n instanceof InsecureRandomness::Sink or
  n instanceof XmlBomb::Sink or
  n instanceof FileAccessToHttp::Sink or
  n instanceof UnsafeDeserialization::Sink or
  n instanceof ServerSideUrlRedirect::Sink or
  n instanceof IndirectCommandInjection::Sink or
  n instanceof HttpToFileAccess::Sink or
  n instanceof CleartextStorage::Sink
}

/**
 * Holds if the node `n` is known as the predecessor in a modeled flow step.
 */
predicate isKnownStepSrc(DataFlow::Node n) {
  any(TaintTracking::AdditionalTaintStep s).step(n, _) or
  any(DataFlow::AdditionalFlowStep s).step(n, _) or
  any(DataFlow::AdditionalFlowStep s).step(n, _, _, _)
}

/**
 * Holds if the node `n` is an unlikely sink for a security query.
 */
predicate isUnlikelySink(DataFlow::Node n) {
  any(LodashUnderscore::Member m).getACall().getAnArgument() = n
  or
  exists(ClientRequest r |
    r.getAnArgument() = n or n = r.getUrl() or n = r.getHost() or n = r.getADataNode()
  )
  or
  exists(DataFlow::CallNode call |
    n = call.getAnArgument() and
    // Heuristically remove calls that look like logging calls
    call.getCalleeName() = getAStandardLoggerMethodName()
  )
  or
  exists(PromiseDefinition p |
    n = [p.getResolveParameter(), p.getRejectParameter()].getACall().getAnArgument()
  )
  or
  n instanceof CryptographicKey or
  exists(DataFlow::CallNode call | n = call.getAnArgument() |
    exists(string name | name = call.getCalleeName() |
      name.regexpMatch("(?i).*(escape|validate|sanitize|purify).*") or
      name =
        ["indexOf", "hasOwnProperty", "substring", "isDecimal", "decode", "encode", "keys",
            "values", "forEach", "toString", "slice", "splice", "push", "isArray"]
    )
    or
    exists(DataFlow::SourceNode builtin |
      builtin = DataFlow::globalVarRef(["Object", "Array", "Number", "String", "Error", "Math"])
    |
      builtin.getAMemberCall(_) = call or builtin.getAnInvocation() = call
    )
    or
    any(DataFlow::ArrayCreationNode a).getAMethodCall() = call
    or
    call instanceof StringOps::StartsWith
    or
    call instanceof StringOps::EndsWith
    or
    call instanceof StringOps::RegExpTest
    or
    call instanceof EventRegistration
    or
    call instanceof EventDispatch
    or
    call = any(MembershipCandidate c).getTest()
  )
}
