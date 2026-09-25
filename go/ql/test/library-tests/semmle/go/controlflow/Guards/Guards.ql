import go
import semmle.go.controlflow.Guards

predicate sinkCall(DataFlow::CallNode call, string label) {
  call.getTarget().getName() = "sink" and
  label = call.getArgument(0).getExactValue()
}

query predicate controlsResult(Guard guard, string label, string outcome) {
  exists(DataFlow::CallNode call, boolean branch |
    sinkCall(call, label) and
    guard.controls(call.getBasicBlock(), branch) and
    outcome = branch.toString()
  )
}

query predicate valueControlsResult(Guard guard, string label, string outcome) {
  exists(DataFlow::CallNode call, GuardValue value |
    sinkCall(call, label) and
    guard.valueControls(call.getBasicBlock(), value) and
    outcome = value.toString()
  )
}

query predicate ensuresEqResult(Guard guard, string label, string outcome) {
  exists(boolean branch, DataFlow::Node left, DataFlow::Node right |
    guardEnsuresEq(guard, branch, left, right) and
    label = left.toString() + " = " + right.toString() and
    outcome = branch.toString()
  )
}
