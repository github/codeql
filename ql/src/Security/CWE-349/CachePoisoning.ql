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
  // the workflow runs in the context of the default branch
  runsOnDefaultBranch(j) and
  // the job checkouts untrusted code from a pull request
  // TODO: Consider adding artifact downloads as a potential source of cache poisoning
  j.getAStep() = checkout and
  // job can be triggered by an external user
  j.getATriggerEvent().isExternallyTriggerable() and
  (
    // the job writes to the cache
    // (No need to follow the checkout step as the cache writing is normally done after the job completes)
    j.getAStep() = s and
    s instanceof CacheWritingStep
    or
    // the job executes checked-out code
    // (The cache specific token can be leaked even for non-privileged workflows)
    checkout.getAFollowingStep() = s and
    s instanceof PoisonableStep and
    // excluding privileged workflows since they can be easily exploited in similar circumstances
    not j.isPrivileged()
  )
select checkout, "Potential cache poisoning in the context of the default branch on step $@.", s,
  s.toString()
