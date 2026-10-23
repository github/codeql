import actions

query predicate callees(Uses uses, string callee) { uses.getCallee() = callee }

query predicate reusableWorkflowCallers(ReusableWorkflow workflow, ExternalJob caller, string event) {
  workflow.getACaller() = caller and
  exists(LocalJob job |
    job.getEnclosingWorkflow() = workflow and
    job.getATriggerEvent().getName() = event and
    caller.getATriggerEvent().getName() = event
  )
}

query predicate compositeActionCallers(CompositeAction action, UsesStep caller, string event) {
  action.getACallerStep() = caller and
  action.getATriggerEvent().getName() = event and
  caller.getATriggerEvent().getName() = event
}
