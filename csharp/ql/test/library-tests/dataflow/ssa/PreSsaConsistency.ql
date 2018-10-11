import csharp
import ControlFlow::Internal

predicate defReadInconsistency(AssignableRead ar, Expr e, boolean b) {
  exists(AssignableDefinition def |
    e = def.getExpr() |
    b = true and
    exists(PreSsa::Definition ssaDef |
      PreSsa::firstReadSameVar(ssaDef, ar) and
      ssaDef.getDefinition() = def and
      not exists(Ssa::ExplicitDefinition edef |
        edef.getADefinition() = def and
        edef.getAFirstRead() = ar
      )
    )
    or
    b = false and
    exists(Ssa::ExplicitDefinition edef |
      edef.getADefinition() = def and
      edef.getAFirstRead() = ar and
      def.getTarget() instanceof PreSsa::SimpleLocalScopeVariable and
      not exists(PreSsa::Definition ssaDef |
        PreSsa::firstReadSameVar(ssaDef, ar) and
        ssaDef.getDefinition() = def
      )
    )
  )
}

predicate readReadInconsistency(LocalScopeVariableRead read1, LocalScopeVariableRead read2, boolean b) {
  b = true and
  PreSsa::adjacentReadPairSameVar(read1, read2) and
  not Ssa::Internal::adjacentReadPairSameVar(read1, read2)
  or
  b = false and
  Ssa::Internal::adjacentReadPairSameVar(read1, read2) and
  read1.getTarget() instanceof PreSsa::SimpleLocalScopeVariable and
  not PreSsa::adjacentReadPairSameVar(read1, read2)
}

from Element e1, Element e2, boolean b, string s
where
  defReadInconsistency(e1, e2, b) and
  s = "def-read inconsistency (" + b + ")"
  or
  readReadInconsistency(e1, e2, b) and
  s = "read-read inconsistency (" + b + ")"
select e1, e2, s
