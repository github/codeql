import actions
import codeql.actions.DataFlow
import codeql.actions.dataflow.ExternalFlow

/**
 * A data flow source.
 */
abstract class SourceNode extends DataFlow::Node {
  /**
   * Gets a string that represents the source kind with respect to threat modeling.
   */
  abstract string getThreatModel();
}

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends SourceNode {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();

  override string getThreatModel() { result = "remote" }
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

private class EventSource extends RemoteFlowSource {
  EventSource() {
    exists(ExprAccessExpr e, string context | this.asExpr() = e and context = e.getExpression() |
      isExternalUserControlledIssue(context) or
      isExternalUserControlledPullRequest(context) or
      isExternalUserControlledReview(context) or
      isExternalUserControlledComment(context) or
      isExternalUserControlledGollum(context) or
      isExternalUserControlledCommit(context) or
      isExternalUserControlledDiscussion(context) or
      isExternalUserControlledWorkflowRun(context)
    )
  }

  override string getSourceType() { result = "User-controlled events" }
}

/**
 * MaD sources
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - trigger: Triggering event under which this model introduces tainted data. Use `*` for any event.
 */
private class ExternallyDefinedSource extends RemoteFlowSource {
  string soutceType;

  ExternallyDefinedSource() {
    exists(
      UsesExpr uses, string action, string version, string output, string trigger, string kind
    |
      sourceModel(action, version, output, trigger, kind) and
      uses.getCallee() = action and
      (
        if version.trim() = "*"
        then uses.getVersion() = any(string v)
        else uses.getVersion() = version.trim()
      ) and
      (
        if output.trim().matches("env.%")
        then this.asExpr() = uses.getEnvExpr(output.trim().replaceAll("output\\.", ""))
        else
          // 'output.' is the default qualifier
          // TODO: Taint just the specified output
          this.asExpr() = uses
      ) and
      soutceType = kind
    )
  }

  override string getSourceType() { result = soutceType }
}
