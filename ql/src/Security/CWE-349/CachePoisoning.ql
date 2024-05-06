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

from LocalJob j, PRHeadCheckoutStep checkout
where
  // The workflow runs in the context of the default branch
  // TODO: (require to collect trigger types)
  // - add push to default branch?
  // - exclude pull_request_target when branches_ignore includes default branch or when branches does not include the default branch
  j.getEnclosingWorkflow()
      .hasTriggerEvent([
          "check_run", "check_suite", "delete", "discussion", "discussion_comment", "fork",
          "gollum", "issue_comment", "issues", "label", "milestone", "project", "project_card",
          "project_column", "public", "pull_request_comment", "pull_request_target",
          "repository_dispatch", "schedule", "watch", "workflow_run"
        ]) and
  // The job checkouts untrusted code from a pull request
  j.getAStep() = checkout and
  (
    // The job writes to the cache
    // (No need to follow the checkout step as the cache writing is normally done after the job completes)
    j.getAStep() instanceof CacheWritingStep
    or
    // The job executes checked-out code
    // (The cache specific token can be leaked even for non-privileged workflows)
    checkout.getAFollowingStep() instanceof PoisonableStep
  )
select j.getAStep().(CacheWritingStep), "Potential cache poisoning on privileged workflow."
