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

from LocalJob j
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
  j.getAStep() instanceof PRHeadCheckoutStep and
  // The job writes to the cache
  j.getAStep() instanceof CacheWritingStep
select j.getAStep().(CacheWritingStep), "Potential cache poisoning on privileged workflow."
