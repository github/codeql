import javascript

class Config extends DataFlow::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode call | call.getCalleeName() = "sink" | call.getAnArgument() = sink)
  }
}

query predicate dataFlow(DataFlow::Node pred, DataFlow::Node succ) {
  any(Config c).hasFlow(pred, succ)
}

DataFlow::SourceNode trackSource(DataFlow::TypeTracker t, DataFlow::SourceNode start) {
  t.start() and
  result.(DataFlow::CallNode).getCalleeName() = "source" and
  start = result
  or
  exists(DataFlow::TypeTracker t2 | t = t2.step(trackSource(t2, start), result))
}

query DataFlow::SourceNode typeTracking(DataFlow::Node start) {
  result = trackSource(DataFlow::TypeTracker::end(), start)
}
