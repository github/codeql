/**
 * Provides Lua bytecode rules, sanitizer, and report semantics.
 *
 * This library builds report semantics from typed bytecode call sites and the
 * native generic flow graph.
 */

import codeql.lua.IntraproceduralSemantics
import codeql.lua.InterproceduralModuleTaint

private predicate sourceRuleName(string matchedName, string trigger) {
  matchedName = "formvalue" and
  trigger = "*.formvalue"
  or
  matchedName = "source" and
  trigger = "*.source"
}

private predicate sinkRuleName(string matchedName, string trigger) {
  matchedName = "execute" and trigger = "*.execute"
  or
  matchedName = "fork_exec" and trigger = "*.fork_exec"
  or
  matchedName = "fork_call" and trigger = "*.fork_call"
  or
  matchedName = "call" and trigger = "*.call"
  or
  matchedName = "exec" and trigger = "*.exec"
  or
  matchedName = "popen" and trigger = "*.popen"
  or
  matchedName = "execute_cmd" and trigger = "*.execute_cmd"
  or
  matchedName = "forkExec" and trigger = "*.forkExec"
  or
  matchedName = "execi" and trigger = "*.execi"
}

private predicate sanitizerRuleName(string matchedName) {
  matchedName = "shellquote" or
  matchedName = "tonumber" or
  matchedName = "parseCmdline" or
  matchedName = "_strformat" or
  matchedName = "_cmdformat" or
  matchedName = "macaddr" or
  matchedName = "macFormat" or
  matchedName = "ip4addr" or
  matchedName = "injection_test" or
  matchedName = "check_iface_name" or
  matchedName = "includeQuote" or
  matchedName = "checkTime" or
  matchedName = "doShell" or
  matchedName = "checkIp" or
  matchedName = "includeXxs" or
  matchedName = "filterExecShell" or
  matchedName = "binaryBase64Enc" or
  matchedName = "decCiphertext" or
  matchedName = "sha256" or
  matchedName = "setMacFilter" or
  matchedName = "setIpFilter" or
  matchedName = "apcli_get_connect" or
  matchedName = "setWifiAPMode" or
  matchedName = "cmdSafeCheck" or
  matchedName = "checkLanIpMask" or
  matchedName = "ipaddr" or
  matchedName = "lan_wan_ip_conflict_chk" or
  matchedName = "licenseActivated" or
  matchedName = "is_activated" or
  matchedName = "check_mac" or
  matchedName = "set_mac_filter" or
  matchedName = "encode" or
  matchedName = "getDstRule" or
  matchedName = "local_dev_data_check" or
  matchedName = "stat" or
  matchedName = "check_if_whitelist_opcode" or
  matchedName = "param_safety_check" or
  matchedName = "sqlite3_db_execute" or
  matchedName = "getStorageMountPathByUuid" or
  matchedName = "getWanIfname" or
  matchedName = "hackCharsCheck" or
  matchedName = "open" or
  matchedName = "del" or
  matchedName = "ip4mac" or
  matchedName = "match" or
  matchedName = "r29_0" or
  matchedName = "r3_0" or
  matchedName = "filePathGet" or
  matchedName = "checkPort" or
  matchedName = "setPTRules" or
  matchedName = "apcli_get_ifname_form_band"
}

private predicate typedRuleCall(
  string fixture, string prototypeId, string callsiteId, string matchedName
) {
  exists(LuaCallResolution resolution |
    resolution.getCallerModulePath() = fixture and
    resolution.getCallerPrototypeId() = prototypeId and
    resolution.getCallsiteId() = callsiteId and
    resolution.getResolvedName() != "" and
    matchedName = resolution.getResolvedName().regexpCapture("(^|.*\\.)([^.]+)$", 2)
  )
}

private predicate sourceCall(
  string fixture, string prototypeId, string callsiteId, string matchedName, int parameterIndex,
  string sourceRef
) {
  exists(LuaCallSite call, LuaRegisterEvent resultWrite |
    call.getFixtureId() = fixture and
    call.getPrototypeId() = prototypeId and
    call.getCallsiteId() = callsiteId and
    resultWrite.getInstruction() = call.getInstruction() and
    resultWrite.isWrite() and
    resultWrite.getSlot() = call.getFirstReturnSlot() and
    sourceRef = resultWrite.getValueRef() and
    sourceRuleName(matchedName, _) and
    typedRuleCall(fixture, prototypeId, callsiteId, matchedName) and
    parameterIndex = -1
  )
}

