/**
 * @name Workflow does not contain permissions
 * @description Workflows should contain permissions to provide a clear understanding has permissions to run the workflow.
 * @kind problem
 * @security-severity 5.0
 * @problem.severity recommendation
 * @precision high
 * @id actions/missing-workflow-permissions
 * @tags actions
 *       maintainability
 *       external/cwe/cwe-275
 */

import actions

from Job job
where
  not exists(job.getPermissions()) and
  not exists(job.getEnclosingWorkflow().getPermissions()) and
  // exists a trigger event that is not a workflow_call
  exists(Event e |
    e = job.getATriggerEvent() and
    not e.getName() = "workflow_call"
  )
select job, "Actions Job or Workflow does not set permissions"
