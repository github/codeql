private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.security.UntrustedCheckoutQuery
private import codeql.actions.config.Config
private import codeql.actions.dataflow.ExternalFlow

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

class GitHubCtxSource extends RemoteFlowSource {
  string flag;

  GitHubCtxSource() {
    exists(Expression e, string context, string context_prefix |
      this.asExpr() = e and
      context = e.getExpression() and
      normalizeExpr(context) = "github.head_ref" and
      contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(), context_prefix) and
      normalizeExpr(context).matches("%" + context_prefix + "%") and
      flag = "branch"
    )
  }

  override string getSourceType() { result = flag }
}

class GitHubEventCtxSource extends RemoteFlowSource {
  string flag;

  GitHubEventCtxSource() {
    exists(Expression e, string context, string regexp |
      this.asExpr() = e and
      context = e.getExpression() and
      (
        // the context is available for the job trigger events
        exists(string context_prefix |
          contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(),
            context_prefix) and
          normalizeExpr(context).matches("%" + context_prefix + "%")
        )
        or
        exists(e.getEnclosingCompositeAction())
      ) and
      untrustedEventPropertiesDataModel(regexp, flag) and
      not flag = "json" and
      normalizeExpr(context).regexpMatch("(?i)\\s*" + wrapRegexp(regexp) + ".*")
    )
  }

  override string getSourceType() { result = flag }
}

class GitHubEventJsonSource extends RemoteFlowSource {
  string flag;

  GitHubEventJsonSource() {
    exists(Expression e, string context, string regexp |
      this.asExpr() = e and
      context = e.getExpression() and
      untrustedEventPropertiesDataModel(regexp, _) and
      (
        // only contexts for the triggering events are considered tainted.
        // eg: for `pull_request`, we only consider `github.event.pull_request`
        exists(string context_prefix |
          contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(),
            context_prefix) and
          normalizeExpr(context).matches("%" + context_prefix + "%")
        ) and
        normalizeExpr(context).regexpMatch("(?i).*" + wrapJsonRegexp(regexp) + ".*")
        or
        // github.event is taintes for all triggers
        contextTriggerDataModel(e.getEnclosingWorkflow().getATriggerEvent().getName(), _) and
        normalizeExpr(context).regexpMatch("(?i).*" + wrapJsonRegexp("\\bgithub.event\\b") + ".*")
      ) and
      flag = "json"
    )
  }

  override string getSourceType() { result = flag }
}

/**
 * A Source of untrusted data defined in a MaD specification
 */
class MaDSource extends RemoteFlowSource {
  string sourceType;

  MaDSource() { madSource(this, sourceType, _) }

  override string getSourceType() { result = sourceType }
}

/**
 * A downloaded artifact.
 */
private class ArtifactSource extends RemoteFlowSource {
  ArtifactSource() { this.asExpr() instanceof UntrustedArtifactDownloadStep }

  override string getSourceType() { result = "artifact" }
}

/**
 * A file from an untrusted checkout.
 */
private class CheckoutSource extends RemoteFlowSource {
  CheckoutSource() { this.asExpr() instanceof PRHeadCheckoutStep }

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
    exists(UsesStep u, string vulnerable_action, string vulnerable_version, string vulnerable_sha |
      vulnerableActionsDataModel(vulnerable_action, vulnerable_version, vulnerable_sha, _) and
      u.getCallee() = "tj-actions/changed-files" and
      u.getCallee() = vulnerable_action and
      (
        u.getArgument("safe_output") = "false"
        or
        (u.getVersion() = vulnerable_version or u.getVersion() = vulnerable_sha)
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
    exists(UsesStep u, string vulnerable_action, string vulnerable_version, string vulnerable_sha |
      vulnerableActionsDataModel(vulnerable_action, vulnerable_version, vulnerable_sha, _) and
      u.getCallee() = "tj-actions/verify-changed-files" and
      u.getCallee() = vulnerable_action and
      (
        u.getArgument("safe_output") = "false"
        or
        (u.getVersion() = vulnerable_version or u.getVersion() = vulnerable_sha)
      ) and
      this.asExpr() = u
    )
  }

  override string getSourceType() { result = "filename" }
}

class Xt0rtedSlashCommandSource extends RemoteFlowSource {
  Xt0rtedSlashCommandSource() {
    exists(UsesStep u |
      u.getCallee() = "xt0rted/slash-command-action" and
      u.getArgument("permission-level").toLowerCase() = ["read", "none"] and
      this.asExpr() = u
    )
  }

  override string getSourceType() { result = "text" }
}
