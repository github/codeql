import codeql.lua.Bytecode

from string fixture, string subject, string detail
where
  exists(LuaDiagnostic d |
    d.getFixtureId().regexpMatch("bc-malformed-diagnostic/.*") and
    fixture = d.getFixtureId().regexpReplaceAll("/.*", "") and
    subject = d.getKind() and
    detail = d.getInputRef()
  )
  or
  exists(LuaPrototype p |
    p.getFixtureId().regexpMatch("bc-malformed-diagnostic/.*") and
    fixture = p.getFixtureId().regexpReplaceAll("/.*", "") and
    subject = "unexpected-accepted-prototype" and
    detail = p.getPrototypeId()
  )
select fixture, subject, detail
