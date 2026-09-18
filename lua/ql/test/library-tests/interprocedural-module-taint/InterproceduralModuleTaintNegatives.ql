import codeql.lua.InterproceduralModuleTaint

from string fixture, string forbidden, string evidence
where
  fixture = "callsite-balanced-identity/input.luac" and
  forbidden = "cross-callsite-return-contamination" and
  genericFlowReachable(fixture, "root@pc5:r3", fixture, "root@pc8:r3") and
  evidence = "root@pc5:r3 -> root@pc8:r3"
  or
  fixture = "bc-branch-negative/input.luac" and
  forbidden = "branch-clean-value-produced-generic-path" and
  genericFlowReachable(fixture, "root.0@pc1:r0", fixture, "root.1:r0") and
  evidence = "root.0@pc1:r0 -> root.1:r0"
  or
  fixture = "unresolved-callee-negative/input.luac" and
  forbidden = "unresolved-call-produced-generic-path" and
  genericFlowReachable(fixture, "root.2@pc2:r3", fixture, "root.1:r0") and
  evidence = "root.2@pc2:r3 -> root.1:r0"
  or
  fixture = "module-missing-field-negative/controller.luac" and
  forbidden = "missing-field-produced-generic-cross-module-edge" and
  genericFlowStep(fixture, "root.0@pc3:r1", "module-missing-field-negative/missingfn.luac",
    "root.0:r0", _, _) and
  evidence = "root.0@pc3:r1 -> missingfn.luac::root.0:r0"
  or
  fixture = "bc-taint-minimal-path/input.luac" and
  forbidden = "direct-return-to-sink-parameter-shortcut" and
  genericFlowStep(fixture, "root.0@pc1:r0", fixture, "root.1:r0", _, _) and
  evidence = "root.0@pc1:r0 -> root.1:r0"
  or
  fixture = "bc-kill-overwrite/input.luac" and
  forbidden = "killed-flow-produced-generic-path" and
  genericFlowReachable(fixture, "root@pc3:r2", fixture, "root@pc7:r4") and
  evidence = "root@pc3:r2 -> root@pc7:r4"
  or
  fixture = "unresolved-callee-negative/input.luac" and
  forbidden = "unresolved-callee-produced-interproc-flow" and
  exists(
    string callsiteId, string fromArg, string targetModule, string targetPrototype,
    string parameter, string provenance, string reason
  |
    interproceduralArgFlow(fixture, callsiteId, fromArg, targetModule, targetPrototype, parameter,
      provenance) and
    unresolvedCallBoundary(fixture, callsiteId, reason) and
    evidence = callsiteId
  )
  or
  fixture = "module-missing-field-negative/controller.luac" and
  forbidden = "missing-field-produced-calltarget" and
  exists(
    string callsiteId, string targetModule, string targetPrototype, string confidence,
    string provenance
  |
    crossBoundaryCallTargetCandidate(fixture, callsiteId, targetModule, targetPrototype, confidence,
      provenance) and
    evidence = callsiteId
  )
  or
  fixture = "ambiguous-unresolved-dynamic-module-negative/controller.luac" and
  forbidden = "ambiguous-or-dynamic-require-produced-linkage" and
  exists(
    string callsiteId, string requireString, string status, string fromModule, string targetModule,
    string reason, string provenance
  |
    moduleResolution(fixture, callsiteId, requireString, status, fromModule, targetModule, reason,
      provenance) and
    status = "matched" and
    evidence = callsiteId
  )
select fixture, forbidden, evidence
