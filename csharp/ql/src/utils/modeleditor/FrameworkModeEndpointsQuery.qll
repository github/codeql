private import csharp
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.frameworks.Test
private import ModelEditor

class PublicEndpointFromSource extends Endpoint {
  PublicEndpointFromSource() { this.fromSource() and not this.getFile() instanceof TestFile }

  override predicate hasSummary() { this instanceof SummarizedCallable }

  override predicate isSource() { this instanceof SourceCallable }

  override predicate isSink() { this instanceof SinkCallable }
}
