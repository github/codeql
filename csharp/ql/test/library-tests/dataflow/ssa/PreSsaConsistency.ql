import csharp
import ControlFlow::Internal

query
predicate defReadInconsistency(AssignableRead ar, Expr e, PreSsa::SimpleAssignable a, boolean b) {
  exists(AssignableDefinition def |
    e = def.getExpr() |
    b = true and
    exists(PreSsa::Definition ssaDef |
      ssaDef.getAssignable() = a |
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
      def.getTarget() = a and
      not exists(PreSsa::Definition ssaDef |
        PreSsa::firstReadSameVar(ssaDef, ar) and
        ssaDef.getDefinition() = def
      )
    )
  )
}

query
predicate readReadInconsistency(LocalScopeVariableRead read1, LocalScopeVariableRead read2, PreSsa::SimpleAssignable a, boolean b) {
  b = true and
  a = read1.getTarget() and
  PreSsa::adjacentReadPairSameVar(read1, read2) and
  not Ssa::Internal::adjacentReadPairSameVar(read1, read2)
  or
  b = false and
  a = read1.getTarget() and
  Ssa::Internal::adjacentReadPairSameVar(read1, read2) and
  read1.getTarget() instanceof PreSsa::SimpleAssignable and
  not PreSsa::adjacentReadPairSameVar(read1, read2)
}

query
predicate phiInconsistency(ControlFlowElement cfe, Expr e, PreSsa::SimpleAssignable a, boolean b) {
  exists(AssignableDefinition adef |
    e = adef.getExpr() |
    b = true and
    exists(PreSsa::Definition def |
      a = def.getAssignable() |
      adef = def.getAPhiInput+().getDefinition() and
      cfe = def.getBasicBlock().getFirstElement() and
      not exists(Ssa::PhiNode phi, ControlFlow::BasicBlock bb, Ssa::ExplicitDefinition edef |
        edef = phi.getAnUltimateDefinition() |
        edef.getADefinition() = adef and
        phi.definesAt(bb, _) and
        cfe = bb.getFirstNode().getElement()
      )
    )
    or
    b = false and
    exists(Ssa::PhiNode phi, ControlFlow::BasicBlock bb, Ssa::ExplicitDefinition edef |
      a = phi.getSourceVariable().getAssignable() |
      edef = phi.getAnUltimateDefinition() and
      edef.getADefinition() = adef and
      phi.definesAt(bb, _) and
      cfe = bb.getFirstNode().getElement() and
      not exists(PreSsa::Definition def |
        adef = def.getAPhiInput+().getDefinition() and
        cfe = def.getBasicBlock().getFirstElement()
      )
    )
  )
}
