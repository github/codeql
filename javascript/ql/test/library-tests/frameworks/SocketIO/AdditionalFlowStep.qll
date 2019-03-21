import javascript

query predicate test_AdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::AdditionalFlowStep step | step.step(pred, succ) | any())
}
