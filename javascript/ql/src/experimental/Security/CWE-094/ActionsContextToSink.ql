/**
 * @name Actions Direct Context to Sinks
 * @description Finding direct context to sinks in GitHub Actions written in javascript.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id javascript/context-sinks
 * @tags security
 *       external/cwe/cwe-094
 *       experimental
 */

import javascript
import DataFlow::PathGraph

DataFlow::Node mainDangerCalls() {
  result =
    DataFlow::globalVarRef(["eval", "setTimeout", "setInterval", "unserialize"])
        .getACall()
        .getArgument(0)
}

DataFlow::Node execActionCalls() {
  result = DataFlow::moduleImport("@actions/exec").getAMemberCall("exec").getArgument(0)
}

DataFlow::Node childProcessCalls() {
  result =
    DataFlow::moduleImport("child_process")
        .getAMemberCall(["exec", "execSync", "execFile", "execFileSync", "spawn", "spawnSync"])
        .getArgument(0)
}

DataFlow::PropRead payloadObject(string event, string object) {
  result =
    DataFlow::moduleImport("@actions/github")
        .getAPropertyRead("context")
        .getAPropertyRead("payload")
        .getAPropertyRead(event)
        .getAPropertyRead(object)
}

DataFlow::PropRead payloadEvent(string event) {
  result =
    DataFlow::moduleImport("@actions/github")
        .getAPropertyRead("context")
        .getAPropertyRead("payload")
        .getAPropertyRead(event)
}

DataFlow::Node pullrequestSources() {
  result = payloadObject("pull_request", "head").getAPropertyRead("ref") or
  result = payloadObject("pull_request", "head").getAPropertyRead("label") or
  result = payloadObject("pull_request", "head").getAPropertyRead("repo").getAPropertyRead("default_branch") or
  result = payloadObject("pull_request", "head").getAPropertyRead("repo").getAPropertyRead("description") or
  result = payloadObject("pull_request", "head").getAPropertyRead("repo").getAPropertyRead("homepage") or
  result = payloadObject("pull_request", "title") or
  result = payloadObject("pull_request", "body")
}

DataFlow::Node issueSources() {
  result = payloadObject("issue", "title") or
  result = payloadObject("issue", "body")
}

DataFlow::Node discussionSources() {
  result = payloadObject("discussion", "title") or
  result = payloadObject("discussion", "body")
}

DataFlow::Node commentSources() {
  result = payloadObject("comment", "body") or
  result = payloadObject("review", "body") or
  result = payloadObject("comment", "body")
}

DataFlow::Node workflowRunSources() {
  result = payloadObject("workflow_run", "head_branch") or
  result = payloadObject("workflow_run", "display_title") or
  result = payloadObject("workflow_run", "head_repository").getAPropertyRead("description") or
  result = payloadObject("workflow_run", "head_commit").getAPropertyRead("message") or
  result =
    payloadObject("workflow_run", "head_commit").getAPropertyRead("author").getAPropertyRead("name") or
    result =
    payloadObject("workflow_run", "head_commit").getAPropertyRead("committer").getAPropertyRead("name") or
  result =
    payloadObject("workflow_run", "head_commit")
        .getAPropertyRead("author")
        .getAPropertyRead("email") or
    result =
    payloadObject("workflow_run", "head_commit")
        .getAPropertyRead("committer")
        .getAPropertyRead("email") or
  result =
    payloadObject("workflow_run", "head_commit")
        .getAPropertyRead("pull_requests")
        .getAPropertyRead()
        .getAPropertyRead("head")
        .getAPropertyRead("ref")
}

DataFlow::Node headCommitSources() {
  result = payloadObject("head_commit", "message") or
  result = payloadObject("head_commit", "author").getAPropertyRead("name") or
  result = payloadObject("head_commit", "author").getAPropertyRead("email") or
  result = payloadObject("head_commit", "committer").getAPropertyRead("name") or
  result = payloadObject("head_commit", "committer").getAPropertyRead("email") or
  result = payloadEvent("commits").getAPropertyRead().getAPropertyRead("message") or
  result =
    payloadEvent("commits").getAPropertyRead().getAPropertyRead("author").getAPropertyRead("name") or
  result =
    payloadEvent("commits").getAPropertyRead().getAPropertyRead("author").getAPropertyRead("email") or
   result = payloadEvent("commits").getAPropertyRead().getAPropertyRead("committer").getAPropertyRead("name") or
  result = payloadEvent("commits").getAPropertyRead().getAPropertyRead("committer").getAPropertyRead("email")
}

class MyConfiguration extends TaintTracking::Configuration {
  MyConfiguration() { this = "ActionsContextToSink" }

  override predicate isSource(DataFlow::Node source) {
    source = pullrequestSources() or
    source = issueSources() or
    source = discussionSources() or
    source = workflowRunSources() or
    source = commentSources() or
    source = headCommitSources()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = mainDangerCalls() or
    sink = execActionCalls() or
    sink = childProcessCalls()
  }
}

from
  MyConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Expr arg, string fnname
where
  cfg.hasFlowPath(source, sink) and
  source.getNode().asExpr() = arg and
  fnname = sink.getNode().asExpr().getParent().(CallExpr).getCalleeName()
select arg, source, sink, fnname
