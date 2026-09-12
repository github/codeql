/**
 * Provides Lua bytecode interprocedural, module, and taint semantics.
 *
 * This library derives interprocedural and module relations from
 * extractor-owned bytecode and intraprocedural semantic facts.
 */

import codeql.lua.Bytecode
import codeql.lua.IntraproceduralSemantics

private predicate acceptedArtifactPath(string fixture, string path) {
  exists(LuaArtifact artifact |
    artifact.getFixtureId() = fixture and
    artifact.getPath() = path and
    artifact.isAccepted()
  )
}

predicate moduleIdentity(string fixture, string modulePath, string moduleName, string provenance) {
  acceptedArtifactPath(fixture, modulePath) and
  moduleName = modulePath.regexpCapture("(^|.*/)([^/]+)\\.luac$", 2) and
  provenance = "bytecode-only,module-path"
}

predicate literalRequireCall(
  string fixture, string modulePath, string prototypeId, int pc, string callsiteId,
  string requireString, string argumentValueRef, string provenance
) {
  exists(LuaLiteralRequire require, LuaCallSite call |
    fixture = require.getCallerModulePath() and
    modulePath = require.getCallerModulePath() and
    prototypeId = require.getCallerPrototypeId() and
    callsiteId = require.getCallsiteId() and
    requireString = require.getRequireString() and
    argumentValueRef = require.getArgumentRef() and
    provenance = require.getProvenance() and
    call.getFixtureId() = require.getCallerModulePath() and
    call.getCallsiteId() = require.getCallsiteId() and
    pc = call.getPc()
  )
}

predicate moduleResolution(
  string fixture, string requireCallsiteId, string requireString, string resolutionStatus,
  string fromModulePath, string targetModulePath, string unresolvedReason, string provenance
) {
  exists(LuaModuleResolution resolution |
    fixture = resolution.getCallerModulePath() and
    requireCallsiteId = resolution.getCallsiteId() and
    requireString = resolution.getRequireString() and
    resolutionStatus = resolution.getStatus() and
    fromModulePath = resolution.getCallerModulePath() and
    targetModulePath = resolution.getTargetModulePath() and
    unresolvedReason = resolution.getReason() and
    provenance = resolution.getProvenance()
  )
}

predicate moduleExport(
  string fixture, string modulePath, string exportKind, string fieldName, string valueRef,
  string targetPrototypeId, string provenance
) {
  exists(LuaModuleExport export |
    fixture = export.getModulePath() and
    modulePath = export.getModulePath() and
    exportKind = export.getExportKind() and
    fieldName = export.getFieldName() and
    valueRef = export.getValueRef() and
    targetPrototypeId = export.getTargetPrototypeId() and
    provenance = export.getProvenance()
  )
}

predicate moduleFieldCallTarget(
  string fixture, string fromModulePath, string callsiteId, string fieldName,
  string targetModulePath, string targetPrototypeId, string provenance
) {
  exists(LuaCallResolution resolution, LuaLiteralRequire require, LuaModuleExport export |
    resolution.getResolutionKind() = "module-field-export" and
    fixture = resolution.getCallerModulePath() and
    fromModulePath = resolution.getCallerModulePath() and
    callsiteId = resolution.getCallsiteId() and
    targetModulePath = resolution.getTargetModulePath() and
    targetPrototypeId = resolution.getTargetPrototypeId() and
    provenance = resolution.getProvenance() and
    require.getCallerModulePath() = resolution.getCallerModulePath() and
    resolution.getResolvedName() = require.getRequireString() + "." + fieldName and
    export.getModulePath() = resolution.getTargetModulePath() and
    fieldName = export.getFieldName() and
    export.getTargetPrototypeId() = resolution.getTargetPrototypeId()
  )
}

