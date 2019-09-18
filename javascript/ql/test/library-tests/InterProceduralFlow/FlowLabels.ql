import javascript

class Parity extends DataFlow::FlowLabel {
  Parity() { this = "even" or this = "odd" }

  Parity flip() { result != this }
}

class Config extends DataFlow::Configuration {
  Config() { this = "config" }

  override predicate isSource(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd.(DataFlow::CallNode).getCalleeName() = "source" and
    lbl = "even"
  }

  override predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getAnArgument() and
    lbl = "even"
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predLabel,
    DataFlow::FlowLabel succLabel
  ) {
    exists(DataFlow::CallNode c | c = succ |
      c.getCalleeName() = "inc" and
      pred = c.getAnArgument() and
      succLabel = predLabel.(Parity).flip()
    )
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source, sink
