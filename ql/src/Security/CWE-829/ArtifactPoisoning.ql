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

from LocalJob job, ArtifactDownloadStep downloadStep, PoisonableStep step
where
  // Workflow is privileged
  job.getWorkflow().isPrivileged() and
  // Download step is followed by a step that may be poisoned by the download
  downloadStep.getAFollowingStep() = step
select downloadStep, "Potential artifact poisoning."
