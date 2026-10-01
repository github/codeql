import actions

from ReusableWorkflow workflow, ExternalJob caller, LocalJob job, Event event
where
  workflow.getACaller() = caller and
  job.getEnclosingWorkflow() = workflow and
  caller.getATriggerEvent() = event and
  job.getATriggerEvent() = event
select workflow, caller, job, event.getName()
