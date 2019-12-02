import javascript

query predicate taintSteps(DataFlow::Node pred, DataFlow::Node succ) {
  any(EventEmitter::EventEmitterTaintStep step).step(pred, succ)
}

