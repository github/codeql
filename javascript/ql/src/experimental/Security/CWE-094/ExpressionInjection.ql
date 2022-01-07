/**
 * @name Expression injection in Actions
 * @description Using user-controlled GitHub Actions contexts like `run:` or `script:` may allow a malicious
 *              user to inject code into the GitHub action.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/actions/injection
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 */

import javascript
import experimental.semmle.javascript.Actions

bindingset[context]
private predicate isExternalUserControlledIssue(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*issue\\s*\\.\\s*title\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*issue\\s*\\.\\s*body\\b")
}

bindingset[context]
private predicate isExternalUserControlledPullRequest(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*title\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*body\\b") or
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*label\\b") or
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*repo\\s*\\.\\s*default_branch\\b") or
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*ref\\b")
}

bindingset[context]
private predicate isExternalUserControlledReview(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*review\\s*\\.\\s*body\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*review_comment\\s*\\.\\s*body\\b")
}

bindingset[context]
private predicate isExternalUserControlledComment(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*comment\\s*\\.\\s*body\\b")
}

bindingset[context]
private predicate isExternalUserControlledGollum(string context) {
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pages(?:\\[[0-9]\\]|\\s*\\.\\s*\\*)+\\s*\\.\\s*page_name\\b")
}

bindingset[context]
private predicate isExternalUserControlledCommit(string context) {
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits(?:\\[[0-9]\\]|\\s*\\.\\s*\\*)+\\s*\\.\\s*message\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*message\\b") or
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*author\\s*\\.\\s*email\\b") or
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*author\\s*\\.\\s*name\\b") or
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits(?:\\[[0-9]\\]|\\s*\\.\\s*\\*)+\\s*\\.\\s*author\\s*\\.\\s*email\\b") or
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits(?:\\[[0-9]\\]|\\s*\\.\\s*\\*)+\\s*\\.\\s*author\\s*\\.\\s*name\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*head_ref\\b")
}

bindingset[context]
private predicate isExternalUserControlledDiscussion(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*discussion\\s*\\.\\s*title\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*discussion\\s*\\.\\s*body\\b")
}

from Actions::Run run, string context, Actions::On on
where
  run.getAReferencedExpression() = context and
  run.getStep().getJob().getWorkflow().getOn() = on and
  (
    exists(on.getNode("issues")) and
    isExternalUserControlledIssue(context)
    or
    exists(on.getNode("pull_request_target")) and
    isExternalUserControlledPullRequest(context)
    or
    (exists(on.getNode("pull_request_review_comment")) or exists(on.getNode("pull_request_review"))) and
    isExternalUserControlledReview(context)
    or
    (exists(on.getNode("issue_comment")) or exists(on.getNode("pull_request_target"))) and
    isExternalUserControlledComment(context)
    or
    exists(on.getNode("gollum")) and
    isExternalUserControlledGollum(context)
    or
    exists(on.getNode("pull_request_target")) and
    isExternalUserControlledCommit(context)
    or
    (exists(on.getNode("discussion")) or exists(on.getNode("discussion_comment"))) and
    isExternalUserControlledDiscussion(context)
  )
select run,
  "Potential injection from the " + context +
    " context, which may be controlled by an external user."
