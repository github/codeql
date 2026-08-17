import go
import semmle.go.controlflow.Guards

predicate sinkCall(DataFlow::CallNode call, string label) {
  call.getTarget().getName() = "sink" and
  label = call.getArgument(0).getExactValue()
}

from Guard guard, DataFlow::CallNode call, string label, string outcome
where
  sinkCall(call, label) and
  (
    exists(boolean branch |
      guard.controls(call.getBasicBlock(), branch) and outcome = branch.toString()
    )
    or
    exists(GuardValue value |
      guard.valueControls(call.getBasicBlock(), value) and
      not exists(value.asBooleanValue()) and
      outcome = value.toString()
    )
  )
select guard, label, outcome
