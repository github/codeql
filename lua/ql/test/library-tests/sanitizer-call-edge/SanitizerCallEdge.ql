import codeql.lua.RulesSanitizerReport

private string sourceModule() { result = "source.luac" }

private string sourceRef() { result = "root@pc8:r2" }

private string sinkModule() { result = "neutral/sink.luac" }

private string negativeModule() { result = "negative.luac" }

from string capability, string evidence
where
  capability = "sanitizer-call-edge.typed-call" and
  sanitizerCall(sourceModule(), "root@pc12", "doShell", "", _) and
  evidence = "zero-return doShell call is a typed sanitizer"
  or
  capability = "sanitizer-call-edge.classification" and
  sanitizerClassification(sourceModule(), sourceRef(), sinkModule(), "root.0@pc3:r3",
    sourceModule(), "root@pc12", "doShell", "true", "true", "sanitized") and
  reportClassification(sourceModule(), sourceRef(), sinkModule(), "root.0@pc3:r3", "sanitized",
    "sanitized path suppressed") and
  evidence = "tainted non-first argument crosses the sanitizer call edge into its callee sink"
  or
  capability = "sanitizer-call-edge.active-suppression" and
  not exists(
    LuaFlowNode source, LuaFlowNode sink, string classification, string reason, string provenance
  |
    source.getModulePath() = sourceModule() and
    source.getValueRef() = sourceRef() and
    sink.getModulePath() = sinkModule() and
    sink.getValueRef() = "root.0@pc3:r3" and
    activeReportPath(source, sink, classification, reason, provenance)
  ) and
  evidence = "non-first sanitizer call-edge route has no active report"
  or
  capability = "sanitizer-call-edge.sibling-active" and
  reportClassification(negativeModule(), "root@pc8:r2", sinkModule(), "root.1@pc3:r2",
    "true-positive", "unsanitized active source-to-sink path") and
  evidence = "ordinary sibling call remains active"
  or
  capability = "sanitizer-call-edge.unrelated-negative" and
  not sanitizerClassification(negativeModule(), "root@pc8:r2", sinkModule(), "root.1@pc3:r2",
    negativeModule(), "root@pc15", "doShell", "true", "true", "sanitized") and
  evidence = "constant-only sanitizer call does not suppress the tainted sibling route"
select capability, evidence
