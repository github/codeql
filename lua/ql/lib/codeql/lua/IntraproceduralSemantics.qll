/**
 * Provides Lua bytecode intraprocedural semantics for Lua 5.1 analysis.
 *
 * This library exposes native extractor facts for bytecode-level local
 * semantics.
 */

import codeql.lua.Bytecode

class LuaInstruction extends @lua_instruction {
  LuaInstruction() { lua_instructions(this, _, _, _, _, _, _, _, _) }

  LuaPrototype getPrototype() { lua_instructions(this, result, _, _, _, _, _, _, _) }

  string getFixtureId() { lua_instructions(this, _, result, _, _, _, _, _, _) }

  string getPrototypeId() { lua_instructions(this, _, _, result, _, _, _, _, _) }

  int getPc() { lua_instructions(this, _, _, _, result, _, _, _, _) }

  string getOpcode() { lua_instructions(this, _, _, _, _, result, _, _, _) }

  int getOperandA() { lua_instructions(this, _, _, _, _, _, result, _, _) }

  int getOperandB() { lua_instructions(this, _, _, _, _, _, _, result, _) }

  int getOperandC() { lua_instructions(this, _, _, _, _, _, _, _, result) }

  string getInstructionRef() { result = this.getPrototypeId() + "@pc" + this.getPc().toString() }

  string toString() { result = this.getFixtureId() + ":" + this.getInstructionRef() }
}

class LuaRegisterEvent extends @lua_register_event {
  LuaRegisterEvent() { lua_register_events(this, _, _, _, _, _, _, _) }

  LuaInstruction getInstruction() { lua_register_events(this, result, _, _, _, _, _, _) }

  string getFixtureId() { lua_register_events(this, _, result, _, _, _, _, _) }

  string getPrototypeId() { lua_register_events(this, _, _, result, _, _, _, _) }

  int getPc() { lua_register_events(this, _, _, _, result, _, _, _) }

  string getKind() { lua_register_events(this, _, _, _, _, result, _, _) }

  int getSlot() { lua_register_events(this, _, _, _, _, _, result, _) }

  string getValueRef() { lua_register_events(this, _, _, _, _, _, _, result) }

  predicate isRead() { this.getKind() = "read" }

  predicate isWrite() { this.getKind() = "write" }

  string toString() { result = this.getValueRef() }
}

class LuaSemanticStep extends @lua_semantic_step {
  LuaSemanticStep() { lua_semantic_steps(this, _, _, _, _, _) }

  LuaInstruction getInstruction() { lua_semantic_steps(this, result, _, _, _, _) }

  string getFixtureId() { lua_semantic_steps(this, _, result, _, _, _) }

  string getSourceRef() { lua_semantic_steps(this, _, _, result, _, _) }

  string getDestRef() { lua_semantic_steps(this, _, _, _, result, _) }

  string getKind() { lua_semantic_steps(this, _, _, _, _, result) }

  string toString() { result = this.getSourceRef() + " -> " + this.getDestRef() }
}

class LuaClosureValue extends @lua_closure_value {
  LuaClosureValue() { lua_closure_values(this, _, _, _, _, _) }

  LuaInstruction getInstruction() { lua_closure_values(this, result, _, _, _, _) }

  string getFixtureId() { lua_closure_values(this, _, result, _, _, _) }

  string getValueRef() { lua_closure_values(this, _, _, result, _, _) }

  string getTargetPrototypeId() { lua_closure_values(this, _, _, _, result, _) }

  string getProvenance() { lua_closure_values(this, _, _, _, _, result) }

  string toString() { result = this.getValueRef() }
}

class LuaCallSite extends @lua_call_site {
  LuaCallSite() { lua_call_sites(this, _, _, _, _, _, _, _, _, _, _, _) }

  LuaInstruction getInstruction() { lua_call_sites(this, result, _, _, _, _, _, _, _, _, _, _) }

  string getFixtureId() { lua_call_sites(this, _, result, _, _, _, _, _, _, _, _, _) }

  string getCallsiteId() { lua_call_sites(this, _, _, result, _, _, _, _, _, _, _, _) }

  string getPrototypeId() { lua_call_sites(this, _, _, _, result, _, _, _, _, _, _, _) }

