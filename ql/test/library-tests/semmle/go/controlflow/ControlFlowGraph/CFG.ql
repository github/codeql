import go

query predicate nodes(ControlFlow::Node nd) { none() }

query predicate edges(ControlFlow::Node pred, ControlFlow::Node succ) {
  none()
  // succ = pred.getASuccessor()
}

select ""
