import csharp
private import semmle.code.csharp.dataflow.internal.BaseSSA

/** "Naive" def-use implementation. */
predicate defReaches(
  AssignableDefinition def, BaseSsa::SimpleLocalScopeVariable v, ControlFlowNode cfn
) {
  def.getTarget() = v and
  cfn =
    [
      def.getExpr().getControlFlowNode(),
      def.(AssignableDefinitions::ImplicitParameterDefinition).getParameter().getControlFlowNode()
    ].getASuccessor()
  or
  exists(ControlFlowNode mid | defReaches(def, v, mid) |
    not mid =
      any(AssignableDefinition ad | ad.getTarget() = v and ad.isCertain())
          .getExpr()
          .getControlFlowNode() and
    cfn = mid.getASuccessor()
  )
}

predicate defUsePair(AssignableDefinition def, AssignableRead read) {
  exists(Assignable a |
    defReaches(def, a, read.getControlFlowNode()) and
    read.getTarget() = a
  )
}

private LocalScopeVariableRead getAReachableUncertainRead(AssignableDefinition def) {
  exists(Ssa::Definition ssaDef |
    def = ssaDef.getAnUltimateDefinition().(Ssa::ExplicitDefinition).getADefinition()
  |
    result = ssaDef.getARead()
  )
}

from AssignableDefinition def, LocalScopeVariableRead read, string s
where
  read = getAReachableUncertainRead(def) and
  not defUsePair(def, read) and
  s = "not a def/use pair"
  or
  defUsePair(def, read) and
  not read = getAReachableUncertainRead(def) and
  s = "missing def/use pair"
select def, read, s
