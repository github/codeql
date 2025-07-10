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

/**
 * A `script:` field within an Actions `with:` specific to `actions/github-script` action.
 *
 * For example:
 * ```
 * uses: actions/github-script@v3
 * with:
 *   script: console.log('${{ github.event.pull_request.head.sha }}')
 * ```
 */
class GitHubScript extends YamlNode, YamlString {
  GitHubScriptWith with;

  GitHubScript() { with.lookup("script") = this }

  /** Gets the `with` field this field belongs to. */
  GitHubScriptWith getWith() { result = with }
}

/**
 * A step that uses `actions/github-script` action.
 */
class GitHubScriptStep extends Actions::Step {
  GitHubScriptStep() { this.getUses().getGitHubRepository() = "actions/github-script" }
}

/**
 * A `with:` field sibling to `uses: actions/github-script`.
 */
class GitHubScriptWith extends YamlNode, YamlMapping {
  GitHubScriptStep step;

  GitHubScriptWith() { step.lookup("with") = this }

  /** Gets the step this field belongs to. */
  GitHubScriptStep getStep() { result = step }
}

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

/**
 * Holds if environment name in the `injection` (in a form of `env.name`)
 * is tainted by the `context` (in a form of `github.event.xxx.xxx`).
 */
bindingset[injection]
predicate isEnvInterpolationTainted(string injection, string context) {
  exists(Actions::Env env, string envName, YamlString envValue |
    envValue = env.lookup(envName) and
    Actions::getEnvName(injection) = envName and
    Actions::getASimpleReferenceExpression(envValue) = context
  )
}

/**
 * Holds if the `run` contains any expression interpolation `${{ e }}`.
 * Sets `context` to the initial untrusted value assignment in case of `${{ env... }}` interpolation
 */
predicate isRunInjectable(Actions::Run run, string injection, string context) {
  Actions::getASimpleReferenceExpression(run) = injection and
  (
    injection = context
    or
    isEnvInterpolationTainted(injection, context)
  )
}

/**
 * Holds if the `actions/github-script` contains any expression interpolation `${{ e }}`.
 * Sets `context` to the initial untrusted value assignment in case of `${{ env... }}` interpolation
 */
predicate isScriptInjectable(GitHubScript script, string injection, string context) {
  Actions::getASimpleReferenceExpression(script) = injection and
  (
    injection = context
    or
    isEnvInterpolationTainted(injection, context)
  )
}

/**
 * Holds if the composite action contains untrusted expression interpolation `${{ e }}`.
 */
YamlNode getInjectableCompositeActionNode(Actions::Runs runs, string injection, string context) {
  exists(Actions::Run run |
    isRunInjectable(run, injection, context) and
    result = run and
    run.getStep().getRuns() = runs
  )
  or
  exists(GitHubScript script |
    isScriptInjectable(script, injection, context) and
    result = script and
    script.getWith().getStep().getRuns() = runs
  )
}

/**
 * Holds if the workflow contains untrusted expression interpolation `${{ e }}`.
 */
YamlNode getInjectableWorkflowNode(Actions::On on, string injection, string context) {
  exists(Actions::Run run |
    isRunInjectable(run, injection, context) and
    result = run and
    run.getStep().getJob().getWorkflow().getOn() = on
  )
  or
  exists(GitHubScript script |
    isScriptInjectable(script, injection, context) and
    result = script and
    script.getWith().getStep().getJob().getWorkflow().getOn() = on
  )
}

from YamlNode node, string injection, string context
where
  exists(Actions::CompositeAction action, Actions::Runs runs |
    action.getRuns() = runs and
    node = getInjectableCompositeActionNode(runs, injection, context) and
    (
      isExternalUserControlledIssue(context) or
      isExternalUserControlledPullRequest(context) or
      isExternalUserControlledReview(context) or
      isExternalUserControlledComment(context) or
      isExternalUserControlledGollum(context) or
      isExternalUserControlledCommit(context) or
      isExternalUserControlledDiscussion(context) or
      isExternalUserControlledWorkflowRun(context)
    )
  )
  or
  exists(Actions::On on |
    node = getInjectableWorkflowNode(on, injection, context) and
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
  )
select node,
  "Potential injection from the ${{ " + injection +
    " }}, which may be controlled by an external user."
