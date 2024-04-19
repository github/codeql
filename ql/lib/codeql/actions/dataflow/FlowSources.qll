private import actions
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery

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
private predicate isExternalUserControlled(string context) {
  exists(string reg | reg = "github\\.event" |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
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
        "github\\.event\\.workflow_run\\.head_branch",
        "github\\.event\\.workflow_run\\.head_repository\\.description",
        "github\\.event\\.workflow_run\\.head_repository\\.full_name",
        "github\\.event\\.workflow_run\\.head_repository\\.name",
        "github\\.event\\.workflow_run\\.head_commit\\.message",
        "github\\.event\\.workflow_run\\.head_commit\\.author\\.email",
        "github\\.event\\.workflow_run\\.head_commit\\.author\\.name",
        "github\\.event\\.workflow_run\\.head_commit\\.committer\\.email",
        "github\\.event\\.workflow_run\\.head_commit\\.committer\\.name",
        "github\\.event\\.workflow_run\\.pull_requests\\[[0-9]+\\]\\.head\\.ref",
        "github\\.event\\.workflow_run\\.pull_requests\\[[0-9]+\\]\\.head\\.repo\\.name",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate isExternalUserControlledRepositoryDispatch(string context) {
  exists(string reg |
    reg = ["github\\.event\\.client_payload\\[[0-9]+\\]", "github\\.event\\.client_payload",]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate isExternalUserControlledWorkflowDispatch(string context) {
  exists(string reg | reg = ["github\\.event\\.inputs\\[[0-9]+\\]", "github\\.event\\.inputs",] |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

private class EventSource extends RemoteFlowSource {
  EventSource() {
    exists(Expression e, string context | this.asExpr() = e and context = e.getExpression() |
      isExternalUserControlled(context) or
      isExternalUserControlledIssue(context) or
      isExternalUserControlledPullRequest(context) or
      isExternalUserControlledReview(context) or
      isExternalUserControlledComment(context) or
      isExternalUserControlledGollum(context) or
      isExternalUserControlledCommit(context) or
      isExternalUserControlledDiscussion(context) or
      isExternalUserControlledWorkflowRun(context) or
      isExternalUserControlledRepositoryDispatch(context) or
      isExternalUserControlledWorkflowDispatch(context)
    )
  }

  override string getSourceType() { result = "User-controlled events" }
}

/**
 * A Source of untrusted data defined in a MaD specification
 */
private class ExternallyDefinedSource extends RemoteFlowSource {
  string sourceType;

  ExternallyDefinedSource() { externallyDefinedSource(this, sourceType, _) }

  override string getSourceType() { result = sourceType }
}

/**
 * An input for a Composite Action
 */
private class CompositeActionInputSource extends RemoteFlowSource {
  CompositeAction c;

  CompositeActionInputSource() { c.getAnInput() = this.asExpr() }

  override string getSourceType() { result = "Composite action input" }
}

/**
 * A downloadeded artifact.
 */
private class ArtifactToOptionSource extends RemoteFlowSource {
  ArtifactToOptionSource() { this.asExpr() instanceof UntrustedArtifactDownloadStep }

  override string getSourceType() { result = "Step output from Artifact" }
}
