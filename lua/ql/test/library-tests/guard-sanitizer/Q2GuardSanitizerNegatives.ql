import codeql.lua.RulesSanitizerReport

from LuaFlowNode source, LuaFlowNode sink
where
  source.getModulePath() = "input.luac" and
  source.getValueRef() = "root@pc8:r2" and
  sink.getModulePath() = "input.luac" and
  sink.getValueRef() = "root@pc16:r4" and
  activeReportPath(source, sink, _, _, _)
select "guard-sanitized-path-emitted-active-report", source, sink
