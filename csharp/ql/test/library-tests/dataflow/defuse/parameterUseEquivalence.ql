import csharp
private import semmle.code.csharp.dataflow.internal.BaseSSA

/** "Naive" parameter-use implementation. */
predicate parameterReaches(Parameter p, ControlFlowNode cfn) {
  cfn = p.getCallable().getEntryPoint().getASuccessor() and
  p instanceof BaseSsa::SimpleLocalScopeVariable
  or
  exists(ControlFlowNode mid | parameterReaches(p, mid) |
    not mid =
      any(AssignableDefinition ad | ad.getTarget() = p and ad.isCertain())
          .getExpr()
          .getControlFlowNode() and
    cfn = mid.getASuccessor()
  )
}

predicate parameterUsePair(Parameter p, AssignableRead read) {
  parameterReaches(p, read.getControlFlowNode()) and
  read.getTarget() = p
}

private LocalScopeVariableRead getAReachableUncertainRead(
  AssignableDefinitions::ImplicitParameterDefinition p
) {
  exists(Ssa::Definition ssaDef |
    p.getParameter() =
      ssaDef.getAnUltimateDefinition().(Ssa::ImplicitParameterDefinition).getParameter()
  |
    result = ssaDef.getARead()
  )
}

from AssignableDefinitions::ImplicitParameterDefinition p, AssignableRead read, string s
where
  read = getAReachableUncertainRead(p) and
  not parameterUsePair(p.getParameter(), read) and
  s = "not a param/use pair"
  or
  parameterUsePair(p.getParameter(), read) and
  not read = getAReachableUncertainRead(p) and
  s = "missing param/use pair"
select p, read, s