predicate interproceduralArgFlow(
  string fixture, string callsiteId, string fromArgumentRef, string targetModulePath,
  string targetPrototypeId, string toParameterRef, string provenance
) {
  exists(LuaInterproceduralFlow flow |
    fixture = flow.getCallerModulePath() and
    callsiteId = flow.getCallsiteId() and
    fromArgumentRef = flow.getSourceRef() and
    targetModulePath = flow.getCalleeModulePath() and
    targetPrototypeId = flow.getCalleePrototypeId() and
    toParameterRef = flow.getSinkRef() and
    provenance = flow.getProvenance() and
    (
      flow.getFlowKind() = "argument-to-parameter" or
      flow.getFlowKind() = "argument-to-vararg"
    )
  )
}

predicate interproceduralReturnFlow(
  string fixture, string callsiteId, string targetModulePath, string targetPrototypeId,
  string calleeReturnRef, string callerResultRef, string provenance
) {
  exists(LuaInterproceduralFlow flow |
    fixture = flow.getCallerModulePath() and
    callsiteId = flow.getCallsiteId() and
    targetModulePath = flow.getCalleeModulePath() and
    targetPrototypeId = flow.getCalleePrototypeId() and
    calleeReturnRef = flow.getSourceRef() and
    callerResultRef = flow.getSinkRef() and
    provenance = flow.getProvenance() and
    flow.getFlowKind() = "return-to-result"
  )
}

predicate genericFlowStep(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef, string edgeKind,
  string provenance
) {
  exists(LuaLocalFlow flow |
    sourceModule = flow.getModulePath() and
    sourceRef = flow.getSourceRef() and
    sinkModule = flow.getModulePath() and
    sinkRef = flow.getSinkRef() and
    edgeKind = flow.getEdgeKind() and
    provenance = flow.getProvenance()
  )
  or
  exists(LuaTableFieldFlow flow |
    sourceModule = flow.getModulePath() and
    sourceRef = flow.getWriteRef() and
    sinkModule = flow.getModulePath() and
    sinkRef = flow.getReadRef() and
    edgeKind = "table-field" and
    provenance = flow.getProvenance()
  )
  or
  exists(LuaInterproceduralFlow flow |
    edgeKind = flow.getFlowKind() and
    provenance = flow.getProvenance() and
    (
      (
        flow.getFlowKind() = "argument-to-parameter" or
        flow.getFlowKind() = "argument-to-vararg"
      ) and
      sourceModule = flow.getCallerModulePath() and
      sourceRef = flow.getSourceRef() and
      sinkModule = flow.getCalleeModulePath() and
      sinkRef = flow.getSinkRef()
      or
      flow.getFlowKind() = "return-to-result" and
      sourceModule = flow.getCalleeModulePath() and
      sourceRef = flow.getSourceRef() and
      sinkModule = flow.getCallerModulePath() and
      sinkRef = flow.getSinkRef()
    )
  )
}

