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

from LocalJob job, ArtifactDownloadStep download, Step run
where
  job.getWorkflow().getATriggerEvent() = ["workflow_run", "workflow_dispatch"] and
  (run instanceof Run or run instanceof UsesStep) and
  exists(int i, int j |
    job.getStep(i) = download and
    job.getStep(j) = run and
    i < j
  )
select download, "Potential artifact poisoning."