private predicate sinkCall(
  string fixture, string prototypeId, string callsiteId, string matchedName, int parameterIndex,
  string sinkRef
) {
  exists(LuaCallSite call, LuaRegisterEvent argumentRead |
    call.getFixtureId() = fixture and
    call.getPrototypeId() = prototypeId and
    call.getCallsiteId() = callsiteId and
    argumentRead.getInstruction() = call.getInstruction() and
    argumentRead.isRead() and
    argumentRead.getSlot() = call.getFirstArgSlot() and
    sinkRef = argumentRead.getValueRef() and
    sinkRuleName(matchedName, _) and
    typedRuleCall(fixture, prototypeId, callsiteId, matchedName) and
    parameterIndex = 0 and
    not uniqueConcreteFixedStringArgument(fixture, prototypeId, sinkRef)
  )
}

private predicate uniqueConcreteFixedStringArgument(
  string fixture, string prototypeId, string argumentRef
) {
  exists(LuaLocalFlow flow, LuaRegisterEvent loadWrite, LuaInstruction load, LuaConstant constant |
    flow.getModulePath() = fixture and
    flow.getPrototypeId() = prototypeId and
    flow.getSinkRef() = argumentRef and
    flow.getEdgeKind() = "reaching-definition" and
    loadWrite.getValueRef() = flow.getSourceRef() and
    loadWrite.isWrite() and
    loadWrite.getInstruction() = load and
    load.getFixtureId() = fixture and
    load.getPrototypeId() = prototypeId and
    load.getOpcode() = "LOADK" and
    loadWrite.getSlot() = load.getOperandA() and
    constant.getFixtureId() = fixture and
    constant.getPrototypeId() = prototypeId and
    constant.getLuaType() = "string" and
    constant.getIndex() = load.getOperandB() and
    not exists(LuaLocalFlow other |
      other.getModulePath() = fixture and
      other.getPrototypeId() = prototypeId and
      other.getSinkRef() = argumentRef and
      other.getEdgeKind() = "reaching-definition" and
      other.getSourceRef() != flow.getSourceRef()
    )
  )
}

predicate sourceSinkRuleMatch(
  string fixture, string callsiteId, string ruleKind, string trigger, string matchedName,
  int parameterIndex, string provenance
) {
  sourceCall(fixture, _, callsiteId, matchedName, parameterIndex, _) and
  sourceRuleName(matchedName, trigger) and
  ruleKind = "source" and
  provenance = "bytecode-only,ql-source-sink-rule,typed-call-resolution"
  or
  sinkCall(fixture, _, callsiteId, matchedName, parameterIndex, _) and
  sinkRuleName(matchedName, trigger) and
  ruleKind = "sink" and
  provenance = "bytecode-only,ql-source-sink-rule,typed-call-resolution"
}

predicate sourceEndpoint(
  string fixture, string sourceRef, string callsiteId, string trigger, string provenance
) {
  exists(string matchedName |
    sourceCall(fixture, _, callsiteId, matchedName, _, sourceRef) and
    sourceRuleName(matchedName, trigger) and
    provenance = "bytecode-only,ql-source-rule,typed-call-resolution"
  )
}

predicate sinkEndpoint(
  string fixture, string sinkRef, string callsiteId, string trigger, int parameterIndex,
  string provenance
) {
  exists(string matchedName |
    sinkCall(fixture, _, callsiteId, matchedName, parameterIndex, sinkRef) and
    sinkRuleName(matchedName, trigger) and
    provenance = "bytecode-only,ql-sink-rule,typed-call-resolution"
  )
}

