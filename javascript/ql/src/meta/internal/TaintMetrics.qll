/**
 * Provides predicates for measuring taint-tracking coverage.
 */

private import javascript
import meta.MetaMetrics
private import semmle.javascript.security.dataflow.ClientSideUrlRedirectCustomizations
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations
private import semmle.javascript.security.dataflow.CommandInjectionCustomizations
private import semmle.javascript.security.dataflow.Xss as Xss
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
private import semmle.javascript.security.dataflow.PrototypePollutionCustomizations
private import semmle.javascript.security.dataflow.RegExpInjectionCustomizations
private import semmle.javascript.security.dataflow.RequestForgeryCustomizations
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations
private import semmle.javascript.security.dataflow.TaintedPathCustomizations
private import semmle.javascript.security.dataflow.UnsafeDeserializationCustomizations
private import semmle.javascript.security.dataflow.XmlBombCustomizations
private import semmle.javascript.security.dataflow.XpathInjectionCustomizations
private import semmle.javascript.security.dataflow.XxeCustomizations
private import semmle.javascript.security.dataflow.ZipSlipCustomizations

/**
 * Gets a relevant taint sink.
 *
 * To ensure this metric isn't dominated by a few queries with a huge number of sinks,
 * we only include sinks for queries that have fairly specific sinks and/or have high severity
 * relative to the number of sinks.
 *
 * Examples of excluded queries:
 * - UnsafeDynamicMethodAccess: high severity (RCE) but has way too many sinks (every callee).
 * - ClearTextLogging: not severe enough relative to number of sinks.
 */
DataFlow::Node relevantTaintSink() {
  not result.getFile() instanceof IgnoredFile and
  (
    result instanceof ClientSideUrlRedirect::Sink or
    result instanceof CodeInjection::Sink or
    result instanceof CommandInjection::Sink or
    result instanceof Xss::Shared::Sink or
    result instanceof NosqlInjection::Sink or
    result instanceof PrototypePollution::Sink or
    result instanceof RegExpInjection::Sink or
    result instanceof RequestForgery::Sink or
    result instanceof ServerSideUrlRedirect::Sink or
    result instanceof SqlInjection::Sink or
    result instanceof TaintedPath::Sink or
    result instanceof UnsafeDeserialization::Sink or
    result instanceof XmlBomb::Sink or
    result instanceof XpathInjection::Sink or
    result instanceof Xxe::Sink or
    result instanceof ZipSlip::Sink
  )
}

/**
 * Gets a remote flow source or `document.location` source.
 */
DataFlow::Node relevantTaintSource() {
  not result.getFile() instanceof IgnoredFile and
  (
    result instanceof RemoteFlowSource
    or
    result = DOM::locationSource()
  )
}

/**
 * Gets the output of a call that shows intent to sanitize a value
 * (indicating a likely vulnerability if the sanitizer was removed).
 *
 * Currently we only recognize HTML sanitizers.
 */
DataFlow::Node relevantSanitizerOutput() {
  result = any(HtmlSanitizerCall call) and
  not result.getFile() instanceof IgnoredFile
}

/**
 * Gets the input to a call that shows intent to sanitize a value
 * (indicating a likely vulnerability if the sanitizer was removed).
 *
 * Currently we only recognize HTML sanitizers.
 */
DataFlow::Node relevantSanitizerInput() {
  result = any(HtmlSanitizerCall call).getInput() and
  not result.getFile() instanceof IgnoredFile
}
