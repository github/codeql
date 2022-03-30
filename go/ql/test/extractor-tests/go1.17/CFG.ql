import go

query predicate nodes(ControlFlow::Node nd) { none() }

query predicate edges(ControlFlow::Node pred, ControlFlow::Node succ) {
  succ = pred.getASuccessor()
}

select ""
