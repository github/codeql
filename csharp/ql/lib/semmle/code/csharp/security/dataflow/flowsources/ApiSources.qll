/** Provides classes representing various flow sources for data flow / taint tracking. */

private import FlowSources as FlowSources

final class SourceNode = FlowSources::SourceNode;

/**
 * Module that adds all API like sources to `SourceNode`, excluding some sources for cryptography based
 * queries, and queries where sources are not sufficiently defined (eg. using broad method name matching).
 */
private module AllApiSources {
  private import semmle.code.csharp.security.dataflow.ConditionalBypassQuery as ConditionalBypassQuery
  private import semmle.code.csharp.security.dataflow.ZipSlipQuery as ZipSlipQuery
}
