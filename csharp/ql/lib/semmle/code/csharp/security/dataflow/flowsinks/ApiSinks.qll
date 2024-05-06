/** Provides classes representing various flow sinks for data flow / taint tracking. */

private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks

/**
 * A data flow sink node.
 */
final class SinkNode = ApiSinkNode;

/**
 * Module that adds all API like sinks to `SinkNode`, excluding sinks for cryptography based
 * queries, and queries where sinks are not sufficiently defined (eg. using broad method name matching).
 */
private module AllApiSinks {
  private import ParallelSink
  private import Remote
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
  private import semmle.code.csharp.security.dataflow.ZipSlipQuery as ZipSlipQuery
}
