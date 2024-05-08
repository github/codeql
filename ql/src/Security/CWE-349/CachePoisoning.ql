/**
 * @name Cache Poisoning
 * @description The cache can be poisoned by untrusted code, leading to a cache poisoning attack.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @security-severity 9.3
 * @id actions/cache-poisoning
 * @tags actions
 *       security
 *       external/cwe/cwe-349
 */

import actions
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.CachePoisoningQuery
import codeql.actions.security.PoisonableSteps

from LocalJob j, PRHeadCheckoutStep checkout, Step s
where
  // Excluding privileged workflows since they can be easily exploited in similar circumstances
  not j.isPrivileged() and
  // The workflow runs in the context of the default branch
  // TODO: (require to collect trigger types)
  // - add push to default branch?
  // - exclude pull_request_target when branches_ignore includes default branch or when branches does not include the default branch
  (
    j.getEnclosingWorkflow().hasTriggerEvent(defaultBranchTriggerEvent())
    or
    j.getEnclosingWorkflow().hasTriggerEvent("workflow_call") and
    exists(ExternalJob call, Workflow caller |
      call.getCallee() = j.getLocation().getFile().getRelativePath() and
      caller = call.getWorkflow() and
      caller.hasTriggerEvent(defaultBranchTriggerEvent())
    )
  ) and
  // The job checkouts untrusted code from a pull request
  j.getAStep() = checkout and
  (
    // The job writes to the cache
    // (No need to follow the checkout step as the cache writing is normally done after the job completes)
    j.getAStep() = s and
    s instanceof CacheWritingStep
    or
    // The job executes checked-out code
    // (The cache specific token can be leaked even for non-privileged workflows)
    checkout.getAFollowingStep() = s and
    s instanceof PoisonableStep
  )
select checkout, "Potential cache poisoning in the context of the default branch on step $@.", s,
  s.toString()
