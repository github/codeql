import javascript

query predicate taintSteps(DataFlow::Node pred, DataFlow::Node succ) {
  DataFlow::SharedFlowStep::step(pred, succ)
}

query predicate eventEmitter(EventEmitter e) { any() }
