/**
 * Contains models for `@actions/core` related libraries.
 */

private import javascript

private API::Node payload() {
  result = API::moduleImport("@actions/github").getMember("context").getMember("payload")
}

private API::Node workflowRun() { result = payload().getMember("workflow_run") }

private API::Node commitObj() {
  result = workflowRun().getMember("head_commit")
  or
  result = payload().getMember("commits").getAMember()
}

private API::Node pullRequest() {
  result = payload().getMember("pull_request")
  or
  result = commitObj().getMember("pull_requests").getAMember()
}

private API::Node taintSource() {
  result = pullRequest().getMember("head").getMember(["ref", "label"])
  or
  result =
    [pullRequest(), payload().getMember(["discussion", "issue"])].getMember(["title", "body"])
  or
  result = payload().getMember(["review", "review_comment", "comment"]).getMember("body")
  or
  result = workflowRun().getMember(["head_branch", "display_title"])
  or
  result = workflowRun().getMember("head_repository").getMember("description")
  or
  result = commitObj().getMember("message")
  or
  result = commitObj().getMember(["author", "committer"]).getMember(["name", "email"])
}

/**
 * A source of taint originating from the context.
 */
private class GitHubActionsContextSource extends RemoteFlowSource {
  GitHubActionsContextSource() { this = taintSource().asSource() }

  override string getSourceType() { result = "GitHub Actions context" }
}

/**
 * A source of taint originating from user input.
 *
 * At the momemnt this is treated as a remote flow source, although it is not
 * always possible for an attacker to control this. In the future we might classify
 * this differently.
 */
private class GitHubActionsInputSource extends RemoteFlowSource {
  GitHubActionsInputSource() {
    this =
      API::moduleImport("@actions/core")
          .getMember(["getInput", "getMultilineInput"])
          .getReturn()
          .asSource()
  }

  override string getSourceType() { result = "GitHub Actions user input" }
}

private class ExecActionsCall extends SystemCommandExecution, DataFlow::CallNode {
  ExecActionsCall() {
    this = API::moduleImport("@actions/exec").getMember(["exec", "getExecOutput"]).getACall()
  }

  override DataFlow::Node getACommandArgument() { result = this.getArgument(0) }

  override DataFlow::Node getArgumentList() { result = this.getArgument(1) }

  override DataFlow::Node getOptionsArg() { result = this.getArgument(2) }

  override predicate isSync() { none() }
}