predicate sanitizerCall(
  string fixture, string callsiteId, string sanitizerName, string sanitizedValueRef,
  string provenance
) {
  exists(LuaCallSite call, LuaCallResolution resolution |
    fixture = call.getFixtureId() and
    callsiteId = call.getCallsiteId() and
    resolution.getCallerModulePath() = call.getFixtureId() and
    resolution.getCallerPrototypeId() = call.getPrototypeId() and
    resolution.getCallsiteId() = call.getCallsiteId() and
    resolution.getResolvedName() != "" and
    sanitizerName = resolution.getResolvedName().regexpCapture("(^|.*\\.)([^.]+)$", 2) and
    sanitizerRuleName(sanitizerName) and
    (
      exists(LuaRegisterEvent resultWrite |
        resultWrite.getInstruction() = call.getInstruction() and
        resultWrite.isWrite() and
        resultWrite.getSlot() = call.getFirstReturnSlot() and
        sanitizedValueRef = resultWrite.getValueRef()
      )
      or
      not exists(LuaRegisterEvent resultWrite |
        resultWrite.getInstruction() = call.getInstruction() and
        resultWrite.isWrite() and
        resultWrite.getSlot() = call.getFirstReturnSlot()
      ) and
      sanitizedValueRef = ""
    ) and
    provenance = "bytecode-only,ql-sanitizer-call,typed-call-resolution"
  )
}

private predicate sanitizerOutput(string modulePath, string valueRef) {
  sanitizerCall(modulePath, _, _, valueRef, _) and
  valueRef != ""
}

private predicate sanitizerDerivedFieldWrite(string modulePath, string writeRef) {
  exists(string sanitizerValueRef |
    sanitizerOutput(modulePath, sanitizerValueRef) and
    genericFlowReachable(modulePath, sanitizerValueRef, modulePath, writeRef)
  )
}

private predicate fullySanitizedStaticFieldRead(string modulePath, string readRef) {
  exists(LuaTableFieldFlow flow |
    flow.getModulePath() = modulePath and
    flow.getReadRef() = readRef and
    sanitizerDerivedFieldWrite(modulePath, flow.getWriteRef()) and
    not exists(LuaTableFieldFlow other |
      other.getModulePath() = flow.getModulePath() and
      other.getTableRef() = flow.getTableRef() and
      other.getFieldName() = flow.getFieldName() and
      other.getReadRef() = flow.getReadRef() and
      not sanitizerDerivedFieldWrite(modulePath, other.getWriteRef())
    )
  )
}

predicate activeReportFlowStep(
  LuaFlowNode source, LuaFlowNode sink, string edgeKind, string provenance
) {
  flowNodeStep(source, sink, edgeKind, provenance) and
  unsanitizedFlowStep(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
    sink.getValueRef())
}

predicate activeReportPath(
  LuaFlowNode source, LuaFlowNode sink, string classification, string reason, string provenance
) {
  sourceEndpoint(source.getModulePath(), source.getValueRef(), _, _, _) and
  sinkEndpoint(sink.getModulePath(), sink.getValueRef(), _, _, _, _) and
  unsanitizedFlowReachable(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
    sink.getValueRef()) and
  classification = "true-positive" and
  reason = "unsanitized active source-to-sink path" and
  provenance = "bytecode-only,ql-native-active-report-path"
}

private predicate unsanitizedFlowStep(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef
) {
  genericFlowStep(sourceModule, sourceRef, sinkModule, sinkRef, _, _) and
  not sanitizerOutput(sinkModule, sinkRef)
}

private predicate unsanitizedNonCallFlowStep(string modulePath, string sourceRef, string sinkRef) {
  exists(string edgeKind |
    genericFlowStep(modulePath, sourceRef, modulePath, sinkRef, edgeKind, _) and
    edgeKind != "argument-to-parameter" and
    edgeKind != "argument-to-vararg" and
    edgeKind != "return-to-result" and
    not (
      edgeKind = "same-instruction-dependence" and
      resolvedCallLocalSummary(modulePath, sourceRef, sinkRef)
    ) and
    not (
      edgeKind = "same-instruction-dependence" and
      fullySanitizedStaticFieldRead(modulePath, sinkRef)
    ) and
    not sanitizerOutput(modulePath, sinkRef)
  )
}

private predicate resolvedCallLocalSummary(string modulePath, string sourceRef, string sinkRef) {
  exists(LuaInterproceduralFlow argumentFlow, LuaInterproceduralFlow returnFlow |
    pairedCallFlows(argumentFlow, returnFlow) and
    argumentFlow.getCallerModulePath() = modulePath and
    argumentFlow.getSourceRef() = sourceRef and
    returnFlow.getSinkRef() = sinkRef
  )
}

