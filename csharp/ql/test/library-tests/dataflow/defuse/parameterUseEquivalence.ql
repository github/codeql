import csharp

/** "Naive" parameter-use implementation. */
predicate parameterReaches(Parameter p, ControlFlow::Node cfn) {
  cfn = p.getCallable().getEntryPoint().getASuccessor()
  or
  exists(ControlFlow::Node mid | parameterReaches(p, mid) |
    not mid =
      any(AssignableDefinition ad | ad.getTarget() = p and ad.isCertain()).getAControlFlowNode() and
    cfn = mid.getASuccessor()
  )
}

predicate parameterUsePair(Parameter p, AssignableRead read) {
  parameterReaches(p, read.getAControlFlowNode()) and
  read.getTarget() = p
}

private LocalScopeVariableRead getAReachableUncertainRead(
  AssignableDefinitions::ImplicitParameterDefinition p
) {
  exists(Ssa::Definition ssaDef |
    p = ssaDef.getAnUltimateDefinition().(Ssa::ExplicitDefinition).getADefinition()
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
