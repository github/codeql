/**
 * @name Workflow does not contain permissions
 * @description Workflows should contain explicit permissions to restrict the scope of the default GITHUB_TOKEN.
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

string jobNeedsPermission(Job job) {
  actionsPermissionsDataModel(stepInJob(job).(UsesStep).getCallee(), result)
}

/** Gets a suggestion for the minimal token permissions for `job`, as a JSON string. */
string permissionsForJob(Job job) {
  result =
    "{" + concat(string permission | permission = jobNeedsPermission(job) | permission, ", ") + "}"
}

predicate jobHasPermissions(Job job) {
  exists(job.getPermissions())
  or
  exists(job.getEnclosingWorkflow().getPermissions())
  or
  // The workflow is reusable and cannot be triggered in any other way; check callers
  exists(ReusableWorkflow r | r = job.getEnclosingWorkflow() |
    not exists(Event e | e = r.getOn().getAnEvent() | e.getName() != "workflow_call") and
    forall(Job caller | caller = job.getEnclosingWorkflow().(ReusableWorkflow).getACaller() |
      jobHasPermissions(caller)
    )
  )
}

from Job job, string permissions
where
  not jobHasPermissions(job) and
  // exists a trigger event that is not a workflow_call
  exists(Event e |
    e = job.getATriggerEvent() and
    not e.getName() = "workflow_call"
  ) and
  permissions = permissionsForJob(job)
select job,
  "Actions job or workflow does not limit the permissions of the GITHUB_TOKEN. Consider setting an explicit permissions block, using the following as a minimal starting point: "
    + permissions
