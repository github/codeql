import codeql.lua.Bytecode

from string fixture, string subject, string detail, string value
where
  exists(LuaPrototype p |
    p.getFixtureId() = "bc-prototype-params/input.luac" and
    p.getPrototypeId() = "root" and
    fixture = p.getFixtureId().regexpReplaceAll("/.*", "") and
    subject = p.getPrototypeId() and
    detail = "prototype" and
    value = "exists"
  )
  or
  exists(LuaPrototype p |
    p.getFixtureId() = "bc-prototype-params/input.luac" and
    p.getPrototypeId() = "root.0" and
    p.getParentPrototypeId() = "root" and
    fixture = p.getFixtureId().regexpReplaceAll("/.*", "") and
    subject = p.getPrototypeId() and
    detail = "parent=root" and
    value = "num_params=" + p.getNumParams().toString()
  )
  or
  exists(@lua_instruction instruction, string fixtureId, string prototypeId, int pc |
    lua_instructions(instruction, _, fixtureId, prototypeId, pc, "CLOSURE", _, _, _) and
    fixtureId = "bc-prototype-params/input.luac" and
    prototypeId = "root" and
    pc = 0 and
    fixture = fixtureId.regexpReplaceAll("/.*", "") and
    subject = prototypeId + "@pc" + pc.toString() and
    detail = "instruction" and
    value = "CLOSURE"
  )
  or
  exists(LuaConstant c |
    c.getFixtureId() = "bc-constants-call/input.luac" and
    c.getConstantId() = "root:k0" and
    c.getLuaType() = "string" and
    c.getValue() = "alpha" and
    fixture = c.getFixtureId().regexpReplaceAll("/.*", "") and
    subject = c.getConstantId() and
    detail = c.getLuaType() and
    value = c.getValue()
  )
  or
  exists(LuaConstant c |
    c.getFixtureId() = "bc-constants-call/input.luac" and
    c.getConstantId() = "root:k1" and
    c.getLuaType() = "number" and
    c.getValue() = "7.0" and
    fixture = c.getFixtureId().regexpReplaceAll("/.*", "") and
    subject = c.getConstantId() and
    detail = c.getLuaType() and
    value = c.getValue()
  )
  or
  exists(LuaPrototype p |
    p.getFixtureId() = "bc-stripped-metadata/input.luac" and
    p.getPrototypeId() = "root.0" and
    p.getMappingState() = "stripped/unavailable" and
    fixture = p.getFixtureId().regexpReplaceAll("/.*", "") and
    subject = p.getPrototypeId() and
    detail = "mapping-state" and
    value = p.getMappingState()
  )
select fixture, subject, detail, value
