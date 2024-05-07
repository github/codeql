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
private predicate titleEvent(string context) {
  exists(string reg |
    reg =
      [
        // title
        "github\\.event\\.issue\\.title", // issue
        "github\\.event\\.pull_request\\.title", // pull request
        "github\\.event\\.discussion\\.title", // discussion
        "github\\.event\\.pages\\[[0-9]+\\]\\.page_name",
        "github\\.event\\.pages\\[[0-9]+\\]\\.title",
        "github\\.event\\.workflow_run\\.display_title", // The event-specific title associated with the run or the run-name if set, or the value of run-name if it is set in the workflow.
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate urlEvent(string context) {
  exists(string reg |
    reg =
      [
        // url
        "github\\.event\\.pull_request\\.head\\.repo\\.homepage",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate textEvent(string context) {
  exists(string reg |
    reg =
      [
        // text
        "github\\.event\\.issue\\.body", // body
        "github\\.event\\.pull_request\\.body", // body
        "github\\.event\\.discussion\\.body", // body
        "github\\.event\\.review\\.body", // body
        "github\\.event\\.comment\\.body", // body
        "github\\.event\\.commits\\[[0-9]+\\]\\.message", // messsage
        "github\\.event\\.head_commit\\.message", // message
        "github\\.event\\.workflow_run\\.head_commit\\.message", // message
        "github\\.event\\.pull_request\\.head\\.repo\\.description", // description
        "github\\.event\\.workflow_run\\.head_repository\\.description", // description
        "github\\.event\\.client_payload\\[[0-9]+\\]", // payload
        "github\\.event\\.client_payload", // payload
        "github\\.event\\.inputs\\[[0-9]+\\]", // input
        "github\\.event\\.inputs", // input
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

// bindingset[context]
// private predicate repoNameEvent(string context) {
//   exists(string reg |
//     reg =
//       [
//         // repo name
//         // Owner: All characters must be either a hyphen (-) or alphanumeric
//         // Repo: All code points must be either a hyphen (-), an underscore (_), a period (.), or an ASCII alphanumeric code point
//         "github\\.event\\.workflow_run\\.pull_requests\\[[0-9]+\\]\\.head\\.repo\\.name", // repo name
//         "github\\.event\\.workflow_run\\.head_repository\\.name", // repo name
//         "github\\.event\\.workflow_run\\.head_repository\\.full_name", // nwo
//       ]
//   |
//     Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
//   )
// }
bindingset[context]
private predicate branchEvent(string context) {
  exists(string reg |
    reg =
      [
        // branch
        // https://docs.github.com/en/get-started/using-git/dealing-with-special-characters-in-branch-and-tag-names
        // - They can include slash / for hierarchical (directory) grouping, but no slash-separated component can begin with a dot . or end with the sequence .lock.
        // - They must contain at least one /
        // - They cannot have two consecutive dots .. anywhere.
        // - They cannot have ASCII control characters (i.e. bytes whose values are lower than \040, or \177 DEL), space, tilde ~, caret ^, or colon : anywhere.
        // - They cannot have question-mark ?, asterisk *, or open bracket [ anywhere.
        // - They cannot begin or end with a slash / or contain multiple consecutive slashes
        // - They cannot end with a dot .
        // - They cannot contain a sequence @{
        // - They cannot be the single character @
        // - They cannot contain a \
        // eg: zzz";echo${IFS}"hello";# would be a valid branch name
        "github\\.event\\.pull_request\\.head\\.repo\\.default_branch",
        "github\\.event\\.pull_request\\.head\\.ref", "github\\.head_ref",
        "github\\.event\\.workflow_run\\.head_branch",
        "github\\.event\\.workflow_run\\.pull_requests\\[[0-9]+\\]\\.head\\.ref",
        "github\\.event\\.merge_group\\.head_ref",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate labelEvent(string context) {
  exists(string reg |
    reg =
      [
        // label
        // - They cannot contain a escaping \
        "github\\.event\\.pull_request\\.head\\.label",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate emailEvent(string context) {
  exists(string reg |
    reg =
      [
        // email
        // `echo${IFS}hello`@domain.com
        "github\\.event\\.head_commit\\.author\\.email",
        "github\\.event\\.head_commit\\.committer\\.email",
        "github\\.event\\.commits\\[[0-9]+\\]\\.author\\.email",
        "github\\.event\\.commits\\[[0-9]+\\]\\.committer\\.email",
        "github\\.event\\.merge_group\\.committer\\.email",
        "github\\.event\\.workflow_run\\.head_commit\\.author\\.email",
        "github\\.event\\.workflow_run\\.head_commit\\.committer\\.email",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate usernameEvent(string context) {
  exists(string reg |
    reg =
      [
        // username
        // All characters must be either a hyphen (-) or alphanumeric
        "github\\.event\\.head_commit\\.author\\.name",
        "github\\.event\\.head_commit\\.committer\\.name",
        "github\\.event\\.commits\\[[0-9]+\\]\\.author\\.name",
        "github\\.event\\.commits\\[[0-9]+\\]\\.committer\\.name",
        "github\\.event\\.merge_group\\.committer\\.name",
        "github\\.event\\.workflow_run\\.head_commit\\.author\\.name",
        "github\\.event\\.workflow_run\\.head_commit\\.committer\\.name",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate pathEvent(string context) {
  exists(string reg |
    reg =
      [
        // filename
        "github\\.event\\.workflow\\.path",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

bindingset[context]
private predicate jsonEvent(string context) {
  exists(string reg |
    reg =
      [
        // json
        "github\\.event",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

class EventSource extends RemoteFlowSource {
  string flag;

  EventSource() {
    exists(Expression e, string context | this.asExpr() = e and context = e.getExpression() |
      titleEvent(context) and flag = "title"
      or
      urlEvent(context) and flag = "url"
      or
      textEvent(context) and flag = "text"
      or
      branchEvent(context) and flag = "branch"
      or
      labelEvent(context) and flag = "label"
      or
      emailEvent(context) and flag = "email"
      or
      usernameEvent(context) and flag = "username"
      or
      pathEvent(context) and flag = "filename"
      or
      jsonEvent(context) and flag = "json"
    )
  }

  override string getSourceType() { result = flag }
}

/**
 * A Source of untrusted data defined in a MaD specification
 */
class ExternallyDefinedSource extends RemoteFlowSource {
  string sourceType;

  ExternallyDefinedSource() { externallyDefinedSource(this, sourceType, _) }

  override string getSourceType() { result = sourceType }
}

/**
 * An input for a Composite Action
 */
class CompositeActionInputSource extends RemoteFlowSource {
  CompositeAction c;

  CompositeActionInputSource() { c.getAnInput() = this.asExpr() }

  override string getSourceType() { result = "input" }
}

/**
 * A downloaded artifact.
 */
private class ArtifactSource extends RemoteFlowSource {
  ArtifactSource() { this.asExpr() instanceof UntrustedArtifactDownloadStep }

  override string getSourceType() { result = "artifact" }
}

/**
 * A list of file names returned by dorny/paths-filter.
 */
class DornyPathsFilterSource extends RemoteFlowSource {
  DornyPathsFilterSource() {
    exists(UsesStep u |
      u.getCallee() = "dorny/paths-filter" and
      u.getArgument("list-files") = ["csv", "json"] and
      this.asExpr() = u
    )
  }

  override string getSourceType() { result = "filename" }
}

/**
 * A list of file names returned by tj-actions/changed-files.
 */
class TJActionsChangedFilesSource extends RemoteFlowSource {
  TJActionsChangedFilesSource() {
    exists(UsesStep u |
      u.getCallee() = "tj-actions/changed-files" and
      (
        u.getArgument("safe_output") = "false" or
        u.getVersion().regexpReplaceAll("^v", "").regexpReplaceAll("\\..*", "").toInt() < 41
      ) and
      this.asExpr() = u
    )
  }

  override string getSourceType() { result = "filename" }
}

/**
 * A list of file names returned by tj-actions/verify-changed-files.
 */
class TJActionsVerifyChangedFilesSource extends RemoteFlowSource {
  TJActionsVerifyChangedFilesSource() {
    exists(UsesStep u |
      u.getCallee() = "tj-actions/verify-changed-files" and
      (
        u.getArgument("safe_output") = "false" or
        u.getVersion().regexpReplaceAll("^v", "").regexpReplaceAll("\\..*", "").toInt() < 17
      ) and
      this.asExpr() = u
    )
  }

  override string getSourceType() { result = "filename" }
}
