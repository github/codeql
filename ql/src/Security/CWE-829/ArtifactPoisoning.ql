/**
 * @name Artifact poisoning
 * @description An attacker may be able to poison the workflow's artifacts and influence on consequent steps.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @security-severity 9.3
 * @id actions/artifact-poisoning
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.ArtifactPoisoningQuery

predicate isSingleTriggerWorkflow(Workflow w, string trigger) {
  w.getATriggerEvent() = trigger and
  count(string t | w.getATriggerEvent() = t | t) = 1
}

from Workflow w, LocalJob job, ArtifactDownloadStep download, Step run
where
  w = job.getWorkflow() and
  (
    // The Workflow is triggered by an event other than `pull_request`
    not isSingleTriggerWorkflow(w, "pull_request")
    or
    // The Workflow is only triggered by `workflow_call` and there is
    // a caller workflow triggered by an event other than `pull_request`
    isSingleTriggerWorkflow(w, "workflow_call") and
    exists(ExternalJob call, Workflow caller |
      call.getCallee() = w.getLocation().getFile().getRelativePath() and
      caller = call.getWorkflow() and
      not isSingleTriggerWorkflow(caller, "pull_request")
    )
  ) and
  (run instanceof Run or run instanceof UsesStep) and
  exists(int i, int j |
    job.getStep(i) = download and
    job.getStep(j) = run and
    i < j
  )
select download, "Potential artifact poisoning."
