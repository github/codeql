import experimental.dataflow.DataFlow
private import experimental.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * A configuration to find the call graph edges.
 */
class CallGraphConfig extends DataFlow::Configuration {
  CallGraphConfig() { this = "CallGraphConfig" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof DataFlowPrivate::ReturnNode
    or
    // These sources should allow for the non-standard call syntax
    node instanceof DataFlowPrivate::ArgumentNode
  }

  override predicate isSink(DataFlow::Node node) {
    node instanceof DataFlowPrivate::OutNode
    or
    node instanceof DataFlow::ParameterNode and
    // exclude parameters to the SINK-functions
    not exists(DataFlowPrivate::DataFlowCallable c |
      node.(DataFlow::ParameterNode).isParameterOf(c, _) and
      c.getName().matches("SINK_")
    )
  }
}

from DataFlow::Node source, DataFlow::Node sink
where
  source.getLocation().getFile().getBaseName() = "classes.py" and
  sink.getLocation().getFile().getBaseName() = "classes.py" and
  exists(CallGraphConfig cfg | cfg.hasFlow(source, sink))
select source, sink
// Ideally, we would just have 1-step paths either from argument to parameter
// or from return to call. This gives a bit more, so should be rewritten.
// We should also consider splitting this into two, one for each direction.
