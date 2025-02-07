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
 import codeql.actions.security.MinimumActionsPermissions

 // Returns the minimum permissions for all of the uses steps
 // that are children of the job separated by a comma
 // e.g. "contents: read, packages: write".  If we cannot determine
 // the permission we fallback to "unknown"
 string getMinPermissions(Job job) {
   if unknownPermissions(job) = true then result = "unknown" else
   result = minPermissions(job)
 }

 string minPermissions(Job job) {
   result = concat(job.getAChildNode*().(MinimumActionsPermissions).getMinimumPermissions(), ", ")
 }

 // Holds if we cannot determine the permissions for the uses step
 // using the data extension or there are no uses steps
 // that are children of the job
 boolean unknownPermissions(Job job) {
    minPermissions(job) = "" and result = true or count(job.getAChildNode*().(MinimumActionsPermissions)) = 0 and result = true
 }

 from Job job
 where
   not exists(job.getPermissions()) and
   not exists(job.getEnclosingWorkflow().getPermissions()) and
   // exists a trigger event that is not a workflow_call
   exists(Event e |
     e = job.getATriggerEvent() and
     not e.getName() = "workflow_call"
   )
 select job,
 "Actions Job or Workflow does not set permissions. Recommended minimum permissions are ($@)",
 job, getMinPermissions(job)
