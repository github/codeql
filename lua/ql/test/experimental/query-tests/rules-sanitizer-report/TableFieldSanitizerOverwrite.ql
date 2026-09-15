import codeql.lua.RulesSanitizerReport

private predicate hasActiveReport(string fixture) {
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    sink.getModulePath() = fixture and
    activeReportPath(source, sink, _, _, _)
  )
}

private predicate hasSanitizedReport(string fixture) {
  exists(LuaFlowNode source, LuaFlowNode sink |
    source.getModulePath() = fixture and
    sink.getModulePath() = fixture and
    sanitizedReportPath(source, sink)
  )
}

from string fixture, string behavior
where
  fixture = "table-field-sanitizer-overwrite/same-field.luac" and
  hasSanitizedReport(fixture) and
  not hasActiveReport(fixture) and
  behavior = "same static field replacement is sanitized only"
  or
  fixture = "table-field-sanitizer-overwrite/unrelated-field.luac" and
  hasActiveReport(fixture) and
  behavior = "unrelated static field replacement remains active"
  or
  fixture = "table-field-sanitizer-overwrite/optional-branch.luac" and
  hasActiveReport(fixture) and
  behavior = "optional same-field replacement remains active"
  or
  fixture = "table-field-sanitizer-overwrite/dynamic-key.luac" and
  hasActiveReport(fixture) and
  behavior = "dynamic-key replacement remains active"
select fixture, behavior
