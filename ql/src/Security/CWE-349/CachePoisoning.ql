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

from Workflow w, PRHeadCheckoutStep checkout, LocalJob j
where
  // TODO: (require to collect trigger types)
  // - add push to default branch?
  // - exclude pull_request_target when branches_ignore includes default branch or when branches does not include the default branch
  w.hasTriggerEvent([
      "check_run", "check_suite", "delete", "discussion", "discussion_comment", "fork", "gollum",
      "issue_comment", "issues", "label", "milestone", "project", "project_card", "project_column",
      "public", "pull_request_comment", "pull_request_target", "repository_dispatch", "schedule",
      "watch", "workflow_run"
    ]) and
  // Workflow is privileged
  w.isPrivileged() and
  // The workflow checkouts untrusted code from a pull request
  j = w.getAJob() and
  j.getAStep() = checkout and
  // The checkout step is followed by a cache writing step
  j.getAStep() instanceof CacheWritingStep
select checkout, "Potential cache poisoning on privileged workflow."
