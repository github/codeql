import go

query predicate edges(ControlFlow::Node pred, ControlFlow::Node succ) {
  not succ.getFile().hasBuildConstraints() and
  not pred.getFile().hasBuildConstraints() and
  succ = pred.getASuccessor()
}

select ""
