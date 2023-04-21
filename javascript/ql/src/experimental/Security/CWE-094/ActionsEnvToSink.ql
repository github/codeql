/**
 * @name Actions Environment Variables to JS Sinks
 * @description Finding dataflows from Environment variables to sinks in GitHub Actions written in javascript.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id javascript/env-sinks
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

DataFlow::Node coreSources() {
  // we need to get process.env
  result = DataFlow::globalVarRef("process").getAPropertyRead("env").getAPropertyReference()
}

class MyConfiguration extends TaintTracking::Configuration {
  MyConfiguration() { this = "ActionEnvToSink" }

  override predicate isSource(DataFlow::Node source) { source = coreSources() }

  override predicate isSink(DataFlow::Node sink) {
    sink = mainDangerCalls() or
    sink = execActionCalls() or
    sink = childProcessCalls()
  }
}

from
  MyConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, IndexExpr srcidx,
  DotExpr srcdot, string fnname, string envname, Expr arg
where
  cfg.hasFlowPath(source, sink) and
  source.getNode().asExpr() = arg and
  fnname = sink.getNode().asExpr().getParent().(CallExpr).getCalleeName() and
  (
    srcidx = source.getNode().asExpr() and envname = srcidx.getPropertyName()
    or
    srcdot = source.getNode().asExpr() and envname = srcdot.getPropertyName()
  ) and
  // Pick the default environment variables from https://docs.github.com/en/actions/learn-github-actions/variables
  not envname in [
      "GITHUB_ACTION", "GITHUB_ACTION_PATH", "GITHUB_ACTION_REPOSITORY", "GITHUB_ACTIONS",
      "GITHUB_ACTOR", "GITHUB_API_URL", "GITHUB_BASE_REF", "GITHUB_ENV", "GITHUB_EVENT_NAME",
      "GITHUB_EVENT_PATH", "GITHUB_GRAPHQL_URL", "GITHUB_JOB", "GITHUB_PATH", "GITHUB_REF",
      "GITHUB_REPOSITORY", "GITHUB_REPOSITORY_OWNER", "GITHUB_RUN_ID", "GITHUB_RUN_NUMBER",
      "GITHUB_SERVER_URL", "GITHUB_SHA", "GITHUB_WORKFLOW", "GITHUB_WORKSPACE"
    ]
select arg, source, sink, fnname
