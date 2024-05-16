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
        "github\\.event\\.pull_request\\.head\\.ref", "github\\.event\\.workflow_run\\.head_branch",
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
        "github\\.event\\.workflow\\.path", "github\\.event\\.workflow_run\\.path",
        "github\\.event\\.workflow_run\\.referenced_workflows\\.path",
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
        "github\\.event", "github\\.event\\.client_payload", "github\\.event\\.comment",
        "github\\.event\\.commits", "github\\.event\\.discussion", "github\\.event\\.head_commit",
        "github\\.event\\.head_commit\\.author", "github\\.event\\.head_commit\\.committer",
        "github\\.event\\.inputs", "github\\.event\\.issue", "github\\.event\\.merge_group",
        "github\\.event\\.merge_group\\.committer", "github\\.event\\.pull_request",
        "github\\.event\\.pull_request\\.head", "github\\.event\\.pull_request\\.head\\.repo",
        "github\\.event\\.pages", "github\\.event\\.review", "github\\.event\\.workflow",
        "github\\.event\\.workflow_run", "github\\.event\\.workflow_run\\.head_branch",
        "github\\.event\\.workflow_run\\.head_commit",
        "github\\.event\\.workflow_run\\.head_commit\\.author",
        "github\\.event\\.workflow_run\\.head_commit\\.committer",
        "github\\.event\\.workflow_run\\.head_repository",
        "github\\.event\\.workflow_run\\.pull_requests",
      ]
  |
    Utils::normalizeExpr(context).regexpMatch(Utils::wrapRegexp(reg))
  )
}

class GitHubSource extends RemoteFlowSource {
  string flag;

  GitHubSource() {
    exists(Expression e, string context, string context_prefix |
      this.asExpr() = e and
      context = e.getExpression() and
      Utils::normalizeExpr(context) = "github.head_ref" and
      contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(), context_prefix) and
      Utils::normalizeExpr(context).matches("%" + context_prefix + "%") and
      flag = "branch"
    )
  }

  override string getSourceType() { result = flag }
}

class GitHubEventSource extends RemoteFlowSource {
  string flag;

  GitHubEventSource() {
    exists(Expression e, string context, string context_prefix |
      this.asExpr() = e and
      context = e.getExpression() and
      contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(), context_prefix) and
      Utils::normalizeExpr(context).matches("%" + context_prefix + "%")
    |
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
    )
  }

  override string getSourceType() { result = flag }
}

class GitHubEventJsonSource extends RemoteFlowSource {
  string flag;

