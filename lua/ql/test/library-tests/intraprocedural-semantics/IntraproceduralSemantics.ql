import codeql.lua.IntraproceduralSemantics
import codeql.lua.InterproceduralModuleTaint

from string fixture, string capability, string subject, string detail, string value
where
  localFlowReachable("bc-kill-overwrite/input.luac", "root@pc4:r2", "root@pc7:r4") and
  fixture = "bc-kill-overwrite" and
  capability = "rda.kill-gen" and
  subject = "bc-kill-overwrite:clean-constant-to-sink" and
  detail = "root@pc4:r2 -> root@pc7:r4" and
  value = "reachable"
  or
  exists(LuaLocalFlow flow |
    flow.getModulePath() = "bc-kill-overwrite/input.luac" and
    flow.getPrototypeId() = "root" and
    flow.getSourceRef() = "root@pc4:r2" and
    flow.getSinkRef() = "root@pc6:r2" and
    flow.getEdgeKind() = "reaching-definition" and
    flow.getProvenance() = "bytecode-only,cfg-rda"
  ) and
  fixture = "bc-kill-overwrite" and
  capability = "rda.analyzer-relation" and
  subject = "root@pc4:r2 -> root@pc6:r2" and
  detail = "reaching-definition" and
  value = "bytecode-only,cfg-rda"
  or
  localFlowReachable("defuse-transitive-chain/input.luac", "root@pc3:r2", "root@pc8:r6") and
  fixture = "defuse-transitive-chain" and
  capability = "defuse.transitive-chain" and
  subject = "defuse-transitive-chain:register-chain" and
  detail = "root@pc3:r2 -> root@pc8:r6" and
  value = "reachable"
  or
  exists(LuaAnalysisBoundary boundary |
    boundary.getModulePath() = "defuse-transitive-chain/input.luac" and
    boundary.getPrototypeId() = "root" and
    boundary.getSiteId() = "root@pc9" and
    boundary.getBoundaryKind() = "open-return-tail" and
    boundary.getReason() = "only predecessor-proven return slots are modeled" and
    boundary.getProvenance() = "bytecode-only,open-slot-boundary"
  ) and
  fixture = "defuse-transitive-chain" and
  capability = "analysis.boundary" and
  subject = "root@pc9" and
  detail = "open-return-tail" and
  value = "only predecessor-proven return slots are modeled"
  or
  tableFieldFlow("bc-table-global-upvalue/input.luac", "root.0@pc0:r1", "key", "root.0@pc1:r0",
    "root.0@pc3:r3") and
  localFlowReachable("bc-table-global-upvalue/input.luac", "root.0@pc3:r3", "root.0@pc6:r3") and
  fixture = "bc-table-global-upvalue" and
  capability = "table.field-flow" and
  subject = "root.0@pc1:r0 -> root.0@pc6:r3" and
  detail = "root.0@pc0:r1/key" and
  value = "table/global/upvalue carrier"
  or
  exists(LuaTableFieldFlow flow |
    flow.getModulePath() = "bc-table-global-upvalue/input.luac" and
    flow.getPrototypeId() = "root.0" and
    flow.getTableRef() = "root.0@pc0:r1" and
    flow.getFieldName() = "key" and
    flow.getWriteRef() = "root.0@pc1:r0" and
    flow.getReadRef() = "root.0@pc3:r3" and
    flow.getProvenance() = "bytecode-only,precise-table-field"
  ) and
  fixture = "bc-table-global-upvalue" and
  capability = "table.analyzer-relation" and
  subject = "root.0@pc0:r1.key" and
  detail = "root.0@pc1:r0 -> root.0@pc3:r3" and
  value = "bytecode-only,precise-table-field"
  or
  genericFlowStep("bc-table-global-upvalue/input.luac", "root.0@pc1:r0",
    "bc-table-global-upvalue/input.luac", "root.0@pc3:r3", "table-field",
    "bytecode-only,precise-table-field") and
  genericFlowReachable("bc-table-global-upvalue/input.luac", "root.0@pc1:r0",
    "bc-table-global-upvalue/input.luac", "root.0@pc3:r3") and
  fixture = "bc-table-global-upvalue" and
  capability = "table.generic-field-flow" and
  subject = "root.0@pc0:r1.key" and
  detail = "root.0@pc1:r0 -> root.0@pc3:r3" and
  value = "bytecode-only,precise-table-field"
  or
  exists(LuaLocalFlow flow |
    flow.getModulePath() = "bc-table-global-upvalue/input.luac" and
    flow.getPrototypeId() = "root.0" and
    flow.getSourceRef() = "root.0@pc1:r0" and
    flow.getSinkRef() = "root.0@pc3:r1" and
    flow.getEdgeKind() = "table-object-dependence" and
    flow.getProvenance() = "bytecode-only,mutable-table-object"
  ) and
  fixture = "bc-table-global-upvalue" and
  capability = "table.object-carrier" and
  subject = "root.0@pc0:r1" and
  detail = "root.0@pc1:r0 -> root.0@pc3:r1" and
  value = "bytecode-only,mutable-table-object"
  or
  genericFlowReachable("table-dynamic-key-negative/input.luac", "root@pc2:r2",
    "table-dynamic-key-negative/input.luac", "root@pc4:r3") and
  fixture = "table-dynamic-key-negative" and
  capability = "table.whole-object-flow" and
  subject = "dynamic-key-read" and
  detail = "root@pc2:r2 -> root@pc4:r3" and
  value = "same-proven-table"
  or
  genericFlowReachable("table-dynamic-key-negative/input.luac", "root@pc2:r2",
    "table-dynamic-key-negative/input.luac", "root@pc5:r4") and
  fixture = "table-dynamic-key-negative" and
  capability = "table.whole-object-flow" and
  subject = "missing-key-read" and
  detail = "root@pc2:r2 -> root@pc5:r4" and
  value = "same-proven-table"
  or
  exists(LuaLocalFlow flow |
    flow.getModulePath() = "call-result-table-flow/input.luac" and
    flow.getPrototypeId() = "root.1" and
    flow.getSourceRef() = "root.1@pc2:r0" and
    flow.getSinkRef() = "root.1@pc3:r2" and
    flow.getEdgeKind() = "table-object-dependence" and
    flow.getProvenance() = "bytecode-only,mutable-table-object"
  ) and
  genericFlowReachable("call-result-table-flow/input.luac", "root.1@pc2:r0",
    "call-result-table-flow/input.luac", "root.1@pc3:r3") and
  fixture = "call-result-table-flow" and
  capability = "table.call-result-object-flow" and
  subject = "dynamic-write-to-later-read" and
  detail = "root.1@pc2:r0 -> root.1@pc3:r3" and
  value = "bytecode-only,mutable-table-object"
  or
  exists(LuaGlobalFlow flow |
    flow.getFixtureId() = "global-state-write-read/input.luac" and
    flow.getGlobalName() = "shared_global" and
    flow.getWriteRef() = "root.0@pc0:r0" and
    flow.getReadRef() = "root.0@pc1:r1" and
    flow.getValueRef() = "root.0@pc0:r0" and
    flow.getProvenance() = "bytecode-only,precise-global-state"
  ) and
  globalFlowStep("global-state-write-read/input.luac", "shared_global", "root.0@pc0:r0",
    "root.0@pc1:r1", "root.0@pc0:r0") and
  fixture = "global-state-write-read" and
  capability = "global.write-read" and
  subject = "shared_global" and
  detail = "root.0@pc0:r0 -> root.0@pc1:r1" and
  value = "bytecode-only,precise-global-state"
  or
  exists(LuaUpvalueFlow flow |
    flow.getFixtureId() = "bc-table-global-upvalue/input.luac" and
    flow.getUpvalueId() = "root.0:u0" and
    flow.getCaptureRef() = "root@pc2:r0" and
    flow.getReadRef() = "root.0@pc4:r4" and
    flow.getWriteRef() = "" and
    flow.getProvenance() = "bytecode-only,derived-upvalue-flow"
  ) and
  localFlowReachable("bc-table-global-upvalue/input.luac", "root.0@pc4:r4", "root.0@pc6:r3") and
  fixture = "bc-table-global-upvalue" and
  capability = "upvalue.capture-read-write" and
  subject = "root.0:u0" and
  detail = "root@pc2:r0 -> root.0@pc4:r4" and
  value = "bytecode-only,derived-upvalue-flow"
  or
  upvalueFlowStep("upvalue-mutation-negative/input.luac", "root.0:u0", "root@pc2:r0",
    "root.0@pc3:r1", "root.0@pc2:r1") and
  fixture = "upvalue-mutation-negative" and
  capability = "upvalue.mutation-evidence" and
  subject = "root.0:u0" and
  detail = "root.0@pc2:r1 -> root.0@pc3:r1" and
  value = "post-write-evidence"
  or
  exists(LuaCallResolution resolution |
    resolution.getCallerModulePath() = "bc-call-candidate-unresolved/input.luac" and
    resolution.getCallerPrototypeId() = "root" and
    resolution.getCallsiteId() = "root@pc5" and
    resolution.getTargetValueRef() = "root@pc5:r2" and
    resolution.getResolvedName() = "invoke" and
    resolution.getResolutionKind() = "closure-move" and
    resolution.getTargetModulePath() = "bc-call-candidate-unresolved/input.luac" and
    resolution.getTargetPrototypeId() = "root.1" and
    resolution.getProvenance() = "bytecode-only,closure-move-target"
  ) and
  fixture = "bc-call-candidate-unresolved" and
  capability = "calltarget.resolution" and
  subject = "root@pc5" and
  detail = "root.1" and
  value = "closure-move"
  or
  exists(LuaAnalysisBoundary boundary |
    boundary.getModulePath() = "bc-call-candidate-unresolved/input.luac" and
    boundary.getPrototypeId() = "root.1" and
    boundary.getSiteId() = "root.1@pc2" and
    boundary.getBoundaryKind() = "unresolved-call-target" and
    boundary.getReason() = "param-derived" and
    boundary.getProvenance() = "bytecode-only,call-resolution-boundary"
  ) and
  fixture = "bc-call-candidate-unresolved" and
  capability = "calltarget.boundary" and
  subject = "root.1@pc2" and
  detail = "param-derived" and
  value = "unresolved-call-target"
select fixture, capability, subject, detail, value
