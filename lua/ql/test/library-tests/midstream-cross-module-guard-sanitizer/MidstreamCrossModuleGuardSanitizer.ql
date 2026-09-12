import codeql.lua.RulesSanitizerReport

from string capability, string evidence
where
  capability = "midstream-guard.classification" and
  reportClassification("source.luac", "root@pc8:r2", "neutral/sink.luac", "root.0@pc3:r2",
    "sanitized", "sanitized path suppressed") and
  evidence = "middle-module guard sanitizer suppresses the downstream sink"
  or
  capability = "midstream-guard.active-suppression" and
  not exists(
    LuaFlowNode source, LuaFlowNode sink, string classification, string reason, string provenance
  |
    source.getModulePath() = "source.luac" and
    source.getValueRef() = "root@pc8:r2" and
    sink.getModulePath() = "neutral/sink.luac" and
    sink.getValueRef() = "root.0@pc3:r2" and
    activeReportPath(source, sink, classification, reason, provenance)
  ) and
  evidence = "guarded path has no active report"
  or
  capability = "midstream-guard.unrelated-active" and
  exists(
    LuaFlowNode source, LuaFlowNode sink, string classification, string reason, string provenance
  |
    source.getModulePath() = "source.luac" and
    source.getValueRef() = "root@pc14:r3" and
    sink.getModulePath() = "neutral/sink.luac" and
    sink.getValueRef() = "root.0@pc3:r2" and
    activeReportPath(source, sink, classification, reason, provenance)
  ) and
  evidence = "unrelated sanitizer argument does not suppress the source"
  or
  capability = "midstream-guard.unrelated-not-sanitized" and
  not reportClassification("source.luac", "root@pc14:r3", "neutral/sink.luac", "root.0@pc3:r2",
    "sanitized", "sanitized path suppressed") and
  evidence = "unrelated sanitizer argument is not on the dataflow chain"
select capability, evidence