  int getPc() { lua_call_sites(this, _, _, _, _, result, _, _, _, _, _, _) }

  string getOpcode() { lua_call_sites(this, _, _, _, _, _, result, _, _, _, _, _) }

  string getTargetValueRef() { lua_call_sites(this, _, _, _, _, _, _, result, _, _, _, _) }

  int getFirstArgSlot() { lua_call_sites(this, _, _, _, _, _, _, _, result, _, _, _) }

  int getArgCount() { lua_call_sites(this, _, _, _, _, _, _, _, _, result, _, _) }

  int getFirstReturnSlot() { lua_call_sites(this, _, _, _, _, _, _, _, _, _, result, _) }

  int getReturnCount() { lua_call_sites(this, _, _, _, _, _, _, _, _, _, _, result) }

  string toString() { result = this.getCallsiteId() }
}

class LuaUpvalue extends @lua_upvalue {
  LuaUpvalue() { lua_upvalues(this, _, _, _, _, _, _, _, _) }

  LuaPrototype getPrototype() { lua_upvalues(this, result, _, _, _, _, _, _, _) }

  string getFixtureId() { lua_upvalues(this, _, result, _, _, _, _, _, _) }

  string getUpvalueId() { lua_upvalues(this, _, _, result, _, _, _, _, _) }

  string getPrototypeId() { lua_upvalues(this, _, _, _, result, _, _, _, _) }

  int getIndex() { lua_upvalues(this, _, _, _, _, result, _, _, _) }

  string getDebugName() { lua_upvalues(this, _, _, _, _, _, result, _, _) }

  string getMappingState() { lua_upvalues(this, _, _, _, _, _, _, result, _) }

  string getProvenance() { lua_upvalues(this, _, _, _, _, _, _, _, result) }

  string toString() { result = this.getUpvalueId() }
}

class LuaLocalFlow extends @lua_local_flow {
  LuaLocalFlow() { lua_local_flows(this, _, _, _, _, _, _) }

  string getModulePath() { lua_local_flows(this, result, _, _, _, _, _) }

  string getPrototypeId() { lua_local_flows(this, _, result, _, _, _, _) }

  string getSourceRef() { lua_local_flows(this, _, _, result, _, _, _) }

  string getSinkRef() { lua_local_flows(this, _, _, _, result, _, _) }

  string getEdgeKind() { lua_local_flows(this, _, _, _, _, result, _) }

  string getProvenance() { lua_local_flows(this, _, _, _, _, _, result) }

  string toString() { result = this.getSourceRef() + " -> " + this.getSinkRef() }
}

class LuaControlFlowEdge extends @lua_control_flow_edge {
  LuaControlFlowEdge() { lua_control_flow_edges(this, _, _, _, _, _, _, _) }

  LuaInstruction getSourceInstruction() { lua_control_flow_edges(this, result, _, _, _, _, _, _) }

  LuaInstruction getTargetInstruction() { lua_control_flow_edges(this, _, result, _, _, _, _, _) }

  string getModulePath() { lua_control_flow_edges(this, _, _, result, _, _, _, _) }

  string getPrototypeId() { lua_control_flow_edges(this, _, _, _, result, _, _, _) }

  int getSourcePc() { lua_control_flow_edges(this, _, _, _, _, result, _, _) }

  int getTargetPc() { lua_control_flow_edges(this, _, _, _, _, _, result, _) }

  string getProvenance() { lua_control_flow_edges(this, _, _, _, _, _, _, result) }

  string toString() {
    result =
      this.getPrototypeId() + "@pc" + this.getSourcePc().toString() + " -> pc" +
        this.getTargetPc().toString()
  }
}

predicate controlFlowStep(LuaInstruction source, LuaInstruction sink) {
  exists(LuaControlFlowEdge edge |
    source = edge.getSourceInstruction() and sink = edge.getTargetInstruction()
  )
}

class LuaDominatorTreeInterval extends @lua_dominator_tree_interval {
  LuaDominatorTreeInterval() { lua_dominator_tree_intervals(this, _, _, _, _, _, _, _) }

