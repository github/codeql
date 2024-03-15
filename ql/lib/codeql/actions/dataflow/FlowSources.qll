private import actions
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.Ast::Utils as Utils

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
  exists(string reg | reg = ["github\\.event\\.issue\\.title", "github\\.event\\.issue\\.body"] |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate isExternalUserControlledPullRequest(string context) {
  exists(string reg |
    reg =
      [
        "github\\.event\\.pull_request\\.title", "github\\.event\\.pull_request\\.body",
        "github\\.event\\.pull_request\\.head\\.label",
        "github\\.event\\.pull_request\\.head\\.repo\\.default_branch",
        "github\\.event\\.pull_request\\.head\\.repo\\.description",
        "github\\.event\\.pull_request\\.head\\.repo\\.homepage",
        "github\\.event\\.pull_request\\.head\\.ref", "github\\.head_ref"
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate isExternalUserControlledReview(string context) {
  Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp("github\\.event\\.review\\.body"))
}

bindingset[context]
private predicate isExternalUserControlledComment(string context) {
  Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp("github\\.event\\.comment\\.body"))
}

bindingset[context]
private predicate isExternalUserControlledGollum(string context) {
  exists(string reg |
    reg =
      [
        "github\\.event\\.pages\\[[0-9]+\\]\\.page_name",
        "github\\.event\\.pages\\[[0-9]+\\]\\.title"
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate isExternalUserControlledCommit(string context) {
  exists(string reg |
    reg =
      [
        "github\\.event\\.commits\\[[0-9]+\\]\\.message", "github\\.event\\.head_commit\\.message",
        "github\\.event\\.head_commit\\.author\\.email",
        "github\\.event\\.head_commit\\.author\\.name",
        "github\\.event\\.head_commit\\.committer\\.email",
        "github\\.event\\.head_commit\\.committer\\.name",
        "github\\.event\\.commits\\[[0-9]+\\]\\.author\\.email",
        "github\\.event\\.commits\\[[0-9]+\\]\\.author\\.name",
        "github\\.event\\.commits\\[[0-9]+\\]\\.committer\\.email",
        "github\\.event\\.commits\\[[0-9]+\\]\\.committer\\.name",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate isExternalUserControlledDiscussion(string context) {
  exists(string reg |
    reg = ["github\\.event\\.discussion\\.title", "github\\.event\\.discussion\\.body"]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate isExternalUserControlledWorkflowRun(string context) {
  exists(string reg |
    reg =
      [
        "github\\.event\\.workflow\\.path", "github\\.event\\.workflow_run\\.head_branch",
        "github\\.event\\.workflow_run\\.display_title",
        "github\\.event\\.workflow_run\\.head_repository\\.description",
        "github\\.event\\.workflow_run\\.head_commit\\.message",
        "github\\.event\\.workflow_run\\.head_commit\\.author\\.email",
        "github\\.event\\.workflow_run\\.head_commit\\.author\\.name",
        "github\\.event\\.workflow_run\\.head_commit\\.committer\\.email",
        "github\\.event\\.workflow_run\\.head_commit\\.committer\\.name",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
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

  CompositeActionInputSource() { c.getAnInput() = this.asExpr() }

  override string getSourceType() { result = "Composite action input" }

  override string getATriggerEvent() { result = "*" }
}