private predicate pairedCallFlows(
  LuaInterproceduralFlow argumentFlow, LuaInterproceduralFlow returnFlow
) {
  (
    argumentFlow.getFlowKind() = "argument-to-parameter" or
    argumentFlow.getFlowKind() = "argument-to-vararg"
  ) and
  returnFlow.getFlowKind() = "return-to-result" and
  argumentFlow.getCallerModulePath() = returnFlow.getCallerModulePath() and
  argumentFlow.getCallerPrototypeId() = returnFlow.getCallerPrototypeId() and
  argumentFlow.getCallsiteId() = returnFlow.getCallsiteId() and
  argumentFlow.getCalleeModulePath() = returnFlow.getCalleeModulePath() and
  argumentFlow.getCalleePrototypeId() = returnFlow.getCalleePrototypeId()
}

private predicate unsanitizedPairedCallFlows(
  LuaInterproceduralFlow argumentFlow, LuaInterproceduralFlow returnFlow
) {
  pairedCallFlows(argumentFlow, returnFlow) and
  not guardSanitizerBeforeRefUse(argumentFlow.getCalleeModulePath(), argumentFlow.getSinkRef(),
    returnFlow.getSourceRef())
}

private predicate guardSanitizerBeforeUse(string modulePath, string sourceRef, LuaInstruction use) {
  exists(
    LuaCallSite sanitizer, LuaRegisterEvent argumentRead, string sanitizerName,
    string sanitizedValueRef
  |
    sanitizer.getFixtureId() = modulePath and
    sanitizerCall(modulePath, sanitizer.getCallsiteId(), sanitizerName, sanitizedValueRef, _) and
    sanitizerArgumentRead(sanitizer, argumentRead) and
    sameModuleFlowReachable(modulePath, sourceRef, argumentRead.getValueRef()) and
    instructionDominates(sanitizer.getInstruction(), use)
  )
}

private predicate sanitizerArgumentRead(LuaCallSite sanitizer, LuaRegisterEvent argumentRead) {
  argumentRead.getInstruction() = sanitizer.getInstruction() and
  argumentRead.isRead() and
  argumentRead.getSlot() >= sanitizer.getFirstArgSlot() and
  argumentRead.getSlot() < sanitizer.getFirstArgSlot() + sanitizer.getArgCount()
}

private predicate guardSanitizerBeforeRefUse(string modulePath, string sourceRef, string useRef) {
  exists(LuaRegisterEvent useRead |
    useRead.getValueRef() = useRef and
    useRead.isRead() and
    useRead.getInstruction().getFixtureId() = modulePath and
    guardSanitizerBeforeUse(modulePath, sourceRef, useRead.getInstruction())
  )
}

private predicate unsanitizedSameLevelFlowStep(string modulePath, string sourceRef, string sinkRef) {
  unsanitizedNonCallFlowStep(modulePath, sourceRef, sinkRef)
  or
  exists(LuaInterproceduralFlow argumentFlow, LuaInterproceduralFlow returnFlow |
    unsanitizedPairedCallFlows(argumentFlow, returnFlow) and
    argumentFlow.getCallerModulePath() = modulePath and
    argumentFlow.getSourceRef() = sourceRef and
    returnFlow.getSinkRef() = sinkRef and
    not sanitizerOutput(argumentFlow.getCalleeModulePath(), argumentFlow.getSinkRef()) and
    not sanitizerOutput(modulePath, returnFlow.getSinkRef()) and
    (
      argumentFlow.getSinkRef() = returnFlow.getSourceRef() or
      unsanitizedSameLevelFlowReachable(argumentFlow.getCalleeModulePath(),
        argumentFlow.getSinkRef(), returnFlow.getSourceRef())
    )
  )
}

private predicate unsanitizedSameLevelFlowReachable(
  string modulePath, string sourceRef, string sinkRef
) {
  unsanitizedSameLevelFlowStep(modulePath, sourceRef, sinkRef)
  or
  exists(string middleRef |
    unsanitizedSameLevelFlowStep(modulePath, sourceRef, middleRef) and
    unsanitizedSameLevelFlowReachable(modulePath, middleRef, sinkRef)
  )
}

