import javascript

query predicate test_AdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
  DataFlow::SharedFlowStep::step(pred, succ)
}
