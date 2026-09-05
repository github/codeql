/**
 * @name Sanitized command flow
 * @description Shows Lua command flows that are suppressed by a sanitizer on the path.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision high
 * @id lua/diagnostics/sanitized-command-flow
 * @tags experimental
 */

import codeql.lua.RulesSanitizerReport

class LuaSanitizedPathFile extends @file {
  LuaSanitizedPathFile() { files(this, _) }

  string getPath() { files(this, result) }

  string getURL() {
    exists(string prefix |
      sourceLocationPrefix(prefix) and
      result = "file://" + prefix + "/" + this.getPath() + ":0:0:0:0"
    )
  }

  string toString() { result = this.getPath() }
}

private predicate sanitizedPath(LuaFlowNode source, LuaFlowNode sink) {
  sanitizedReportPath(source, sink)
}

bindingset[sink]
bindingset[source]
private predicate reachesOrEquals(LuaFlowNode source, LuaFlowNode sink) {
  source = sink
  or
  genericFlowReachable(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
    sink.getValueRef())
}

query predicate edges(LuaFlowNode source, LuaFlowNode sink) {
  genericFlowStep(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
    sink.getValueRef(), _, _) and
  exists(LuaFlowNode pathSource, LuaFlowNode pathSink |
    sanitizedPath(pathSource, pathSink) and
    reachesOrEquals(pathSource, source) and
    reachesOrEquals(sink, pathSink)
  )
}

from
  LuaSanitizedPathFile file, LuaFlowNode source, LuaFlowNode sink, string classification,
  string reason
where
  sanitizedPath(source, sink) and
  classification = "sanitized" and
  reason = "sanitized path suppressed" and
  file.getPath() = sink.getModulePath()
select file, source, sink,
  "Sanitized Lua bytecode flow from " + source.toString() + " reaches this sink. Classification: " +
    classification + "; reason: " + reason + "."