private predicate nonCallFlowStep(string modulePath, string sourceRef, string sinkRef) {
  exists(LuaLocalFlow flow |
    flow.getModulePath() = modulePath and
    flow.getSourceRef() = sourceRef and
    flow.getSinkRef() = sinkRef
  )
  or
  exists(LuaTableFieldFlow flow |
    flow.getModulePath() = modulePath and
    flow.getWriteRef() = sourceRef and
    flow.getReadRef() = sinkRef
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

private predicate sameLevelFlowStep(string modulePath, string sourceRef, string sinkRef) {
  nonCallFlowStep(modulePath, sourceRef, sinkRef)
  or
  exists(LuaInterproceduralFlow argumentFlow, LuaInterproceduralFlow returnFlow |
    pairedCallFlows(argumentFlow, returnFlow) and
    argumentFlow.getCallerModulePath() = modulePath and
    argumentFlow.getSourceRef() = sourceRef and
    returnFlow.getSinkRef() = sinkRef and
    (
      argumentFlow.getSinkRef() = returnFlow.getSourceRef() or
      sameLevelFlowReachable(argumentFlow.getCalleeModulePath(), argumentFlow.getSinkRef(),
        returnFlow.getSourceRef())
    )
  )
}

private predicate sameLevelFlowReachable(string modulePath, string sourceRef, string sinkRef) {
  sameLevelFlowStep(modulePath, sourceRef, sinkRef)
  or
  exists(string middleRef |
    sameLevelFlowStep(modulePath, sourceRef, middleRef) and
    sameLevelFlowReachable(modulePath, middleRef, sinkRef)
  )
}

predicate sameModuleFlowReachable(string modulePath, string sourceRef, string sinkRef) {
  sameLevelFlowReachable(modulePath, sourceRef, sinkRef)
}

private predicate downwardFlowReachable(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef
) {
  sourceModule = sinkModule and
  sameLevelFlowReachable(sourceModule, sourceRef, sinkRef)
  or
  exists(LuaInterproceduralFlow argumentFlow |
    (
      argumentFlow.getFlowKind() = "argument-to-parameter" or
      argumentFlow.getFlowKind() = "argument-to-vararg"
    ) and
    argumentFlow.getCallerModulePath() = sourceModule and
    (
      sourceRef = argumentFlow.getSourceRef() or
      sameLevelFlowReachable(sourceModule, sourceRef, argumentFlow.getSourceRef())
    ) and
    (
      argumentFlow.getCalleeModulePath() = sinkModule and
      argumentFlow.getSinkRef() = sinkRef
      or
      downwardFlowReachable(argumentFlow.getCalleeModulePath(), argumentFlow.getSinkRef(),
        sinkModule, sinkRef)
    )
  )
}

predicate downwardCallFlowReachable(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef
) {
  downwardFlowReachable(sourceModule, sourceRef, sinkModule, sinkRef)
}

predicate genericFlowReachable(
  string sourceModule, string sourceRef, string sinkModule, string sinkRef
) {
  downwardFlowReachable(sourceModule, sourceRef, sinkModule, sinkRef)
  or
  exists(LuaInterproceduralFlow returnFlow |
    returnFlow.getFlowKind() = "return-to-result" and
    returnFlow.getCalleeModulePath() = sourceModule and
    (
      sourceRef = returnFlow.getSourceRef() or
      sameLevelFlowReachable(sourceModule, sourceRef, returnFlow.getSourceRef())
    ) and
    (
      returnFlow.getCallerModulePath() = sinkModule and
      returnFlow.getSinkRef() = sinkRef
      or
      genericFlowReachable(returnFlow.getCallerModulePath(), returnFlow.getSinkRef(), sinkModule,
        sinkRef)
    )
  )
}

newtype TLuaFlowNode =
  MkLuaFlowNode(string modulePath, string valueRef) {
    genericFlowStep(modulePath, valueRef, _, _, _, _)
    or
    genericFlowStep(_, _, modulePath, valueRef, _, _)
  }

class LuaFlowNode extends TLuaFlowNode {
  string getModulePath() { this = MkLuaFlowNode(result, _) }

  string getValueRef() { this = MkLuaFlowNode(_, result) }

  string getURL() {
    exists(string prefix |
      sourceLocationPrefix(prefix) and
      result = "file://" + prefix + "/" + this.getModulePath() + ":0:0:0:0"
    )
  }

  string toString() { result = this.getModulePath() + "::" + this.getValueRef() }
}

predicate flowNodeStep(LuaFlowNode source, LuaFlowNode sink, string edgeKind, string provenance) {
  genericFlowStep(source.getModulePath(), source.getValueRef(), sink.getModulePath(),
    sink.getValueRef(), edgeKind, provenance)
}

predicate crossBoundaryCallTargetCandidate(
  string fixture, string callsiteId, string targetModulePath, string targetPrototypeId,
  string confidence, string provenance
) {
  moduleFieldCallTarget(fixture, _, callsiteId, _, targetModulePath, targetPrototypeId, _) and
  confidence = "candidate" and
  provenance = "bytecode-only,cross-module-module-field-call"
}