private predicate unsanitizedDownwardFlowReachable(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef
) {
  sourceModule = sinkModule and
  unsanitizedSameLevelFlowReachable(sourceModule, sourceRef, sinkRef) and
  not guardSanitizerBeforeRefUse(sourceModule, sourceRef, sinkRef)
  or
  exists(LuaInterproceduralFlow argumentFlow |
    (
      argumentFlow.getFlowKind() = "argument-to-parameter" or
      argumentFlow.getFlowKind() = "argument-to-vararg"
    ) and
    argumentFlow.getCallerModulePath() = sourceModule and
    not sanitizerOutput(argumentFlow.getCalleeModulePath(), argumentFlow.getSinkRef()) and
    (
      sourceRef = argumentFlow.getSourceRef() or
      unsanitizedSameLevelFlowReachable(sourceModule, sourceRef, argumentFlow.getSourceRef())
    ) and
    not guardSanitizerBeforeRefUse(sourceModule, sourceRef, argumentFlow.getSourceRef()) and
    (
      argumentFlow.getCalleeModulePath() = sinkModule and
      argumentFlow.getSinkRef() = sinkRef
      or
      unsanitizedDownwardFlowReachable(argumentFlow.getCalleeModulePath(),
        argumentFlow.getSinkRef(), sinkModule, sinkRef)
    )
  )
}

private predicate unsanitizedFlowReachable(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef
) {
  unsanitizedDownwardFlowReachable(sourceModule, sourceRef, sinkModule, sinkRef)
  or
  exists(LuaInterproceduralFlow returnFlow |
    returnFlow.getFlowKind() = "return-to-result" and
    returnFlow.getCalleeModulePath() = sourceModule and
    not sanitizerOutput(sourceModule, returnFlow.getSourceRef()) and
    not sanitizerOutput(returnFlow.getCallerModulePath(), returnFlow.getSinkRef()) and
    (
      sourceRef = returnFlow.getSourceRef() or
      unsanitizedSameLevelFlowReachable(sourceModule, sourceRef, returnFlow.getSourceRef())
    ) and
    not guardSanitizerBeforeRefUse(sourceModule, sourceRef, returnFlow.getSourceRef()) and
    (
      returnFlow.getCallerModulePath() = sinkModule and
      returnFlow.getSinkRef() = sinkRef
      or
      unsanitizedFlowReachable(returnFlow.getCallerModulePath(), returnFlow.getSinkRef(),
        sinkModule, sinkRef)
    )
  )
}

private predicate sanitizerResultOnChain(
  string sourceModule, string sourceRef, string sanitizerModule, string sanitizedValueRef,
  string sinkModule, string sinkRef
) {
  sanitizedValueRef != "" and
  genericFlowReachable(sourceModule, sourceRef, sanitizerModule, sanitizedValueRef) and
  genericFlowReachable(sanitizerModule, sanitizedValueRef, sinkModule, sinkRef)
}

bindingset[sourceModule, sourceRef, sanitizerModule, sanitizerCallsiteId, sanitizedValueRef,
  sinkModule, sinkRef]
private predicate sanitizerResultOnIndependentCallRoute(
  string sourceModule, string sourceRef, string sanitizerModule, string sanitizerCallsiteId,
  string sanitizedValueRef, string sinkModule, string sinkRef
) {
  exists(LuaCallSite sanitizer, LuaInterproceduralFlow routeEdge |
    sanitizer.getFixtureId() = sanitizerModule and
    sanitizer.getCallsiteId() = sanitizerCallsiteId and
    sanitizerDownwardFlowReachable(sourceModule, sourceRef, sanitizerModule, sanitizedValueRef) and
    (
      (
        routeEdge.getFlowKind() = "argument-to-parameter" or
        routeEdge.getFlowKind() = "argument-to-vararg"
      ) and
      routeEdge.getCallerModulePath() = sanitizerModule and
      routeEdge.getCallerPrototypeId() = sanitizer.getPrototypeId() and
      (
        sanitizedValueRef = routeEdge.getSourceRef() or
        sanitizerResultSameLevelFlowReachable(sanitizerModule, sanitizedValueRef,
          routeEdge.getSourceRef())
      ) and
      (
        routeEdge.getCalleeModulePath() = sinkModule and
        routeEdge.getSinkRef() = sinkRef
        or
        sanitizerDownwardFlowReachable(routeEdge.getCalleeModulePath(), routeEdge.getSinkRef(),
          sinkModule, sinkRef)
      ) and
      not unsanitizedRouteUsesCallEdge(sourceModule, sourceRef, sinkModule, sinkRef, routeEdge)
      or
      routeEdge.getFlowKind() = "return-to-result" and
      routeEdge.getCalleeModulePath() = sanitizerModule and
      routeEdge.getCalleePrototypeId() = sanitizer.getPrototypeId() and
      (
        sanitizedValueRef = routeEdge.getSourceRef() or
        sanitizerResultSameLevelFlowReachable(sanitizerModule, sanitizedValueRef,
          routeEdge.getSourceRef())
      ) and
      (
        routeEdge.getCallerModulePath() = sinkModule and
        routeEdge.getSinkRef() = sinkRef
        or
        sanitizerDownwardFlowReachable(routeEdge.getCallerModulePath(), routeEdge.getSinkRef(),
          sinkModule, sinkRef)
      ) and
      not unsanitizedRouteUsesReturnEdge(sourceModule, sourceRef, sinkModule, sinkRef, routeEdge)
    )
  )
}

