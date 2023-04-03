/**
 * @name Expression injection in Actions
 * @description Using user-controlled GitHub Actions contexts like `run:` or `script:` may allow a malicious
 *              user to inject code into the GitHub action.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id js/actions/command-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 */

import javascript
import semmle.javascript.Actions

bindingset[context]
private predicate isExternalUserControlledIssue(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*issue\\s*\\.\\s*title\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*issue\\s*\\.\\s*body\\b")
}

bindingset[context]
private predicate isExternalUserControlledPullRequest(string context) {
  exists(string reg |
    reg =
      [
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*title\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*body\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*label\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*repo\\s*\\.\\s*default_branch\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*repo\\s*\\.\\s*description\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*repo\\s*\\.\\s*homepage\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pull_request\\s*\\.\\s*head\\s*\\.\\s*ref\\b",
        "\\bgithub\\s*\\.\\s*head_ref\\b"
      ]
  |
    context.regexpMatch(reg)
  )
}

bindingset[context]
private predicate isExternalUserControlledReview(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*review\\s*\\.\\s*body\\b")
}

bindingset[context]
private predicate isExternalUserControlledComment(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*comment\\s*\\.\\s*body\\b")
}

bindingset[context]
private predicate isExternalUserControlledGollum(string context) {
  context
      .regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pages\\[[0-9]+\\]\\s*\\.\\s*page_name\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*pages\\[[0-9]+\\]\\s*\\.\\s*title\\b")
}

bindingset[context]
private predicate isExternalUserControlledCommit(string context) {
  exists(string reg |
    reg =
      [
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits\\[[0-9]+\\]\\s*\\.\\s*message\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*message\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*author\\s*\\.\\s*email\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*author\\s*\\.\\s*name\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*committer\\s*\\.\\s*email\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*head_commit\\s*\\.\\s*committer\\s*\\.\\s*name\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits\\[[0-9]+\\]\\s*\\.\\s*author\\s*\\.\\s*email\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits\\[[0-9]+\\]\\s*\\.\\s*author\\s*\\.\\s*name\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits\\[[0-9]+\\]\\s*\\.\\s*committer\\s*\\.\\s*email\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*commits\\[[0-9]+\\]\\s*\\.\\s*committer\\s*\\.\\s*name\\b",
      ]
  |
    context.regexpMatch(reg)
  )
}

bindingset[context]
private predicate isExternalUserControlledDiscussion(string context) {
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*discussion\\s*\\.\\s*title\\b") or
  context.regexpMatch("\\bgithub\\s*\\.\\s*event\\s*\\.\\s*discussion\\s*\\.\\s*body\\b")
}

bindingset[context]
private predicate isExternalUserControlledWorkflowRun(string context) {
  exists(string reg |
    reg =
      [
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*head_branch\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*display_title\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*head_repository\\b\\s*\\.\\s*description\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*head_commit\\b\\s*\\.\\s*message\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*head_commit\\b\\s*\\.\\s*author\\b\\s*\\.\\s*email\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*head_commit\\b\\s*\\.\\s*author\\b\\s*\\.\\s*name\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*head_commit\\b\\s*\\.\\s*committer\\b\\s*\\.\\s*email\\b",
        "\\bgithub\\s*\\.\\s*event\\s*\\.\\s*workflow_run\\s*\\.\\s*head_commit\\b\\s*\\.\\s*committer\\b\\s*\\.\\s*name\\b",
      ]
  |
    context.regexpMatch(reg)
  )
}

from YamlNode node, string context, Actions::On on
where
  (
    exists(Actions::Run run |
      node = run and
      Actions::getASimpleReferenceExpression(run) = context and
      run.getStep().getJob().getWorkflow().getOn() = on
    )
    or
    exists(Actions::Script script, Actions::Step step, Actions::Uses uses |
      node = script and
      script.getWith().getStep() = step and
      uses.getStep() = step and
      uses.getGitHubRepository() = "actions/github-script" and
      Actions::getASimpleReferenceExpression(script) = context and
      script.getWith().getStep().getJob().getWorkflow().getOn() = on
    )
  ) and
  (
    exists(on.getNode("issues")) and
    isExternalUserControlledIssue(context)
    or
    exists(on.getNode("pull_request_target")) and
    isExternalUserControlledPullRequest(context)
    or
    exists(on.getNode("pull_request_review")) and
    (isExternalUserControlledReview(context) or isExternalUserControlledPullRequest(context))
    or
    exists(on.getNode("pull_request_review_comment")) and
    (isExternalUserControlledComment(context) or isExternalUserControlledPullRequest(context))
    or
    exists(on.getNode("issue_comment")) and
    (isExternalUserControlledComment(context) or isExternalUserControlledIssue(context))
    or
    exists(on.getNode("gollum")) and
    isExternalUserControlledGollum(context)
    or
    exists(on.getNode("push")) and
    isExternalUserControlledCommit(context)
    or
    exists(on.getNode("discussion")) and
    isExternalUserControlledDiscussion(context)
    or
    exists(on.getNode("discussion_comment")) and
    (isExternalUserControlledDiscussion(context) or isExternalUserControlledComment(context))
    or
    exists(on.getNode("workflow_run")) and
    isExternalUserControlledWorkflowRun(context)
  )
select node,
  "Potential injection from the " + context +
    " context, which may be controlled by an external user."
