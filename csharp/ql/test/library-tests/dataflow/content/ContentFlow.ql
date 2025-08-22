import csharp
import semmle.code.csharp.dataflow.internal.ContentDataFlow as ContentDataFlow

module ContentConfig implements ContentDataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasUndecoratedName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }

  int accessPathLimit() { result = 2 }
}

module ContentFlow = ContentDataFlow::Global<ContentConfig>;

from
  DataFlow::Node source, ContentFlow::AccessPath sourceAp, DataFlow::Node sink,
  ContentFlow::AccessPath sinkAp, boolean preservesValue
where ContentFlow::flow(source, sourceAp, sink, sinkAp, preservesValue)
select source, sourceAp, sink, sinkAp, preservesValue
