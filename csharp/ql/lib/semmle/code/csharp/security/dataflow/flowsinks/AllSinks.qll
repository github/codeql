/** Provides classes representing various flow sinks for data flow / taint tracking. */

private import semmle.code.csharp.dataflow.internal.ExternalFlow

/**
 * A data flow sink node.
 */
abstract class SinkNode extends DataFlow::Node { }

/**
 * Module that adds all sinks to `SinkNode`, excluding sinks for cryptography based
 * queries, and queries where sinks are not succifiently explicit.
 */
private module AllSinks {
  private import ParallelSink as ParallelSink
  private import Remote as Remote
  private import semmle.code.csharp.security.dataflow.CodeInjectionQuery as CodeInjectionQuery
  private import semmle.code.csharp.security.dataflow.ConditionalBypassQuery as ConditionalBypassQuery
  private import semmle.code.csharp.security.dataflow.ExposureOfPrivateInformationQuery as ExposureOfPrivateInformationQuery
  private import semmle.code.csharp.security.dataflow.HardcodedCredentialsQuery as HardcodedCredentialsQuery
  private import semmle.code.csharp.security.dataflow.LDAPInjectionQuery as LdapInjectionQuery
  private import semmle.code.csharp.security.dataflow.LogForgingQuery as LogForgingQuery
  private import semmle.code.csharp.security.dataflow.MissingXMLValidationQuery as MissingXmlValidationQuery
  private import semmle.code.csharp.security.dataflow.ReDoSQuery as ReDosQuery
  private import semmle.code.csharp.security.dataflow.RegexInjectionQuery as RegexInjectionQuery
  private import semmle.code.csharp.security.dataflow.ResourceInjectionQuery as ResourceInjectionQuery
  private import semmle.code.csharp.security.dataflow.SqlInjectionQuery as SqlInjectionQuery
  private import semmle.code.csharp.security.dataflow.TaintedPathQuery as TaintedPathQuery
  private import semmle.code.csharp.security.dataflow.UnsafeDeserializationQuery as UnsafeDeserializationQuery
  private import semmle.code.csharp.security.dataflow.UrlRedirectQuery as UrlRedirectQuery
  private import semmle.code.csharp.security.dataflow.XMLEntityInjectionQuery as XmlEntityInjectionQuery
  private import semmle.code.csharp.security.dataflow.XPathInjectionQuery as XpathInjectionQuery
  private import semmle.code.csharp.security.dataflow.XSSSinks as XssSinks
  private import semmle.code.csharp.security.dataflow.ZipSlipQuery as ZipSlipQuery

  private class ParallelSink extends SinkNode instanceof ParallelSink::ParallelSink { }

  private class RemoteSinkFlowSinks extends SinkNode instanceof Remote::RemoteFlowSink { }

  private class CodeInjectionSink extends SinkNode instanceof CodeInjectionQuery::Sink { }

  private class ConditionalBypassSink extends SinkNode instanceof ConditionalBypassQuery::Sink { }

  private class ExposureOfPrivateInformationSink extends SinkNode instanceof ExposureOfPrivateInformationQuery::Sink
  { }

  private class HardcodedCredentialsSink extends SinkNode instanceof HardcodedCredentialsQuery::Sink
  { }

  private class LdapInjectionSink extends SinkNode instanceof LdapInjectionQuery::Sink { }

  private class LogForgingSink extends SinkNode instanceof LogForgingQuery::Sink { }

  private class MissingXmlValidationSink extends SinkNode instanceof MissingXmlValidationQuery::Sink
  { }

  private class ReDosSink extends SinkNode instanceof ReDosQuery::Sink { }

  private class RegexInjectionSink extends SinkNode instanceof RegexInjectionQuery::Sink { }

  private class ResourceInjectionSink extends SinkNode instanceof ResourceInjectionQuery::Sink { }

  private class SqlInjectionSink extends SinkNode instanceof SqlInjectionQuery::Sink { }

  private class TaintedPathSink extends SinkNode instanceof TaintedPathQuery::Sink { }

  private class UnsafeDeserializationSink extends SinkNode instanceof UnsafeDeserializationQuery::Sink
  { }

  private class UrlRedirectSink extends SinkNode instanceof UrlRedirectQuery::Sink { }

  private class XmlEntityInjectionSink extends SinkNode instanceof XmlEntityInjectionQuery::Sink { }

  private class XpathInjectionSink extends SinkNode instanceof XpathInjectionQuery::Sink { }

  private class XssSink extends SinkNode instanceof XssSinks::Sink { }

  /**
   * Add all models as data sinks.
   */
  private class SinkNodeExternal extends SinkNode {
    SinkNodeExternal() { sinkNode(this, _) }
  }
}
