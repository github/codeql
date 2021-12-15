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
 *
 * `kind` is bound to the name of the module containing the query sinks.
 */
DataFlow::Node relevantTaintSink(string kind) {
  not result.getFile() instanceof IgnoredFile and
  (
    kind = "ClientSideUrlRedirect" and result instanceof ClientSideUrlRedirect::Sink
    or
    kind = "CodeInjection" and result instanceof CodeInjection::Sink
    or
    kind = "CommandInjection" and result instanceof CommandInjection::Sink
    or
    kind = "Xss" and result instanceof Xss::Shared::Sink
    or
    kind = "NosqlInjection" and result instanceof NosqlInjection::Sink
    or
    kind = "PrototypePollution" and result instanceof PrototypePollution::Sink
    or
    kind = "RegExpInjection" and result instanceof RegExpInjection::Sink
    or
    kind = "RequestForgery" and result instanceof RequestForgery::Sink
    or
    kind = "ServerSideUrlRedirect" and result instanceof ServerSideUrlRedirect::Sink
    or
    kind = "SqlInjection" and result instanceof SqlInjection::Sink
    or
    kind = "TaintedPath" and result instanceof TaintedPath::Sink
    or
    kind = "UnsafeDeserialization" and result instanceof UnsafeDeserialization::Sink
    or
    kind = "XmlBomb" and result instanceof XmlBomb::Sink
    or
    kind = "XpathInjection" and result instanceof XpathInjection::Sink
    or
    kind = "Xxe" and result instanceof Xxe::Sink
    or
    kind = "ZipSlip" and result instanceof ZipSlip::Sink
  )
}

/** Gets a relevant taint sink. See `relevantTaintSink/1` for more information. */
DataFlow::Node relevantTaintSink() { result = relevantTaintSink(_) }

/**
 * Gets a relevant remote flow source.
 */
RemoteFlowSource relevantTaintSource() { not result.getFile() instanceof IgnoredFile }

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
