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

from LocalJob j, Event e, Step source, Step s, string message, string path
where
  // the job checkouts untrusted code from a pull request or downloads an untrusted artifact
  j.getAStep() = source and
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
    check.protects(source, j.getATriggerEvent(), ["untrusted-checkout", "artifact-poisoning"])
  ) and
  j.getATriggerEvent() = e and
  // job can be triggered by an external user
  e.isExternallyTriggerable() and
  (
    // the workflow runs in the context of the default branch
    runsOnDefaultBranch(e)
    or
    // the workflow's caller runs in the context of the default branch
    e.getName() = "workflow_call" and
    exists(ExternalJob caller |
      caller.getCallee() = j.getLocation().getFile().getRelativePath() and
      runsOnDefaultBranch(caller.getATriggerEvent())
    )
  ) and
  // the job executes checked-out code
  // (The cache specific token can be leaked even for non-privileged workflows)
  source.getAFollowingStep() = s and
  s instanceof PoisonableStep and
  // excluding privileged workflows since they can be exploited in easier circumstances
  not j.isPrivileged()
select s, source, s, "Potential cache poisoning in the context of the default branch " + message
