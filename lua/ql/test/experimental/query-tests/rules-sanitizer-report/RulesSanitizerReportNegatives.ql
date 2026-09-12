import codeql.lua.RulesSanitizerReport

from string fixture, string forbidden, string evidence
where
  fixture = "cross-module-sanitizer/controller.luac" and
  forbidden = "callee-sanitized-path-emitted-active-report" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    source.getValueRef() = "root@pc20:r1" and
    sink.getModulePath() = fixture and
    sink.getValueRef() = "root@pc27:r4" and
    activeReportPath(source, sink, _, _, _) and
    evidence = source.toString() + " -> " + sink.toString()
  )
  or
  fixture = "callsite-balanced-report/input.luac" and
  forbidden = "cross-callsite-active-report" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    source.getValueRef() = "root@pc2:r1" and
    sink.getModulePath() = fixture and
    sink.getValueRef() = "root@pc11:r5" and
    activeReportPath(source, sink, _, _, _) and
    evidence = source.toString() + " -> " + sink.toString()
  )
  or
  fixture = "sanitizer-unsanitized-alternative/input.luac" and
  forbidden = "unsanitized-alternative-was-suppressed" and
  exists(
    string sourceRef, string sinkRef, string sanitizerCallsiteId, string sanitizerName,
    string appliesToSink, string onDataflowChain
  |
    sanitizerClassification(fixture, sourceRef, fixture, sinkRef, fixture, sanitizerCallsiteId,
      sanitizerName, appliesToSink, onDataflowChain, "sanitized") and
    evidence = sourceRef + " -> " + sinkRef
  )
  or
  fixture = "constant-sink-overmatch-negative/input.luac" and
  forbidden = "formvaluex-overmatched-source-rule" and
  exists(
    string callsiteId, string ruleKind, string trigger, string matchedName, int parameterIndex,
    string provenance
  |
    sourceSinkRuleMatch(fixture, callsiteId, ruleKind, trigger, matchedName, parameterIndex,
      provenance) and
    matchedName = "formvaluex" and
    evidence = callsiteId
  )
  or
  fixture = "constant-sink-overmatch-negative/input.luac" and
  forbidden = "executex-overmatched-sink-rule" and
  exists(
    string callsiteId, string ruleKind, string trigger, string matchedName, int parameterIndex,
    string provenance
  |
    sourceSinkRuleMatch(fixture, callsiteId, ruleKind, trigger, matchedName, parameterIndex,
      provenance) and
    matchedName = "executex" and
    evidence = callsiteId
  )
  or
  fixture = "constant-sink-overmatch-negative/input.luac" and
  forbidden = "constant-sink-argument-became-sink-endpoint" and
  exists(string sinkRef, string callsiteId, string trigger, int parameterIndex, string provenance |
    sinkEndpoint(fixture, sinkRef, callsiteId, trigger, parameterIndex, provenance) and
    evidence = callsiteId + " " + sinkRef
  )
  or
  fixture = "constant-sink-overmatch-negative/input.luac" and
  forbidden = "constant-sink-produced-active-report" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    activeReportPath(source, sink, _, _, _) and
    evidence = source.toString() + " -> " + sink.toString()
  )
  or
  fixture = "sanitizer-same-suffix-off-chain-negative/input.luac" and
  forbidden = "off-chain-sanitizer-suppressed-report" and
  exists(string sourceRef, string sinkRef, string classification, string reason |
    reportClassification(fixture, sourceRef, fixture, sinkRef, classification, reason) and
    classification = "sanitized" and
    evidence = sourceRef + " -> " + sinkRef
  )
  or
  fixture = "sanitizer-on-path/input.luac" and
  forbidden = "sanitized-path-emitted-active-report" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    activeReportPath(source, sink, _, _, _) and
    evidence = source.toString() + " -> " + sink.toString()
  )
  or
  fixture = "no-report-without-path-negative/input.luac" and
  forbidden = "endpoint-only-produced-active-report" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    activeReportPath(source, sink, _, _, _) and
    evidence = source.toString() + " -> " + sink.toString()
  )
  or
  fixture = "bc-kill-overwrite/input.luac" and
  forbidden = "killed-flow-produced-active-report" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    activeReportPath(source, sink, _, _, _) and
    evidence = source.toString() + " -> " + sink.toString()
  )
  or
  fixture = "bc-branch-negative/input.luac" and
  forbidden = "branch-negative-produced-active-report" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    activeReportPath(source, sink, _, _, _) and
    evidence = source.toString() + " -> " + sink.toString()
  )
select fixture, forbidden, evidence
