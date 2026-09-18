/**
 * @name Lua bytecode fact export
 * @description Exports detailed Lua bytecode, flow, and rule facts for integration.
 * @kind table
 * @id lua/diagnostics/bytecode-facts
 * @tags experimental
 */

import codeql.lua.Bytecode
import codeql.lua.IntraproceduralSemantics
import codeql.lua.InterproceduralModuleTaint
import codeql.lua.RulesSanitizerReport

from
  string row_kind, string a, string b, string c, string d, string e, string f, string g, string h,
  string i
where
  row_kind = "aggregate" and
  a = "accepted-artifacts" and
  b = count(LuaArtifact artifact | artifact.isAccepted()).toString() and
  c = "" and
  d = "" and
  e = "" and
  f = "" and
  g = "" and
  h = "" and
  i = ""
  or
  row_kind = "aggregate" and
  a = "diagnostic-artifacts" and
  b = count(LuaArtifact artifact | not artifact.isAccepted()).toString() and
  c = "" and
  d = "" and
  e = "" and
  f = "" and
  g = "" and
  h = "" and
  i = ""
  or
  row_kind = "aggregate" and
  a = "prototypes" and
  b = count(LuaPrototype prototype | any()).toString() and
  c = "" and
  d = "" and
  e = "" and
  f = "" and
  g = "" and
  h = "" and
  i = ""
  or
  row_kind = "aggregate" and
  a = "instructions" and
  b = count(LuaInstruction instruction | any()).toString() and
  c = "" and
  d = "" and
  e = "" and
  f = "" and
  g = "" and
  h = "" and
  i = ""
  or
  row_kind = "aggregate" and
  a = "constants" and
  b = count(LuaConstant constant | any()).toString() and
  c = "" and
  d = "" and
  e = "" and
  f = "" and
  g = "" and
  h = "" and
  i = ""
  or
  row_kind = "aggregate" and
  a = "callsites" and
  b = count(LuaCallSite callsite | any()).toString() and
  c = "" and
  d = "" and
  e = "" and
  f = "" and
  g = "" and
  h = "" and
  i = ""
  or
  exists(LuaInstruction instr |
    instr.getFixtureId() = a and
    instr.getPrototype().getArtifact().isAccepted() and
    row_kind = "instruction" and
    b = instr.getPrototype().getArtifact().getPath() and
    c = instr.getPrototypeId() and
    d = instr.getPc().toString() and
    e = instr.getOpcode() and
    f = instr.getOperandA().toString() and
    g = instr.getOperandB().toString() and
    h = instr.getOperandC().toString() and
    i = "bytecode-only,instruction"
  )
  or
  exists(LuaConstant constant |
    constant.getFixtureId() = a and
    constant.getPrototype().getArtifact().isAccepted() and
    row_kind = "constant" and
    b = constant.getPrototype().getArtifact().getPath() and
    c = constant.getPrototypeId() and
    d = constant.getIndex().toString() and
    e = constant.getLuaType() and
    f = constant.getValue() and
    g = constant.getConstantId() and
    h = "bytecode-only,constant" and
    i = ""
  )
  or
  exists(LuaUpvalue upvalue |
    upvalue.getFixtureId() = a and
    upvalue.getPrototype().getArtifact().isAccepted() and
    row_kind = "upvalue" and
    b = upvalue.getPrototype().getArtifact().getPath() and
    c = upvalue.getPrototypeId() and
    d = upvalue.getIndex().toString() and
    e = upvalue.getDebugName() and
    f = upvalue.getMappingState() and
    g = upvalue.getUpvalueId() and
    h = upvalue.getProvenance() and
    i = ""
  )
  or
  exists(LuaClosureValue closure |
    closure.getFixtureId() = a and
    closure.getInstruction().getPrototype().getArtifact().isAccepted() and
    row_kind = "closure-value" and
    b = closure.getInstruction().getPrototype().getArtifact().getPath() and
    c = closure.getInstruction().getPrototypeId() and
    d = closure.getValueRef() and
    e = closure.getTargetPrototypeId() and
    f = closure.getProvenance() and
    g = "" and
    h = "" and
    i = ""
  )
  or
  exists(LuaRegisterEvent event |
    event.getFixtureId() = a and
    event.getInstruction().getPrototype().getArtifact().isAccepted() and
    row_kind = "register-event" and
    b = event.getPrototypeId() and
    c = event.getInstruction().getPrototype().getArtifact().getPath() and
    d = event.getPc().toString() and
    e = event.getKind() and
    f = event.getSlot().toString() and
    g = event.getValueRef() and
    h = "bytecode-only,register-event" and
    i = ""
  )
  or
  exists(LuaSemanticStep step |
    step.getFixtureId() = a and
    step.getInstruction().getPrototype().getArtifact().isAccepted() and
    row_kind = "dataflow-edge" and
    b = step.getInstruction().getPrototype().getArtifact().getPath() and
    c = step.getInstruction().getPrototypeId() and
    d = step.getSourceRef() and
    e = step.getDestRef() and
    f = step.getKind() and
    g = "bytecode-only,semantic-step" and
    h = step.getInstruction().getPc().toString() and
    i = step.getInstruction().getPc().toString()
  )
  or
  moduleIdentity(a, b, c, d) and
  row_kind = "module-identity" and
  e = "" and
  f = "" and
  g = "" and
  h = "" and
  i = ""
  or
  exists(LuaPrototype prototype |
    prototype.getFixtureId() = a and
    prototype.getArtifact().isAccepted() and
    row_kind = "function-identity-candidate" and
    b = prototype.getArtifact().getPath() and
    c = prototype.getPrototypeId() and
    d = prototype.getPrototypeId() and
    e = "bytecode-prototype-id" and
    f = "bytecode-only,prototype-identity" and
    g = "" and
    h = "" and
    i = ""
  )
  or
  exists(LuaCallResolution resolution |
    resolution.getCallerModulePath() = a and
    e = resolution.getTargetValueRef() and
    row_kind = "call-target-candidate" and
    exists(LuaCallSite call |
      call.getFixtureId() = resolution.getCallerModulePath() and
      call.getCallsiteId() = resolution.getCallsiteId() and
      call.getInstruction().getPrototype().getArtifact().isAccepted() and
      b = call.getInstruction().getPrototype().getArtifact().getPath() and
      c = resolution.getCallerPrototypeId() and
      d = resolution.getCallsiteId() and
      i = call.getPc().toString()
    ) and
    (
      resolution.getResolvedName() != "" and f = resolution.getResolvedName()
      or
      resolution.getResolvedName() = "" and f = resolution.getTargetPrototypeId()
    ) and
    g = resolution.getResolutionKind() and
    h = resolution.getProvenance()
  )
  or
  literalRequireCall(a, b, c, any(int pc), d, e, f, g) and
  row_kind = "literal-require" and
  h = "" and
  i = ""
  or
  moduleResolution(a, b, c, d, e, f, g, h) and
  row_kind = "module-resolution" and
  i = ""
  or
  moduleExport(a, b, c, d, e, f, g) and
  row_kind = "module-export" and
  h = "" and
  i = ""
  or
  exists(string fieldCallsite, string provenance |
    moduleFieldCallTarget(a, d, fieldCallsite, f, e, g, provenance) and
    exists(LuaModuleResolution resolution |
      resolution.getCallerModulePath() = a and
      resolution.getStatus() = "matched" and
      resolution.getTargetModulePath() = e and
      b = resolution.getCallsiteId() and
      c = resolution.getRequireString() and
      exists(LuaCallResolution callResolution |
        callResolution.getCallerModulePath() = a and
        callResolution.getCallsiteId() = fieldCallsite and
        callResolution.getResolvedName() = c + "." + f
      )
    ) and
    row_kind = "module-field-call-target" and
    h = provenance and
    i = fieldCallsite
  )
  or
  interproceduralArgFlow(a, b, e, h, d, f, g) and
  row_kind = "interproc-arg-flow" and
  exists(string callerPrototype |
    c = callerPrototype and
    exists(LuaCallSite call |
      call.getFixtureId() = a and
      call.getCallsiteId() = b and
      callerPrototype = call.getPrototypeId()
    )
  ) and
  i = ""
  or
  interproceduralReturnFlow(a, b, h, d, e, f, g) and
  row_kind = "interproc-return-flow" and
  exists(string callerPrototype |
    c = callerPrototype and
    exists(LuaCallSite call |
      call.getFixtureId() = a and
      call.getCallsiteId() = b and
      callerPrototype = call.getPrototypeId()
    )
  ) and
  i = ""
  or
  exists(int parameterIndex |
    sourceSinkRuleMatch(a, d, e, f, g, parameterIndex, h) and
    row_kind = "rule-match" and
    exists(LuaCallSite call |
      call.getFixtureId() = a and
      call.getCallsiteId() = d and
      call.getInstruction().getPrototype().getArtifact().isAccepted() and
      b = call.getInstruction().getPrototype().getArtifact().getPath() and
      c = call.getPrototypeId() and
      i = call.getPc().toString() + ":" + parameterIndex.toString()
    )
  )
select row_kind, a, b, c, d, e, f, g, h, i
