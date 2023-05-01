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
  or
  result =
    API::moduleImport("@actions/core").getMember(["getInput", "getMultilineInput"]).getReturn()
}

private class GitHubActionsSource extends RemoteFlowSource {
  GitHubActionsSource() { this = taintSource().asSource() }

  override string getSourceType() { result = "GitHub Actions input" }
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
