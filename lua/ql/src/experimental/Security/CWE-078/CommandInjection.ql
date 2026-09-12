/**
 * @name Uncontrolled command line
 * @description Using externally controlled values in a command line may allow an attacker to execute malicious commands.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id lua/command-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import codeql.lua.RulesSanitizerReport

class LuaReportFile extends @file {
  LuaReportFile() { files(this, _) }

  string getPath() { files(this, result) }

  string getURL() {
    exists(string prefix |
      sourceLocationPrefix(prefix) and
      result = "file://" + prefix + "/" + this.getPath() + ":0:0:0:0"
    )
  }

  string toString() { result = this.getPath() }
}

query predicate edges(LuaFlowNode source, LuaFlowNode sink) {
  activeReportFlowStep(source, sink, _, _)
}

from
  LuaReportFile file, LuaFlowNode source, LuaFlowNode sink, string classification, string reason,
  string provenance
where
  activeReportPath(source, sink, classification, reason, provenance) and
  file.getPath() = sink.getModulePath()
select file, source, sink,
  "Unsanitized Lua bytecode flow from " + source.toString() + " reaches this sink. Classification: "
    + classification + "; reason: " + reason + "; provenance: " + provenance + "."