private predicate sanitizerRouteNonCallFlowStep(string modulePath, string sourceRef, string sinkRef) {
  exists(string edgeKind |
    genericFlowStep(modulePath, sourceRef, modulePath, sinkRef, edgeKind, _) and
    edgeKind != "argument-to-parameter" and
    edgeKind != "argument-to-vararg" and
    edgeKind != "return-to-result" and
    not (
      edgeKind = "same-instruction-dependence" and
      resolvedCallLocalSummary(modulePath, sourceRef, sinkRef) and
      not sanitizerOutput(modulePath, sinkRef)
    )
  )
}

private predicate sanitizerRouteSameLevelFlowReachable(
  string modulePath, string sourceRef, string sinkRef
) {
  sanitizerRouteNonCallFlowStep(modulePath, sourceRef, sinkRef)
  or
  exists(string middleRef |
    sanitizerRouteNonCallFlowStep(modulePath, sourceRef, middleRef) and
    sanitizerRouteSameLevelFlowReachable(modulePath, middleRef, sinkRef)
  )
}

private predicate sanitizerResultSameLevelFlowStep(
  string modulePath, string sourceRef, string sinkRef
) {
  sanitizerRouteNonCallFlowStep(modulePath, sourceRef, sinkRef)
  or
  exists(LuaInterproceduralFlow argumentFlow, LuaInterproceduralFlow returnFlow |
    pairedCallFlows(argumentFlow, returnFlow) and
    argumentFlow.getCallerModulePath() = modulePath and
    argumentFlow.getSourceRef() = sourceRef and
    returnFlow.getSinkRef() = sinkRef and
    (
      argumentFlow.getSinkRef() = returnFlow.getSourceRef() or
      sanitizerResultSameLevelFlowReachable(argumentFlow.getCalleeModulePath(),
        argumentFlow.getSinkRef(), returnFlow.getSourceRef())
    )
  )
}

private predicate sanitizerResultSameLevelFlowReachable(
  string modulePath, string sourceRef, string sinkRef
) {
  sanitizerResultSameLevelFlowStep(modulePath, sourceRef, sinkRef)
  or
  exists(string middleRef |
    sanitizerResultSameLevelFlowStep(modulePath, sourceRef, middleRef) and
    sanitizerResultSameLevelFlowReachable(modulePath, middleRef, sinkRef)
  )
}

private predicate sanitizerDownwardFlowReachable(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef
) {
  sourceModule = sinkModule and
  sanitizerRouteSameLevelFlowReachable(sourceModule, sourceRef, sinkRef)
  or
  exists(LuaInterproceduralFlow argumentFlow |
    (
      argumentFlow.getFlowKind() = "argument-to-parameter" or
      argumentFlow.getFlowKind() = "argument-to-vararg"
    ) and
    argumentFlow.getCallerModulePath() = sourceModule and
    (
      sourceRef = argumentFlow.getSourceRef() or
      sanitizerRouteSameLevelFlowReachable(sourceModule, sourceRef, argumentFlow.getSourceRef())
    ) and
    (
      argumentFlow.getCalleeModulePath() = sinkModule and
      argumentFlow.getSinkRef() = sinkRef
      or
      sanitizerDownwardFlowReachable(argumentFlow.getCalleeModulePath(), argumentFlow.getSinkRef(),
        sinkModule, sinkRef)
    )
  )
}