  LuaInstruction getInstruction() { lua_dominator_tree_intervals(this, result, _, _, _, _, _, _) }

  string getModulePath() { lua_dominator_tree_intervals(this, _, result, _, _, _, _, _) }

  string getPrototypeId() { lua_dominator_tree_intervals(this, _, _, result, _, _, _, _) }

  int getPc() { lua_dominator_tree_intervals(this, _, _, _, result, _, _, _) }

  int getStart() { lua_dominator_tree_intervals(this, _, _, _, _, result, _, _) }

  int getEnd() { lua_dominator_tree_intervals(this, _, _, _, _, _, result, _) }

  string getProvenance() { lua_dominator_tree_intervals(this, _, _, _, _, _, _, result) }

  string toString() {
    result =
      this.getPrototypeId() + "@pc" + this.getPc().toString() + " [" + this.getStart().toString() +
        "," + this.getEnd().toString() + "]"
  }
}

predicate instructionDominates(LuaInstruction dominator, LuaInstruction instruction) {
  exists(LuaDominatorTreeInterval dominatorInterval, LuaDominatorTreeInterval interval |
    dominatorInterval.getInstruction() = dominator and
    interval.getInstruction() = instruction and
    dominatorInterval.getModulePath() = interval.getModulePath() and
    dominatorInterval.getPrototypeId() = interval.getPrototypeId() and
    dominatorInterval.getStart() <= interval.getStart() and
    interval.getStart() <= dominatorInterval.getEnd()
  )
}

class LuaAnalysisBoundary extends @lua_analysis_boundary {
  LuaAnalysisBoundary() { lua_analysis_boundaries(this, _, _, _, _, _, _) }

  string getModulePath() { lua_analysis_boundaries(this, result, _, _, _, _, _) }

  string getPrototypeId() { lua_analysis_boundaries(this, _, result, _, _, _, _) }

  string getSiteId() { lua_analysis_boundaries(this, _, _, result, _, _, _) }

  string getBoundaryKind() { lua_analysis_boundaries(this, _, _, _, result, _, _) }

  string getReason() { lua_analysis_boundaries(this, _, _, _, _, result, _) }

  string getProvenance() { lua_analysis_boundaries(this, _, _, _, _, _, result) }

  string toString() { result = this.getSiteId() + ":" + this.getBoundaryKind() }
}

class LuaTableFieldFlow extends @lua_table_field_flow {
  LuaTableFieldFlow() { lua_table_field_flows(this, _, _, _, _, _, _, _) }

  string getModulePath() { lua_table_field_flows(this, result, _, _, _, _, _, _) }

  string getPrototypeId() { lua_table_field_flows(this, _, result, _, _, _, _, _) }

  string getTableRef() { lua_table_field_flows(this, _, _, result, _, _, _, _) }

  string getFieldName() { lua_table_field_flows(this, _, _, _, result, _, _, _) }

  string getWriteRef() { lua_table_field_flows(this, _, _, _, _, result, _, _) }

  string getReadRef() { lua_table_field_flows(this, _, _, _, _, _, result, _) }

  string getProvenance() { lua_table_field_flows(this, _, _, _, _, _, _, result) }

  string toString() { result = this.getWriteRef() + " -> " + this.getReadRef() }
}

class LuaGlobalFlow extends @lua_global_flow {
  LuaGlobalFlow() { lua_global_flows(this, _, _, _, _, _, _) }

  string getFixtureId() { lua_global_flows(this, result, _, _, _, _, _) }

  string getGlobalName() { lua_global_flows(this, _, result, _, _, _, _) }

  string getWriteRef() { lua_global_flows(this, _, _, result, _, _, _) }

  string getReadRef() { lua_global_flows(this, _, _, _, result, _, _) }

  string getValueRef() { lua_global_flows(this, _, _, _, _, result, _) }

  string getProvenance() { lua_global_flows(this, _, _, _, _, _, result) }

  string toString() { result = this.getGlobalName() }
}

class LuaUpvalueFlow extends @lua_upvalue_flow {
  LuaUpvalueFlow() { lua_upvalue_flows(this, _, _, _, _, _, _) }

  string getFixtureId() { lua_upvalue_flows(this, result, _, _, _, _, _) }

