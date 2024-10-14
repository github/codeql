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

abstract class CommandSource extends RemoteFlowSource {
  abstract string getCommand();

  abstract Run getEnclosingRun();
}

class GitCommandSource extends RemoteFlowSource, CommandSource {
  Run run;
  string cmd;
  string flag;

  GitCommandSource() {
    exists(Step checkout, string cmd_regex |
      // This shoould be:
      // source instanceof PRHeadCheckoutStep
      // but PRHeadCheckoutStep uses Taint Tracking anc causes a non-Monolitic Recursion error
      // so we list all the subclasses of PRHeadCheckoutStep here and use actions/checkout as a workaround
      // instead of using  ActionsMutableRefCheckout and ActionsSHACheckout
      (
        exists(Uses uses |
          checkout = uses and
          uses.getCallee() = "actions/checkout" and
          exists(uses.getArgument("ref")) and
          not uses.getArgument("ref").matches("%base%")
        )
        or
        checkout instanceof GitMutableRefCheckout
        or
        checkout instanceof GitSHACheckout
        or
        checkout instanceof GhMutableRefCheckout
        or
        checkout instanceof GhSHACheckout
      ) and
      this.asExpr() = run.getScript() and
      checkout.getAFollowingStep() = run and
      run.getScript().getACommand() = cmd and
      cmd.indexOf("git") = 0 and
      untrustedGitCommandsDataModel(cmd_regex, flag) and
      cmd.regexpMatch(cmd_regex)
    )
  }

  override string getSourceType() { result = flag }

  override string getCommand() { result = cmd }

  override Run getEnclosingRun() { result = run }
}

class GitHubEventPathSource extends RemoteFlowSource, CommandSource {
  string cmd;
  string flag;
  string access_path;
  Run run;

  // Examples
  // COMMENT_AUTHOR=$(jq -r .comment.user.login "$GITHUB_EVENT_PATH")
  // CURRENT_COMMENT=$(jq -r .comment.body "$GITHUB_EVENT_PATH")
  // PR_HEAD=$(jq --raw-output .pull_request.head.ref ${GITHUB_EVENT_PATH})
  // PR_NUMBER=$(jq --raw-output .pull_request.number ${GITHUB_EVENT_PATH})
  // PR_TITLE=$(jq --raw-output .pull_request.title ${GITHUB_EVENT_PATH})
  // BODY=$(jq -r '.issue.body' "$GITHUB_EVENT_PATH" | sed -n '3p')
  GitHubEventPathSource() {
    this.asExpr() = run.getScript() and
    run.getScript().getACommand() = cmd and
    cmd.matches("jq%") and
    cmd.matches("%GITHUB_EVENT_PATH%") and
    exists(string regexp |
      untrustedEventPropertiesDataModel(regexp, flag) and
      not flag = "json" and
      access_path = "github.event" + cmd.regexpCapture(".*\\s+([^\\s]+)\\s+.*", 1) and
      normalizeExpr(access_path).regexpMatch("(?i)\\s*" + wrapRegexp(regexp) + ".*")
    )
  }

  override string getSourceType() { result = flag }

  override string getCommand() { result = cmd }

  override Run getEnclosingRun() { result = run }
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

abstract class FileSource extends RemoteFlowSource { }

/**
 * A downloaded artifact.
 */
class ArtifactSource extends RemoteFlowSource, FileSource {
  ArtifactSource() { this.asExpr() instanceof UntrustedArtifactDownloadStep }

  override string getSourceType() { result = "artifact" }
}

/**
 * A file from an untrusted checkout.
 */
private class CheckoutSource extends RemoteFlowSource, FileSource {
  CheckoutSource() {
    // This shoould be:
    // source instanceof PRHeadCheckoutStep
    // but PRHeadCheckoutStep uses Taint Tracking anc causes a non-Monolitic Recursion error
    // so we list all the subclasses of PRHeadCheckoutStep here and use actions/checkout as a workaround
    // instead of using  ActionsMutableRefCheckout and ActionsSHACheckout
    exists(Uses uses |
      this.asExpr() = uses and
      uses.getCallee() = "actions/checkout" and
      exists(uses.getArgument("ref")) and
      not uses.getArgument("ref").matches("%base%")
    )
    or
    this.asExpr() instanceof GitMutableRefCheckout
    or
    this.asExpr() instanceof GitSHACheckout
    or
    this.asExpr() instanceof GhMutableRefCheckout
    or
    this.asExpr() instanceof GhSHACheckout
  }

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
