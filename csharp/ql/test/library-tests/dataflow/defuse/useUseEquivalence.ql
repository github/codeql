import csharp

/** "Naive" use-use implementation. */
predicate useReaches(LocalScopeVariableRead read, LocalScopeVariable v, ControlFlow::Node cfn) {
  read.getTarget() = v and cfn = read.getAControlFlowNode().getASuccessor()
  or
  exists(ControlFlow::Node mid | useReaches(read, v, mid) |
    not mid =
      any(AssignableDefinition ad | ad.getTarget() = v and ad.isCertain()).getAControlFlowNode() and
    cfn = mid.getASuccessor()
  )
}

predicate useUsePair(LocalScopeVariableRead read1, LocalScopeVariableRead read2) {
  exists(Assignable a |
    useReaches(read1, a, read2.getAControlFlowNode()) and
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
    exists(
      Ssa::Definition ssaDef, Ssa::PhiNode phi, ControlFlow::Node cfn, ControlFlow::BasicBlock bb,
      int i
    |
      ssaDef.getARead() = read
    |
      phi.getAnInput() = ssaDef and
      phi.definesAt(_, bb, i) and
      cfn = read.getAReachableElement().getAControlFlowNode() and
      (
        cfn = bb.getNode(i)
        or
        cfn = bb.getFirstNode() and i < 0
      ) and
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
