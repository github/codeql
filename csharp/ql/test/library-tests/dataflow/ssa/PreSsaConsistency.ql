import csharp
import ControlFlow::Internal

predicate defReadInconsistency(AssignableRead ar, Expr e) {
  exists(PreSsa::Definition ssaDef, AssignableDefinition def |
    e = def.getExpr() and
    PreSsa::firstReadSameVar(ssaDef, ar) and
    ssaDef.getDefinition() = def and
    not exists(Ssa::ExplicitDefinition edef |
      edef.getADefinition() = def and
      edef.getARead() = ar
    )
  )
}

predicate readReadInconsistency(LocalScopeVariableRead read1, LocalScopeVariableRead read2) {
  PreSsa::adjacentReadPairSameVar(read1, read2) and
  not Ssa::Internal::adjacentReadPairSameVar(read1, read2)
}

from Element e1, Element e2, string s
where
  defReadInconsistency(e1, e2) and
  s = "def-read inconsistency"
  or
  readReadInconsistency(e1, e2) and
  s = "read-read inconsistency"
select e1, e2, s
