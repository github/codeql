import csharp
import semmle.code.csharp.dataflow.internal.ContentDataFlow

class Conf extends ContentDataFlow::Configuration {
  Conf() { this = "ContentFlowConf" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasUndecoratedName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }

  override int accessPathLimit() { result = 2 }
}

from
  Conf conf, ContentDataFlow::Node source, ContentDataFlow::AccessPath sourceAp,
  ContentDataFlow::Node sink, ContentDataFlow::AccessPath sinkAp, boolean preservesValue
where conf.hasFlow(source, sourceAp, sink, sinkAp, preservesValue)
select source, sourceAp, sink, sinkAp, preservesValue
