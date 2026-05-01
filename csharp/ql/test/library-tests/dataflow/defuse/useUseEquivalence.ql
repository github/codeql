import csharp
private import semmle.code.csharp.dataflow.internal.BaseSSA

/** "Naive" use-use implementation. */
predicate useReaches(
  LocalScopeVariableRead read, BaseSsa::SimpleLocalScopeVariable v, ControlFlowNode cfn
) {
  read.getTarget() = v and cfn = read.getControlFlowNode().getASuccessor()
  or
  exists(ControlFlowNode mid | useReaches(read, v, mid) |
    not mid =
      any(AssignableDefinition ad | ad.getTarget() = v and ad.isCertain())
          .getExpr()
          .getControlFlowNode() and
    cfn = mid.getASuccessor()
  )
}

predicate useUsePair(LocalScopeVariableRead read1, LocalScopeVariableRead read2) {
  exists(Assignable a |
    useReaches(read1, a, read2.getControlFlowNode()) and
    read2.getTarget() = a
  )
}

private newtype TLocalScopeVariableReadOrSsaDef =
  TLocalScopeVariableRead(LocalScopeVariableRead read) or
  TSsaDefinition(Ssa::Definition ssaDef)

private TLocalScopeVariableReadOrSsaDef getANextReadOrDef(TLocalScopeVariableReadOrSsaDef prev) {
  exists(LocalScopeVariableRead read | prev = TLocalScopeVariableRead(read) |
    result = TLocalScopeVariableRead(read.getANextRead())
    or
    not exists(read.getANextRead()) and
    exists(Ssa::Definition ssaDef, Ssa::PhiNode phi, BasicBlock bb |
      ssaDef.getARead() = read and
      phi.getAnInput() = ssaDef and
      phi.definesAt(_, bb, _) and
      read.getBasicBlock().getASuccessor+() = bb and
      result = TSsaDefinition(phi)
    )
  )
  or
  exists(Ssa::Definition ssaDef | prev = TSsaDefinition(ssaDef) |
    result = TLocalScopeVariableRead(ssaDef.getAFirstRead())
    or
    not exists(ssaDef.getAFirstRead()) and
    exists(Ssa::PhiNode phi |
      phi.getAnInput() = ssaDef and
      result = TSsaDefinition(phi)
    )
  )
}

private LocalScopeVariableRead getAReachableRead(LocalScopeVariableRead read) {
  TLocalScopeVariableRead(result) = getANextReadOrDef+(TLocalScopeVariableRead(read))
}

from LocalScopeVariableRead read1, LocalScopeVariableRead read2, string s
where
  read2 = getAReachableRead(read1) and not useUsePair(read1, read2) and s = "not a use/use pair"
  or
  useUsePair(read1, read2) and not read2 = getAReachableRead(read1) and s = "missing use/use pair"
select read1, read2, s
