/**
 * @name Actions Input to JS Sinks
 * @description Finding dataflows from inputs of the action to
 *  sinks in GitHub Actions written in javascript.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id javascript/input-sinks
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
  result = DataFlow::moduleImport("@actions/core").getAMemberCall("getInput") or
  result = DataFlow::moduleImport("@actions/core").getAMemberCall("getMultilineInput")
}

class MyConfiguration extends TaintTracking::Configuration {
  MyConfiguration() { this = "ActionInputToSink" }

  override predicate isSource(DataFlow::Node source) { source = coreSources() }

  override predicate isSink(DataFlow::Node sink) {
    sink = mainDangerCalls() or
    sink = execActionCalls() or
    sink = childProcessCalls()
  }
}

from
  MyConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, CallExpr srccall,
  Expr arg, string fnname
where
  cfg.hasFlowPath(source, sink) and
  srccall = source.getNode().asExpr() and
  arg = srccall.getArgument(0) and
  fnname = sink.getNode().asExpr().getParent().(CallExpr).getCalleeName()
select arg, source, sink, fnname