  string getUpvalueId() { lua_upvalue_flows(this, _, result, _, _, _, _) }

  string getCaptureRef() { lua_upvalue_flows(this, _, _, result, _, _, _) }

  string getReadRef() { lua_upvalue_flows(this, _, _, _, result, _, _) }

  string getWriteRef() { lua_upvalue_flows(this, _, _, _, _, result, _) }

  string getProvenance() { lua_upvalue_flows(this, _, _, _, _, _, result) }

  string toString() { result = this.getUpvalueId() }
}

class LuaCallResolution extends @lua_call_resolution {
  LuaCallResolution() { lua_call_resolutions(this, _, _, _, _, _, _, _, _, _) }

  string getCallerModulePath() { lua_call_resolutions(this, result, _, _, _, _, _, _, _, _) }

  string getCallerPrototypeId() { lua_call_resolutions(this, _, result, _, _, _, _, _, _, _) }

  string getCallsiteId() { lua_call_resolutions(this, _, _, result, _, _, _, _, _, _) }

  string getTargetValueRef() { lua_call_resolutions(this, _, _, _, result, _, _, _, _, _) }

  string getResolvedName() { lua_call_resolutions(this, _, _, _, _, result, _, _, _, _) }

  string getResolutionKind() { lua_call_resolutions(this, _, _, _, _, _, result, _, _, _) }

  string getTargetModulePath() { lua_call_resolutions(this, _, _, _, _, _, _, result, _, _) }

  string getTargetPrototypeId() { lua_call_resolutions(this, _, _, _, _, _, _, _, result, _) }

  string getProvenance() { lua_call_resolutions(this, _, _, _, _, _, _, _, _, result) }

  string toString() { result = this.getCallsiteId() + ":" + this.getResolutionKind() }
}

class LuaLiteralRequire extends @lua_literal_require {
  LuaLiteralRequire() { lua_literal_requires(this, _, _, _, _, _, _) }

  string getCallerModulePath() { lua_literal_requires(this, result, _, _, _, _, _) }

  string getCallerPrototypeId() { lua_literal_requires(this, _, result, _, _, _, _) }

  string getCallsiteId() { lua_literal_requires(this, _, _, result, _, _, _) }

  string getRequireString() { lua_literal_requires(this, _, _, _, result, _, _) }

  string getArgumentRef() { lua_literal_requires(this, _, _, _, _, result, _) }

  string getProvenance() { lua_literal_requires(this, _, _, _, _, _, result) }

  string toString() { result = this.getCallsiteId() + ":" + this.getRequireString() }
}

class LuaModuleResolution extends @lua_module_resolution {
  LuaModuleResolution() { lua_module_resolutions(this, _, _, _, _, _, _, _) }

  string getCallerModulePath() { lua_module_resolutions(this, result, _, _, _, _, _, _) }

  string getCallsiteId() { lua_module_resolutions(this, _, result, _, _, _, _, _) }

  string getRequireString() { lua_module_resolutions(this, _, _, result, _, _, _, _) }

  string getStatus() { lua_module_resolutions(this, _, _, _, result, _, _, _) }

  string getTargetModulePath() { lua_module_resolutions(this, _, _, _, _, result, _, _) }

  string getReason() { lua_module_resolutions(this, _, _, _, _, _, result, _) }

  string getProvenance() { lua_module_resolutions(this, _, _, _, _, _, _, result) }

  string toString() { result = this.getCallsiteId() + ":" + this.getStatus() }
}

class LuaModuleExport extends @lua_module_export {
  LuaModuleExport() { lua_module_exports(this, _, _, _, _, _, _) }

  string getModulePath() { lua_module_exports(this, result, _, _, _, _, _) }

  string getExportKind() { lua_module_exports(this, _, result, _, _, _, _) }

  string getFieldName() { lua_module_exports(this, _, _, result, _, _, _) }

  string getValueRef() { lua_module_exports(this, _, _, _, result, _, _) }

  string getTargetPrototypeId() { lua_module_exports(this, _, _, _, _, result, _) }

  string getProvenance() { lua_module_exports(this, _, _, _, _, _, result) }

  string toString() { result = this.getExportKind() + ":" + this.getFieldName() }
}

