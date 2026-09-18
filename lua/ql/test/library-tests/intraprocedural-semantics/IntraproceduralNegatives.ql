import codeql.lua.IntraproceduralSemantics
import codeql.lua.InterproceduralModuleTaint

from string fixture, string subject, string detail
where
  exists(LuaTableFieldFlow flow |
    flow.getModulePath() = "bc-table-global-upvalue/input.luac" and
    flow.getProvenance() = "bytecode-only"
  ) and
  fixture = "bc-table-global-upvalue" and
  subject = "forbidden legacy table flow producer" and
  detail = "bytecode-only"
  or
  exists(LuaGlobalFlow flow |
    flow.getFixtureId() = "bc-table-global-upvalue/input.luac" and
    flow.getGlobalName() = "analysis_global" and
    flow.getProvenance() = "bytecode-only"
  ) and
  fixture = "bc-table-global-upvalue" and
  subject = "forbidden legacy global flow producer" and
  detail = "unsupported _G mutation"
  or
  exists(LuaLocalFlow flow |
    flow.getModulePath() = "bc-kill-overwrite/input.luac" and
    flow.getEdgeKind() = "may-reaching-definition"
  ) and
  fixture = "bc-kill-overwrite" and
  subject = "forbidden legacy local flow producer" and
  detail = "may-reaching-definition"
  or
  localFlowReachable("bc-kill-overwrite/input.luac", "root@pc3:r2", "root@pc7:r4") and
  fixture = "bc-kill-overwrite" and
  subject = "forbidden killed flow" and
  detail = "root@pc3:r2 -> root@pc7:r4"
  or
  localFlowReachable("defuse-unrelated-register-negative/input.luac", "root@pc4:r2", "root@pc9:r6") and
  fixture = "defuse-unrelated-register-negative" and
  subject = "forbidden cross prototype register reuse" and
  detail = "root@pc4:r2 -> root@pc9:r6"
  or
  tableFieldFlow("table-dynamic-key-negative/input.luac", _, _, "root@pc3:r2", "root@pc4:r3") and
  fixture = "table-dynamic-key-negative" and
  subject = "forbidden dynamic key table flow" and
  detail = "root@pc3:r2 -> root@pc4:r3"
  or
  tableFieldFlow("table-dynamic-key-negative/input.luac", _, _, "root@pc3:r2", "root@pc5:r4") and
  fixture = "table-dynamic-key-negative" and
  subject = "forbidden missing field table flow" and
  detail = "root@pc3:r2 -> root@pc5:r4"
  or
  tableFieldFlow("call-result-table-flow/input.luac", _, _, "root.1@pc2:r0", "root.1@pc3:r3") and
  fixture = "call-result-table-flow" and
  subject = "forbidden dynamic call-result field flow" and
  detail = "root.1@pc2:r0 -> root.1@pc3:r3"
  or
  globalFlowStep("global-dynamic-environment-negative/input.luac", _, _, "root@pc4:r2",
    "root@pc3:r1") and
  fixture = "global-dynamic-environment-negative" and
  subject = "forbidden dynamic env global flow" and
  detail = "root@pc3:r1 -> root@pc4:r2"
  or
  globalFlowStep("global-dynamic-environment-negative/input.luac", _, _, "root@pc5:r3",
    "root@pc3:r1") and
  fixture = "global-dynamic-environment-negative" and
  subject = "forbidden missing global flow" and
  detail = "root@pc3:r1 -> root@pc5:r3"
  or
  upvalueFlowStep("upvalue-mutation-negative/input.luac", _, "root.0@pc0:r0", "root.0@pc3:r1", _) and
  fixture = "upvalue-mutation-negative" and
  subject = "forbidden stale upvalue reuse" and
  detail = "root.0@pc0:r0 -> root.0@pc3:r1"
  or
  exists(LuaUpvalueFlow flow |
    flow.getFixtureId() = "bc-table-global-upvalue/input.luac" and
    flow.getUpvalueId() = "root.0:u0" and
    flow.getCaptureRef() = "root.0:u0" and
    flow.getProvenance() = "bytecode-only"
  ) and
  fixture = "bc-table-global-upvalue" and
  subject = "forbidden legacy upvalue flow producer" and
  detail = "synthetic capture/read/write"
  or
  exists(LuaCallResolution resolution |
    resolution.getCallerModulePath() = "bc-call-candidate-unresolved/input.luac" and
    resolution.getCallsiteId() = "root.1@pc2" and
    resolution.getResolvedName() = "source-function-name"
  ) and
  fixture = "bc-call-candidate-unresolved" and
  subject = "forbidden guessed source target" and
  detail = "root.1@pc2 -> source-function-name"
select fixture, subject, detail
