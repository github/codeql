import codeql.lua.InterproceduralModuleTaint

from string fixture, string capability, string evidence
where
  fixture = "callsite-balanced-identity/input.luac" and
  capability = "generic.callsite-balanced-positive" and
  genericFlowReachable(fixture, "root@pc5:r3", fixture, "root@pc5:r2") and
  evidence = "root@pc5:r3 -> root@pc5:r2"
  or
  capability = "analysis.unresolved-call-boundary" and
  fixture = "unresolved-callee-negative/input.luac" and
  exists(LuaAnalysisBoundary boundary |
    boundary.getModulePath() = fixture and
    boundary.getPrototypeId() = "root.2" and
    boundary.getSiteId() = "root.2@pc2" and
    boundary.getBoundaryKind() = "unresolved-call-target" and
    boundary.getReason() = "param-derived" and
    boundary.getProvenance() = "bytecode-only,call-resolution-boundary" and
    evidence =
      boundary.getPrototypeId() + " " + boundary.getSiteId() + " " + boundary.getBoundaryKind() +
        " " + boundary.getReason() + " " + boundary.getProvenance()
  )
  or
  capability = "generic.cross-module-step" and
  fixture = "cross-module-webcmd-popen/controller.luac" and
  genericFlowStep(fixture, "root.1@pc8:r2", "cross-module-webcmd-popen/mtkwifi.luac", "root.1:r0",
    "argument-to-parameter", _) and
  genericFlowReachable(fixture, "root.1@pc8:r2", "cross-module-webcmd-popen/mtkwifi.luac",
    "root.1:r0") and
  evidence = fixture + "::root.1@pc8:r2 -> " + "cross-module-webcmd-popen/mtkwifi.luac::root.1:r0"
  or
  capability = "generic.interproc-reachable" and
  fixture = "bc-taint-minimal-path/input.luac" and
  exists(string returnProvenance, string argumentProvenance |
    genericFlowStep(fixture, "root.0@pc1:r0", fixture, "root@pc3:r2", "return-to-result",
      returnProvenance) and
    genericFlowReachable(fixture, "root@pc3:r2", fixture, "root@pc6:r4") and
    genericFlowStep(fixture, "root@pc6:r4", fixture, "root.1:r0", "argument-to-parameter",
      argumentProvenance) and
    genericFlowReachable(fixture, "root.0@pc1:r0", fixture, "root.1:r0")
  ) and
  evidence = fixture + "::root.0@pc1:r0 -> " + fixture + "::root.1:r0"
  or
  capability = "generic.local-reachable" and
  fixture = "bc-taint-minimal-path/input.luac" and
  genericFlowReachable(fixture, "root@pc3:r2", fixture, "root@pc6:r4") and
  evidence = fixture + "::root@pc3:r2 -> " + fixture + "::root@pc6:r4"
  or
  capability = "path.same-module-interprocedural-complete" and
  fixture = "same-module-formvalue-execute/input.luac" and
  exists(
    LuaFlowNode source, LuaFlowNode outerResult, LuaFlowNode callerRead, LuaFlowNode callerDerived,
    LuaFlowNode argument, LuaFlowNode parameter, LuaFlowNode calleeRead, LuaFlowNode calleeDerived,
    LuaFlowNode sink
  |
    source.getModulePath() = fixture and
    source.getValueRef() = "root.2@pc4:r0" and
    outerResult.getModulePath() = fixture and
    outerResult.getValueRef() = "root@pc15:r2" and
    callerRead.getModulePath() = fixture and
    callerRead.getValueRef() = "root@pc17:r2" and
    callerDerived.getModulePath() = fixture and
    callerDerived.getValueRef() = "root@pc17:r4" and
    argument.getModulePath() = fixture and
    argument.getValueRef() = "root@pc18:r4" and
    parameter.getModulePath() = fixture and
    parameter.getValueRef() = "root.3:r0" and
    calleeRead.getModulePath() = fixture and
    calleeRead.getValueRef() = "root.3@pc2:r0" and
    calleeDerived.getModulePath() = fixture and
    calleeDerived.getValueRef() = "root.3@pc2:r2" and
    sink.getModulePath() = fixture and
    sink.getValueRef() = "root.3@pc3:r2" and
    flowNodeStep(source, outerResult, "return-to-result", _) and
    flowNodeStep(outerResult, callerRead, "reaching-definition", _) and
    flowNodeStep(callerRead, callerDerived, "same-instruction-dependence", _) and
    flowNodeStep(callerDerived, argument, "reaching-definition", _) and
    flowNodeStep(argument, parameter, "argument-to-parameter", _) and
    flowNodeStep(parameter, calleeRead, "reaching-definition", _) and
    flowNodeStep(calleeRead, calleeDerived, "same-instruction-dependence", _) and
    flowNodeStep(calleeDerived, sink, "reaching-definition", _) and
    genericFlowReachable(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
      sink.getValueRef()) and
    evidence =
      source.toString() + " -> " + outerResult.toString() + " -> " + callerRead.toString() + " -> " +
        callerDerived.toString() + " -> " + argument.toString() + " -> " + parameter.toString() +
        " -> " + calleeRead.toString() + " -> " + calleeDerived.toString() + " -> " +
        sink.toString()
  )
  or
  capability = "path.cross-module-complete" and
  fixture = "cross-module-webcmd-popen/controller.luac" and
  exists(
    LuaFlowNode source, LuaFlowNode callerRead, LuaFlowNode callerDerived, LuaFlowNode argument,
    LuaFlowNode parameter, LuaFlowNode calleeRead, LuaFlowNode calleeDerived, LuaFlowNode sink
  |
    source.getModulePath() = fixture and
    source.getValueRef() = "root.1@pc4:r0" and
    callerRead.getModulePath() = fixture and
    callerRead.getValueRef() = "root.1@pc7:r0" and
    callerDerived.getModulePath() = fixture and
    callerDerived.getValueRef() = "root.1@pc7:r2" and
    argument.getModulePath() = fixture and
    argument.getValueRef() = "root.1@pc8:r2" and
    parameter.getModulePath() = "cross-module-webcmd-popen/mtkwifi.luac" and
    parameter.getValueRef() = "root.1:r0" and
    calleeRead.getModulePath() = "cross-module-webcmd-popen/mtkwifi.luac" and
    calleeRead.getValueRef() = "root.1@pc2:r0" and
    calleeDerived.getModulePath() = "cross-module-webcmd-popen/mtkwifi.luac" and
    calleeDerived.getValueRef() = "root.1@pc2:r2" and
    sink.getModulePath() = "cross-module-webcmd-popen/mtkwifi.luac" and
    sink.getValueRef() = "root.1@pc3:r2" and
    flowNodeStep(source, callerRead, "reaching-definition", _) and
    flowNodeStep(callerRead, callerDerived, "same-instruction-dependence", _) and
    flowNodeStep(callerDerived, argument, "reaching-definition", _) and
    flowNodeStep(argument, parameter, "argument-to-parameter", _) and
    flowNodeStep(parameter, calleeRead, "reaching-definition", _) and
    flowNodeStep(calleeRead, calleeDerived, "same-instruction-dependence", _) and
    flowNodeStep(calleeDerived, sink, "reaching-definition", _) and
    genericFlowReachable(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
      sink.getValueRef()) and
    evidence =
      source.toString() + " -> " + callerRead.toString() + " -> " + callerDerived.toString() +
        " -> " + argument.toString() + " -> " + parameter.toString() + " -> " +
        calleeRead.toString() + " -> " + calleeDerived.toString() + " -> " + sink.toString()
  )
  or
  capability = "interproc.arg-flow" and
  exists(
    string callsiteId, string fromArg, string targetModule, string targetPrototype,
    string parameter, string provenance
  |
    interproceduralArgFlow(fixture, callsiteId, fromArg, targetModule, targetPrototype, parameter,
      provenance) and
    evidence = callsiteId + " " + fromArg + " -> " + targetModule + "::" + parameter
  )
  or
  capability = "interproc.return-flow" and
  exists(
    string callsiteId, string targetModule, string targetPrototype, string calleeReturn,
    string callerResult, string provenance
  |
    interproceduralReturnFlow(fixture, callsiteId, targetModule, targetPrototype, calleeReturn,
      callerResult, provenance) and
    evidence = callsiteId + " " + targetModule + "::" + calleeReturn + " -> " + callerResult
  )
  or
  capability = "module.literal-require" and
  fixture = "module-return-table-field-call/controller.luac" and
  exists(
    string modulePath, string prototypeId, int pc, string callsiteId, string requireString,
    string argumentRef, string provenance
  |
    literalRequireCall(fixture, modulePath, prototypeId, pc, callsiteId, requireString, argumentRef,
      provenance) and
    evidence = callsiteId + " requires " + requireString + " via " + argumentRef
  )
  or
  capability = "module.typed-resolution" and
  exists(LuaModuleResolution resolution |
    fixture = resolution.getCallerModulePath() and
    fixture = "cross-module-webcmd-popen/controller.luac" and
    resolution.getStatus() = "matched" and
    evidence =
      resolution.getCallsiteId() + " " + resolution.getRequireString() + " -> " +
        resolution.getTargetModulePath()
  )
  or
  capability = "module.require-resolution" and
  exists(
    string callsiteId, string requireString, string status, string fromModule, string targetModule,
    string reason, string provenance
  |
    moduleResolution(fixture, callsiteId, requireString, status, fromModule, targetModule, reason,
      provenance) and
    status = "matched" and
    evidence = fromModule + " requires " + requireString + " -> " + targetModule
  )
  or
  capability = "module.typed-export" and
  exists(LuaModuleExport export |
    fixture = export.getModulePath() and
    export.getExportKind() = "returned-table-field" and
    evidence =
      export.getFieldName() + " " + export.getValueRef() + " -> " + export.getTargetPrototypeId()
  )
  or
  capability = "module.export-return-table" and
  exists(
    string modulePath, string exportKind, string fieldName, string valueRef, string targetPrototype,
    string provenance
  |
    moduleExport(fixture, modulePath, exportKind, fieldName, valueRef, targetPrototype, provenance) and
    exportKind = "returned-table-field" and
    evidence = modulePath + " exports " + fieldName + " -> " + targetPrototype
  )
  or
  capability = "module.field-target" and
  exists(
    string fromModule, string callsiteId, string fieldName, string targetModule,
    string targetPrototype, string provenance
  |
    moduleFieldCallTarget(fixture, fromModule, callsiteId, fieldName, targetModule, targetPrototype,
      provenance) and
    evidence =
      callsiteId + " " + fieldName + " -> " + targetModule + "::" + targetPrototype + " via " +
        provenance
  )
  or
  capability = "calltarget.cross-boundary" and
  exists(
    string callsiteId, string targetModule, string targetPrototype, string confidence,
    string provenance
  |
    crossBoundaryCallTargetCandidate(fixture, callsiteId, targetModule, targetPrototype, confidence,
      provenance) and
    evidence = callsiteId + " -> " + targetModule + "::" + targetPrototype
  )
select fixture, capability, evidence
