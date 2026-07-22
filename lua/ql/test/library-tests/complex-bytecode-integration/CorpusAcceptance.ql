import codeql.lua.SourceFile
import codeql.lua.RulesSanitizerReport

from string rowKind, string first, string second, string third
where
  rowKind = "metric" and
  third = "" and
  (
    first = "source-files" and
    second = count(LuaSourceFile file | any()).toString()
    or
    first = "bytecode-artifacts" and
    second = count(LuaArtifact artifact | any()).toString()
    or
    first = "accepted-artifacts" and
    second = count(LuaArtifact artifact | artifact.isAccepted()).toString()
    or
    first = "diagnostics" and
    second = count(LuaDiagnostic diagnostic | any()).toString()
    or
    first = "active-findings" and
    second =
      count(LuaFlowNode source, LuaFlowNode sink | activeReportPath(source, sink, _, _, _))
          .toString()
    or
    first = "sanitized-findings" and
    second =
      count(LuaFlowNode source, LuaFlowNode sink | sanitizedReportPath(source, sink)).toString()
    or
    first = "module-analysis-present" and
    second = "1" and
    exists(string fixture, string modulePath, string moduleName, string provenance |
      moduleIdentity(fixture, modulePath, moduleName, provenance)
    )
    or
    first = "interprocedural-analysis-present" and
    second = "1" and
    exists(LuaInterproceduralFlow flow | flow.getSourceRef() != "")
    or
    first = "cross-module-flow-present" and
    second = "1" and
    exists(string sourceModule, string sourceRef, string sinkModule, string sinkRef |
      sourceModule != sinkModule and
      genericFlowStep(sourceModule, sourceRef, sinkModule, sinkRef, _, _)
    )
    or
    first = "active-projections-complete" and
    second = "1" and
    not exists(LuaFlowNode source, LuaFlowNode sink |
      activeReportPath(source, sink, _, _, _) and
      (
        source.getModulePath() = "" or
        source.getValueRef() = "" or
        sink.getModulePath() = "" or
        sink.getValueRef() = ""
      )
    )
  )
  or
  exists(LuaFlowNode source, LuaFlowNode sink |
    activeReportPath(source, sink, _, _, _) and
    rowKind = "active" and
    first = sink.getModulePath() and
    second = source.toString() and
    third = sink.toString()
  )
select rowKind, first, second, third
