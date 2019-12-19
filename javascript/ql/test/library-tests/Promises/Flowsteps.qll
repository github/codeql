import javascript

query predicate flowSteps(DataFlow::Node pred, DataFlow::Node succ) {
  any(DataFlow::AdditionalFlowStep step).step(pred, succ)	
}