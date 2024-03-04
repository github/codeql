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
 *       external/cwe/cwe-275
 */

import actions

from Workflow workflow, Job job
where
  job = workflow.getAJob() and
  (
    not exists(workflow.getPermissions()) and
    not exists(job.getPermissions())
  )
select job, "Actions Job or Workflow does not set permissions"