class LuaInterproceduralFlow extends @lua_interprocedural_flow {
  LuaInterproceduralFlow() { lua_interprocedural_flows(this, _, _, _, _, _, _, _, _, _, _) }

  string getCallerModulePath() {
    lua_interprocedural_flows(this, result, _, _, _, _, _, _, _, _, _)
  }

  string getCallerPrototypeId() {
    lua_interprocedural_flows(this, _, result, _, _, _, _, _, _, _, _)
  }

  string getCallsiteId() { lua_interprocedural_flows(this, _, _, result, _, _, _, _, _, _, _) }

  string getCalleeModulePath() {
    lua_interprocedural_flows(this, _, _, _, result, _, _, _, _, _, _)
  }

  string getCalleePrototypeId() {
    lua_interprocedural_flows(this, _, _, _, _, result, _, _, _, _, _)
  }

  string getSourceRef() { lua_interprocedural_flows(this, _, _, _, _, _, result, _, _, _, _) }

  string getSinkRef() { lua_interprocedural_flows(this, _, _, _, _, _, _, result, _, _, _) }

  string getFlowKind() { lua_interprocedural_flows(this, _, _, _, _, _, _, _, result, _, _) }

  int getPosition() { lua_interprocedural_flows(this, _, _, _, _, _, _, _, _, result, _) }

  string getProvenance() { lua_interprocedural_flows(this, _, _, _, _, _, _, _, _, _, result) }

  string toString() { result = this.getSourceRef() + " -> " + this.getSinkRef() }
}

predicate localFlowStep(string fixture, string source, string sink, string kind) {
  exists(LuaLocalFlow flow |
    flow.getModulePath() = fixture and
    source = flow.getSourceRef() and
    sink = flow.getSinkRef() and
    kind = flow.getEdgeKind()
  )
}

predicate localFlowReachable(string fixture, string source, string sink) {
  localFlowStep(fixture, source, sink, _)
  or
  exists(string mid |
    localFlowStep(fixture, source, mid, _) and
    localFlowReachable(fixture, mid, sink)
  )
}

predicate tableFieldFlow(
  string fixture, string tableRef, string fieldName, string writeRef, string readRef
) {
  exists(LuaTableFieldFlow flow |
    flow.getModulePath() = fixture and
    tableRef = flow.getTableRef() and
    fieldName = flow.getFieldName() and
    writeRef = flow.getWriteRef() and
    readRef = flow.getReadRef()
  )
}

predicate globalFlowStep(
  string fixture, string globalName, string writeRef, string readRef, string valueRef
) {
  exists(LuaGlobalFlow flow |
    flow.getFixtureId() = fixture and
    globalName = flow.getGlobalName() and
    writeRef = flow.getWriteRef() and
    readRef = flow.getReadRef() and
    valueRef = flow.getValueRef()
  )
}

predicate upvalueFlowStep(
  string fixture, string upvalueId, string captureRef, string readRef, string writeRef
) {
  exists(LuaUpvalueFlow flow |
    flow.getFixtureId() = fixture and
    upvalueId = flow.getUpvalueId() and
    captureRef = flow.getCaptureRef() and
    readRef = flow.getReadRef() and
    writeRef = flow.getWriteRef()
  )
}

predicate callResolution(
  string callerModulePath, string callsiteId, string targetModulePath, string targetPrototypeId,
  string resolvedName, string resolutionKind
) {
  exists(LuaCallResolution resolution |
    resolution.getCallerModulePath() = callerModulePath and
    resolution.getCallsiteId() = callsiteId and
    resolution.getTargetModulePath() = targetModulePath and
    resolution.getTargetPrototypeId() = targetPrototypeId and
    resolution.getResolvedName() = resolvedName and
    resolution.getResolutionKind() = resolutionKind
  )
}

predicate unresolvedCallBoundary(string modulePath, string callsiteId, string reason) {
  exists(LuaAnalysisBoundary boundary |
    boundary.getModulePath() = modulePath and
    boundary.getSiteId() = callsiteId and
    boundary.getBoundaryKind() = "unresolved-call-target" and
    boundary.getReason() = reason
  )
}
