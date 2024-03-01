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

  abstract string getATriggerEvent();

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
  string trigger;

  EventSource() {
    exists(Expression e, string context | this.asExpr() = e and context = e.getExpression() |
      trigger = ["issues", "issue_comment"] and isExternalUserControlledIssue(context)
      or
      trigger = ["pull_request_target", "pull_request_review", "pull_request_review_comment"] and
      isExternalUserControlledPullRequest(context)
      or
      trigger = ["pull_request_review"] and isExternalUserControlledReview(context)
      or
      trigger = ["pull_request_review_comment", "issue_comment", "discussion_comment"] and
      isExternalUserControlledComment(context)
      or
      trigger = ["gollum"] and isExternalUserControlledGollum(context)
      or
      trigger = ["push"] and isExternalUserControlledCommit(context)
      or
      trigger = ["discussion", "discussion_comment"] and isExternalUserControlledDiscussion(context)
      or
      trigger = ["workflow_run"] and isExternalUserControlledWorkflowRun(context)
    )
  }

  override string getSourceType() { result = "User-controlled events" }

  override string getATriggerEvent() { result = trigger }
}

/**
 * A Source of untrusted data defined in a MaD specification
 */
private class ExternallyDefinedSource extends RemoteFlowSource {
  string sourceType;
  string trigger;

  ExternallyDefinedSource() { externallyDefinedSource(this, sourceType, _, trigger) }

  override string getSourceType() { result = sourceType }

  override string getATriggerEvent() { result = trigger }
}

/**
 * An input for a Composite Action
 */
private class CompositeActionInputSource extends RemoteFlowSource {
  CompositeAction c;

  CompositeActionInputSource() { c.getInputs().getInputExpr(_) = this.asExpr() }

  override string getSourceType() { result = "Composite action input" }

  override string getATriggerEvent() { result = "*" }
}