private predicate unsanitizedRouteUsesCallEdge(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef,
  LuaInterproceduralFlow routeEdge
) {
  exists(LuaInterproceduralFlow activeEdge |
    (
      activeEdge.getFlowKind() = "argument-to-parameter" or
      activeEdge.getFlowKind() = "argument-to-vararg"
    ) and
    activeEdge.getCallerModulePath() = routeEdge.getCallerModulePath() and
    activeEdge.getCallerPrototypeId() = routeEdge.getCallerPrototypeId() and
    activeEdge.getCalleeModulePath() = routeEdge.getCalleeModulePath() and
    activeEdge.getCalleePrototypeId() = routeEdge.getCalleePrototypeId() and
    unsanitizedDownwardFlowReachable(sourceModule, sourceRef, activeEdge.getCallerModulePath(),
      activeEdge.getSourceRef()) and
    unsanitizedDownwardFlowReachable(activeEdge.getCalleeModulePath(), activeEdge.getSinkRef(),
      sinkModule, sinkRef)
  )
}

private predicate unsanitizedRouteUsesReturnEdge(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef,
  LuaInterproceduralFlow routeEdge
) {
  exists(LuaInterproceduralFlow activeEdge |
    activeEdge.getFlowKind() = "return-to-result" and
    activeEdge.getCallerModulePath() = routeEdge.getCallerModulePath() and
    activeEdge.getCallerPrototypeId() = routeEdge.getCallerPrototypeId() and
    activeEdge.getCalleeModulePath() = routeEdge.getCalleeModulePath() and
    activeEdge.getCalleePrototypeId() = routeEdge.getCalleePrototypeId() and
    unsanitizedDownwardFlowReachable(sourceModule, sourceRef, activeEdge.getCalleeModulePath(),
      activeEdge.getSourceRef()) and
    unsanitizedDownwardFlowReachable(activeEdge.getCallerModulePath(), activeEdge.getSinkRef(),
      sinkModule, sinkRef)
  )
}

bindingset[sourceModule, sourceRef, sinkModule, sinkRef]
private predicate guardSanitizerOnPath(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef, string sanitizerModule,
  string sanitizerCallsiteId, string sanitizerName
) {
  exists(LuaCallSite sanitizer, LuaRegisterEvent argumentRead, string sanitizedValueRef |
    sanitizerCall(sanitizerModule, sanitizerCallsiteId, sanitizerName, sanitizedValueRef, _) and
    not sanitizerResultOnChain(sourceModule, sourceRef, sanitizerModule, sanitizedValueRef,
      sinkModule, sinkRef) and
    sanitizer.getFixtureId() = sanitizerModule and
    sanitizer.getCallsiteId() = sanitizerCallsiteId and
    sanitizerArgumentRead(sanitizer, argumentRead) and
    genericFlowReachable(sourceModule, sourceRef, sanitizerModule, argumentRead.getValueRef()) and
    (
      exists(LuaRegisterEvent sinkRead |
        sinkRead.getValueRef() = sinkRef and
        sinkRead.isRead() and
        sinkRead.getInstruction().getFixtureId() = sinkModule and
        instructionDominates(sanitizer.getInstruction(), sinkRead.getInstruction())
      )
      or
      exists(
        LuaInterproceduralFlow outgoingFlow, LuaCallSite outgoingCall, LuaRegisterEvent outgoingRead
      |
        (
          outgoingFlow.getFlowKind() = "argument-to-parameter" or
          outgoingFlow.getFlowKind() = "argument-to-vararg"
        ) and
        outgoingFlow.getCallerModulePath() = sanitizerModule and
        outgoingCall.getFixtureId() = outgoingFlow.getCallerModulePath() and
        outgoingCall.getPrototypeId() = outgoingFlow.getCallerPrototypeId() and
        outgoingCall.getCallsiteId() = outgoingFlow.getCallsiteId() and
        outgoingRead.getInstruction() = outgoingCall.getInstruction() and
        outgoingRead.isRead() and
        outgoingRead.getValueRef() = outgoingFlow.getSourceRef() and
        genericFlowReachable(sourceModule, sourceRef, sanitizerModule, outgoingRead.getValueRef()) and
        instructionDominates(sanitizer.getInstruction(), outgoingCall.getInstruction()) and
        (
          outgoingFlow.getCalleeModulePath() = sinkModule and
          outgoingFlow.getSinkRef() = sinkRef
          or
          downwardCallFlowReachable(outgoingFlow.getCalleeModulePath(), outgoingFlow.getSinkRef(),
            sinkModule, sinkRef)
        )
      )
    )
  )
}

