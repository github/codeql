/**
 * @name Workflow does not contain permissions
 * @description Workflows should contain permissions to provide a clear understanding has permissions to run the workflow.
 * @kind problem
 * @security-severity 5.0
 * @problem.severity warning
 * @precision high
 * @id actions/missing-workflow-permissions
 * @tags actions
 *       maintainability
 *       security
 *       external/cwe/cwe-275
 */

import actions

Step stepInJob(Job job) { result = job.(LocalJob).getAStep() }

bindingset[fullActionSelector]
string versionedAction(string fullActionSelector) {
  result = fullActionSelector.substring(0, fullActionSelector.indexOf("@"))
  or
  not exists(fullActionSelector.indexOf("@")) and
  result = fullActionSelector
}

string stepUses(Step step) { result = step.getUses().(ScalarValue).getValue() }

string jobNeedsPersmission(Job job) {
  actionsPermissionsDataModel(versionedAction(stepUses(stepInJob(job))), result)
}

string permissionsForJob(Job job) {
  result =
    "{" + concat(string permission | permission = jobNeedsPersmission(job) | permission, ", ") + "}"
}

from Job job, string permissions
where
  not exists(job.getPermissions()) and
  not exists(job.getEnclosingWorkflow().getPermissions()) and
  // exists a trigger event that is not a workflow_call
  exists(Event e |
    e = job.getATriggerEvent() and
    not e.getName() = "workflow_call"
  ) and
  permissions = permissionsForJob(job)
select job,
  "Actions Job or Workflow does not set permissions. A minimal set might be " + permissions
