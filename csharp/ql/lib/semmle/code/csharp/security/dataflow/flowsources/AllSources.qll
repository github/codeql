/** Provides classes representing various flow sources for data flow / taint tracking. */

private import semmle.code.csharp.dataflow.internal.ExternalFlow

/**
 * A data flow source node.
 */
abstract class SourceNode extends DataFlow::Node { }

/**
 * Module that adds all sources to `SourceNode`, excluding source for cryptography based
 * queries, and queries where sources are not succifiently explicit or mainly hardcoded constants.
 */
private module AllSources {
  private import FlowSources as FlowSources
  private import semmle.code.csharp.security.cryptography.HardcodedSymmetricEncryptionKey
  private import semmle.code.csharp.security.dataflow.CleartextStorageQuery as CleartextStorageQuery
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

  private class FlowSourcesSources extends SourceNode instanceof FlowSources::SourceNode { }

  private class CodeInjectionSource extends SourceNode instanceof CodeInjectionQuery::Source { }

  private class ConditionalBypassSource extends SourceNode instanceof ConditionalBypassQuery::Source
  { }

  private class LdapInjectionSource extends SourceNode instanceof LdapInjectionQuery::Source { }

  private class LogForgingSource extends SourceNode instanceof LogForgingQuery::Source { }

  private class MissingXmlValidationSource extends SourceNode instanceof MissingXmlValidationQuery::Source
  { }

  private class ReDosSource extends SourceNode instanceof ReDosQuery::Source { }

  private class RegexInjectionSource extends SourceNode instanceof RegexInjectionQuery::Source { }

  private class ResourceInjectionSource extends SourceNode instanceof ResourceInjectionQuery::Source
  { }

  private class SqlInjectionSource extends SourceNode instanceof SqlInjectionQuery::Source { }

  private class TaintedPathSource extends SourceNode instanceof TaintedPathQuery::Source { }

  private class UnsafeDeserializationSource extends SourceNode instanceof UnsafeDeserializationQuery::Source
  { }

  private class UrlRedirectSource extends SourceNode instanceof UrlRedirectQuery::Source { }

  private class XmlEntityInjectionSource extends SourceNode instanceof XmlEntityInjectionQuery::Source
  { }

  private class XpathInjectionSource extends SourceNode instanceof XpathInjectionQuery::Source { }

  /**
   * Add all models as data sources.
   */
  private class SourceNodeExternal extends SourceNode {
    SourceNodeExternal() { sourceNode(this, _) }
  }
}