private predicate sanitizedClassification(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef, string sanitizerModule,
  string sanitizerCallsiteId, string sanitizerName
) {
  sourceEndpoint(sourceModule, sourceRef, _, _, _) and
  sinkEndpoint(sinkModule, sinkRef, _, _, _, _) and
  genericFlowReachable(sourceModule, sourceRef, sinkModule, sinkRef) and
  exists(string sanitizedValueRef |
    sanitizerCall(sanitizerModule, sanitizerCallsiteId, sanitizerName, sanitizedValueRef, _) and
    (
      guardSanitizerOnPath(sourceModule, sourceRef, sinkModule, sinkRef, sanitizerModule,
        sanitizerCallsiteId, sanitizerName)
      or
      sanitizerResultOnChain(sourceModule, sourceRef, sanitizerModule, sanitizedValueRef,
        sinkModule, sinkRef)
    ) and
    (
      not unsanitizedFlowReachable(sourceModule, sourceRef, sinkModule, sinkRef)
      or
      sanitizerResultOnIndependentCallRoute(sourceModule, sourceRef, sanitizerModule,
        sanitizerCallsiteId, sanitizedValueRef, sinkModule, sinkRef)
    )
  )
}

predicate sanitizedReportPath(LuaFlowNode source, LuaFlowNode sink) {
  sanitizedClassification(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
    sink.getValueRef(), _, _, _)
}

private predicate notSanitizedClassification(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef, string sanitizerModule,
  string sanitizerCallsiteId, string sanitizerName, string appliesToSink, string onDataflowChain
) {
  sourceEndpoint(sourceModule, sourceRef, _, _, _) and
  sinkEndpoint(sinkModule, sinkRef, _, _, _, _) and
  genericFlowReachable(sourceModule, sourceRef, sinkModule, sinkRef) and
  exists(string sanitizedValueRef |
    sanitizerCall(sanitizerModule, sanitizerCallsiteId, sanitizerName, sanitizedValueRef, _) and
    (
      sanitizerModule = sourceModule and
      not guardSanitizerOnPath(sourceModule, sourceRef, sinkModule, sinkRef, sanitizerModule,
        sanitizerCallsiteId, sanitizerName) and
      not sanitizerResultOnChain(sourceModule, sourceRef, sanitizerModule, sanitizedValueRef,
        sinkModule, sinkRef) and
      appliesToSink = "false" and
      onDataflowChain = "false"
      or
      sanitizerResultOnChain(sourceModule, sourceRef, sanitizerModule, sanitizedValueRef,
        sinkModule, sinkRef) and
      unsanitizedFlowReachable(sourceModule, sourceRef, sinkModule, sinkRef) and
      appliesToSink = "true" and
      onDataflowChain = "true"
    )
  )
}

predicate sanitizerClassification(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef, string sanitizerModule,
  string sanitizerCallsiteId, string sanitizerName, string appliesToSink, string onDataflowChain,
  string classification
) {
  sanitizedClassification(sourceModule, sourceRef, sinkModule, sinkRef, sanitizerModule,
    sanitizerCallsiteId, sanitizerName) and
  appliesToSink = "true" and
  onDataflowChain = "true" and
  classification = "sanitized"
  or
  notSanitizedClassification(sourceModule, sourceRef, sinkModule, sinkRef, sanitizerModule,
    sanitizerCallsiteId, sanitizerName, appliesToSink, onDataflowChain) and
  classification = "not-sanitized"
}

predicate reportClassification(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef, string classification,
  string reason
) {
  sanitizedClassification(sourceModule, sourceRef, sinkModule, sinkRef, _, _, _) and
  classification = "sanitized" and
  reason = "sanitized path suppressed"
  or
  exists(LuaFlowNode source, LuaFlowNode sink, string provenance |
    source.getModulePath() = sourceModule and
    source.getValueRef() = sourceRef and
    sink.getModulePath() = sinkModule and
    sink.getValueRef() = sinkRef and
    activeReportPath(source, sink, classification, reason, provenance)
  )
}
