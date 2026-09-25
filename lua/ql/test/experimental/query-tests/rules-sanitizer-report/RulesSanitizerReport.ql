import codeql.lua.RulesSanitizerReport

from string fixture, string capability, string evidence
where
  capability = "report.path.local-complete" and
  fixture = "formvalue-os-execute-chain/input.luac" and
  exists(LuaFlowNode source, LuaFlowNode firstMiddle, LuaFlowNode secondMiddle, LuaFlowNode sink |
    source.getModulePath() = fixture and
    source.getValueRef() = "root@pc16:r0" and
    firstMiddle.getModulePath() = fixture and
    firstMiddle.getValueRef() = "root@pc19:r0" and
    secondMiddle.getModulePath() = fixture and
    secondMiddle.getValueRef() = "root@pc19:r2" and
    sink.getModulePath() = fixture and
    sink.getValueRef() = "root@pc20:r2" and
    activeReportPath(source, sink, "true-positive", "unsanitized active source-to-sink path",
      "bytecode-only,ql-native-active-report-path") and
    activeReportFlowStep(source, firstMiddle, _, _) and
    activeReportFlowStep(firstMiddle, secondMiddle, _, _) and
    activeReportFlowStep(secondMiddle, sink, _, _) and
    evidence =
      source.toString() + " -> " + firstMiddle.toString() + " -> " + secondMiddle.toString() +
        " -> " + sink.toString()
  )
  or
  capability = "sanitizer-call.callee-module" and
  fixture = "cross-module-sanitizer/sanitizer.luac" and
  sanitizerCall(fixture, "root.0@pc2", "shellquote", "root.0@pc2:r1",
    "bytecode-only,ql-sanitizer-call,typed-call-resolution") and
  evidence = "root.0@pc2 shellquote -> root.0@pc2:r1 typed-call-resolution"
  or
  capability = "sanitizer.classification.callee-module" and
  fixture = "cross-module-sanitizer/controller.luac" and
  sanitizerClassification(fixture, "root@pc20:r1", fixture, "root@pc27:r4",
    "cross-module-sanitizer/sanitizer.luac", "root.0@pc2", "shellquote", "true", "true", "sanitized") and
  evidence =
    "root@pc20:r1 -> root@pc27:r4 sanitizer=cross-module-sanitizer/sanitizer.luac::root.0@pc2:shellquote classification=sanitized"
  or
  capability = "sanitizer-call.typed-resolution" and
  fixture = "sanitizer-on-path/input.luac" and
  sanitizerCall(fixture, "root@pc20", "tonumber", "root@pc20:r2",
    "bytecode-only,ql-sanitizer-call,typed-call-resolution") and
  evidence = "root@pc20 tonumber -> root@pc20:r2 typed-call-resolution"
  or
  capability = "sanitizer-call.cross-module" and
  fixture = "sanitizer-cross-module-return/controller.luac" and
  sanitizerCall(fixture, "root@pc23", "shellquote", "root@pc23:r2",
    "bytecode-only,ql-sanitizer-call,typed-call-resolution") and
  evidence = "root@pc23 shellquote -> root@pc23:r2 typed-call-resolution"
  or
  capability = "sanitizer.classification.cross-module" and
  fixture = "sanitizer-cross-module-return/controller.luac" and
  sanitizerClassification(fixture, "root@pc20:r1", fixture, "root@pc27:r4", fixture, "root@pc23",
    "shellquote", "true", "true", "sanitized") and
  evidence = "root@pc20:r1 -> root@pc27:r4 sanitizer=root@pc23:shellquote classification=sanitized"
  or
  capability = "source-endpoint.typed-resolution" and
  fixture = "formvalue-os-execute-chain/input.luac" and
  sourceEndpoint(fixture, "root@pc16:r0", "root@pc16", "*.formvalue",
    "bytecode-only,ql-source-rule,typed-call-resolution") and
  evidence = "root@pc16 *.formvalue -> root@pc16:r0 typed-call-resolution"
  or
  capability = "source-sink.rule-match" and
  exists(
    string callsiteId, string ruleKind, string trigger, string matchedName, int parameterIndex,
    string provenance
  |
    sourceSinkRuleMatch(fixture, callsiteId, ruleKind, trigger, matchedName, parameterIndex,
      provenance) and
    evidence =
      callsiteId + " " + ruleKind + " " + trigger + " -> " + matchedName + " param=" +
        parameterIndex.toString() + " " + provenance
  )
  or
  capability = "source-endpoint" and
  exists(string sourceRef, string callsiteId, string trigger, string provenance |
    sourceEndpoint(fixture, sourceRef, callsiteId, trigger, provenance) and
    evidence = callsiteId + " " + trigger + " -> " + sourceRef + " " + provenance
  )
  or
  capability = "sink-endpoint" and
  exists(string sinkRef, string callsiteId, string trigger, int parameterIndex, string provenance |
    sinkEndpoint(fixture, sinkRef, callsiteId, trigger, parameterIndex, provenance) and
    evidence =
      callsiteId + " " + trigger + " param=" + parameterIndex.toString() + " -> " + sinkRef + " " +
        provenance
  )
  or
  capability = "sanitizer.classification" and
  exists(
    string sourceRef, string sinkModule, string sinkRef, string sanitizerModule,
    string sanitizerCallsiteId, string sanitizerName, string appliesToSink, string onDataflowChain,
    string classification
  |
    sanitizerClassification(fixture, sourceRef, sinkModule, sinkRef, sanitizerModule,
      sanitizerCallsiteId, sanitizerName, appliesToSink, onDataflowChain, classification) and
    evidence =
      sourceRef + " -> " + sinkRef + " sanitizer=" + sanitizerCallsiteId + ":" + sanitizerName +
        " applies=" + appliesToSink + " chain=" + onDataflowChain + " classification=" +
        classification
  )
  or
  capability = "report.sanitized-positive-only" and
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    sanitizedReportPath(source, sink) and
    evidence = source.toString() + " -> " + sink.toString()
  )
  or
  capability = "report.classification" and
  exists(string sourceRef, string sinkModule, string sinkRef, string classification, string reason |
    reportClassification(fixture, sourceRef, sinkModule, sinkRef, classification, reason) and
    evidence = sourceRef + " -> " + sinkRef + " " + classification + " " + reason
  )
select fixture, capability, evidence
