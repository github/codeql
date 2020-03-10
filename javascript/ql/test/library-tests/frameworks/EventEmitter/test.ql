import javascript

query predicate taintSteps(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::AdditionalFlowStep step | step.step(pred, succ))
}
