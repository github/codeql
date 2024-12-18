/**
 * @name Cache Poisoning via execution of untrusted code
 * @description The cache can be poisoned by untrusted code, leading to a cache poisoning attack.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @security-severity 7.5
 * @id actions/cache-poisoning/poisonable-step
 * @tags actions
 *       security
 *       external/cwe/cwe-349
 */

import actions
import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.CachePoisoningQuery
import codeql.actions.security.PoisonableSteps
import codeql.actions.security.ControlChecks

query predicate edges(Step a, Step b) { a.getNextStep() = b }

from LocalJob job, Event event, Step source, Step step, string message, string path
where
  // the job checkouts untrusted code from a pull request or downloads an untrusted artifact
  job.getAStep() = source and
  (
    source instanceof PRHeadCheckoutStep and
    message = "due to privilege checkout of untrusted code." and
    path = source.(PRHeadCheckoutStep).getPath()
    or
    source instanceof UntrustedArtifactDownloadStep and
    message = "due to downloading an untrusted artifact." and
    path = source.(UntrustedArtifactDownloadStep).getPath()
  ) and
  // the checkout/download is not controlled by an access check
  not exists(ControlCheck check |
    check.protects(source, event, ["untrusted-checkout", "artifact-poisoning"])
  ) and
  job.getATriggerEvent() = event and
  // job can be triggered by an external user
  event.isExternallyTriggerable() and
  (
    // the workflow runs in the context of the default branch
    runsOnDefaultBranch(event)
    or
    // the workflow's caller runs in the context of the default branch
    event.getName() = "workflow_call" and
    exists(ExternalJob caller |
      caller.getCallee() = job.getLocation().getFile().getRelativePath() and
      runsOnDefaultBranch(caller.getATriggerEvent())
    )
  ) and
  // the job executes checked-out code
  // (The cache specific token can be leaked even for non-privileged workflows)
  source.getAFollowingStep() = step and
  step instanceof PoisonableStep and
  // excluding privileged workflows since they can be exploited in easier circumstances
  not job.isPrivileged()
select step, source, step,
  "Potential cache poisoning in the context of the default branch " + message + " ($@).", event,
  event.getName()
