private import csharp
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.frameworks.Test
private import ModelEditor

/**
 * A class of effectively public callables from source code.
 */
class PublicEndpointFromSource extends Endpoint {
  PublicEndpointFromSource() { this.fromSource() and not this.getFile() instanceof TestRelatedFile }

  override predicate isSource() { this instanceof SourceCallable }

  override predicate isSink() { this instanceof SinkCallable }
}