  GitHubEventJsonSource() {
    exists(Expression e, string context |
      this.asExpr() = e and
      context = e.getExpression() and
      (
        jsonEvent(context) and
        (
          exists(string context_prefix |
            contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(),
              context_prefix) and
            Utils::normalizeExpr(context).matches("%" + context_prefix + "%")
          )
          or
          contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(), _) and
          Utils::normalizeExpr(context).regexpMatch(".*\\bgithub.event\\b.*")
        )
      ) and
      flag = "json"
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
        u.getMajorVersion() < 41 or
        u.getVersion()
            .matches([
                  "56284d8", "9454999", "1c93849", "da093c1", "25ef392", "18c8a4e", "4052680",
                  "bfc49f4", "af292f1", "56284d8", "fea790c", "95690f9", "408093d", "db153ba",
                  "8238a41", "4196030", "a21a533", "8e79ba7", "76c4d81", "6ee9cdc", "246636f",
                  "48566bb", "fea790c", "1aee362", "2f7246c", "0fc9663", "c860b5c", "2f8b802",
                  "b7f1b73", "1c26215", "17f3fec", "1aee362", "a0585ff", "87697c0", "85c8b82",
                  "a96679d", "920e7b9", "de0eba3", "3928317", "68b429d", "2a968ff", "1f20fb8",
                  "87e23c4", "54849de", "bb33761", "ec1e14c", "2106eb4", "e5efec4", "5817a9e",
                  "a0585ff", "54479c3", "e1754a4", "9bf0914", "c912451", "174a2a6", "fb20f4d",
                  "07e0177", "b137868", "1aae160", "5d2fcdb", "9ecc6e7", "8c9ee56", "5978e5a",
                  "17c3e9e", "3f7b5c9", "cf4fe87", "043929e", "4e2535f", "652648a", "9ad1a5b",
                  "c798a4e", "25eaddf", "abef388", "1c2673b", "53c377a", "54479c3", "039afcd",
                  "b2d17f5", "4a0aac0", "ce810b2", "7ecfc67", "b109d83", "79adacd", "6e426e6",
                  "5e2d64b", "e9b5807", "db5dd7c", "07f86bc", "3a3ec49", "ee13744", "cda2902",
                  "9328bab", "4e680e1", "bd376fb", "84ed30e", "74b06ca", "5ce975c", "04124ef",
                  "3ee6abf", "23e3c43", "5a331a4", "7433886", "d5414fd", "7f2aa19", "210cc83",
                  "db3ea27", "57d9664", "0953088", "0562b9f", "487675b", "9a6dabf", "7839ede",
                  "c2296c1", "ea251d4", "1d1287f", "392359f", "7f33882", "1d8a2f9", "0626c3f",
                  "a2b1e5d", "110b9ba", "039afcd", "ce4b8e3", "3b6c057", "4f64429", "3f1e44a",
                  "74dc2e8", "8356a01", "baaf598", "8a4cc4f", "8a7336f", "3996bc3", "ef0a290",
                  "3ebdc42", "94e6fba", "3dbb79f", "991e8b3", "72d3bb8", "72d3bb8", "5f89dc7",
                  "734bb16", "d2e030b", "6ba3c59", "d0e4477", "b91acef", "1263363", "7184077",
                  "cbfb0fd", "932dad3", "9f28968", "c4d29bf", "ce4b8e3", "aa52cfc", "aa52cfc",
                  "1d6e210", "8953e85", "8de562e", "7c640bd", "2706452", "1d6e210", "dd7c814",
                  "528984a", "75af1a4", "5184a75", "dd7c814", "402f382", "402f382", "f7a5640",
                  "df4daca", "602081b", "6e12407", "c5c9b6f", "c41b715", "60f4aab", "82edb42",
                  "18edda7", "bec82eb", "f7a5640", "28ac672", "602cf94", "5e56dca", "58ae566",
                  "7394701", "36e65a1", "bf6ddb7", "6c44eb8", "b2ee165", "34a865a", "fb1fe28",
                  "ae90a0b", "bc1dc8f", "3de1f9a", "0edfedf", "2054502", "944a8b8", "581eef0",
                  "e55f7fb", "07b38ce", "d262520", "a6d456f", "a59f800", "a2f1692", "72aab29",
                  "e35d0af", "081ee9c", "1f30bd2", "227e314", "ffd30e8", "f5a8de7", "0bc7d40",
                  "a53d74f", "9335416", "4daffba", "4b1f26a", "09441d3", "e44053b", "c0dba81",
                  "fd2e991", "2a8a501", "a8ea720", "88edda5", "be68c10", "b59431b", "68bd279",
                  "2c85495", "f276697", "00f80ef", "f56e736", "019a09d", "3b638a9", "b42f932",
                  "8dfe0ee", "aae164d", "09a8797", "b54a7ae", "902e607", "2b51570", "040111b",
                  "3b638a9", "1d34e69", "b86b537", "2a771ad", "75933dc", "2c0d12b", "7abdbc9",
                  "675ab58", "8c6f276", "d825b1f", "0bd70b7", "0fe67a1", "7bfa539", "d679de9",
                  "1e10ed4", "0754fda", "d290bdd", "15b1769", "2ecd06d", "5fe8e4d", "7c66aa2",
                  "2ecd06d", "e95bba8", "7852058", "81f32e2", "450eadf", "0e956bb", "300e935",
                  "fcb2ab8", "271bbd6", "e8ace01", "473984b", "032f37f", "3a35bdf", "c2216f6",
                  "0f16c26", "271468e", "fb063fc", "a05436f", "c061ef1", "489e2d5", "8d5a33c",
                  "fbfaba5", "1980f55", "a86b560", "f917cc3", "e18ccae", "e1d275d", "00f80ef",
                  "9c1a181", "5eaa2d8", "188487d", "3098891", "467d26c", "d9eb683", "09a8797",
                  "8e7cc77", "81ad4b8", "5e2a2f1", "1af9ab3", "55a857d", "62a9200", "b915d09",
                  "f0751de", "eef9423"
                ] + "%")
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
        u.getMajorVersion() < 17 or
        u.getVersion()
            .matches([
                  "54e20d3", "a9b6fd3", "30aa174", "7f1b21c", "54e20d3", "0409e18", "7da22d0",
                  "7016858", "0409e18", "7517b83", "bad2f5d", "3b573ac", "7517b83", "f557547",
                  "9ed3155", "f557547", "a3391b5", "a3391b5", "1d7ee97", "c432297", "6e986df",
                  "fa6ea30", "6f40ee1", "1b13d25", "c09bcad", "fda469d", "bd1e271", "367ba21",
                  "9dea97e", "c154cc6", "527ff75", "e8756d5", "bcb4e76", "25267f5", "ea24bfd",
                  "f2a40ba", "197e121", "a8f1b11", "95c26dd", "97ba4cc", "68310bb", "720ba6a",
                  "cedd709", "d68d3d2", "2e1153b", "c3dd635", "81bd1de", "31a9c74", "e981d37",
                  "e7f801c", "e86d0b9", "ad255a4", "3a8aed1", "de910b5", "d31b2a1", "e61c6fc",
                  "380890d", "873cfd6", "b0c60c8", "7183183", "6555389", "9828a95", "8150cee",
                  "48ddf88"
                ] + "%")
      ) and
      this.asExpr() = u
    )
  }

  override string getSourceType() { result = "filename" }
}
