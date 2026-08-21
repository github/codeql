import codeql.lua.RulesSanitizerReport

from string capability, string evidence
where
  capability = "cross-module-guard-sanitizer.classification" and
  reportClassification("controller.luac", "root@pc8:r2", "neutral/sink.luac", "root.0@pc3:r2",
    "sanitized", "sanitized path suppressed") and
  evidence = "caller guard suppresses resolved callee sink"
  or
  capability = "cross-module-guard-sanitizer.active-suppression" and
  not exists(
    LuaFlowNode source, LuaFlowNode sink, string classification, string reason, string provenance
  |
    source.getModulePath() = "controller.luac" and
    source.getValueRef() = "root@pc8:r2" and
    sink.getModulePath() = "neutral/sink.luac" and
    sink.getValueRef() = "root.0@pc3:r2" and
    activeReportPath(source, sink, classification, reason, provenance)
  ) and
  evidence = "no active report crosses the validated call boundary"
select capability, evidence
