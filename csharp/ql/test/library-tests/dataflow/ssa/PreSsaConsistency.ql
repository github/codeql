import csharp
import semmle.code.csharp.controlflow.internal.PreSsa
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl
import semmle.code.csharp.dataflow.internal.SsaImpl as SsaImpl

class CallableWithSplitting extends Callable {
  CallableWithSplitting() { this = any(SplitControlFlowElement e).getEnclosingCallable() }
}

query predicate defReadInconsistency(AssignableRead ar, Expr e, PreSsa::SourceVariable v, boolean b) {
  // Exclude definitions in callables with CFG splitting, as SSA definitions may be
  // very different from pre-SSA definitions
  not ar.getEnclosingCallable() instanceof CallableWithSplitting and
  exists(AssignableDefinition def | e = def.getExpr() |
    b = true and
    exists(PreSsa::Definition ssaDef | ssaDef.getSourceVariable() = v |
      ar = ssaDef.getAFirstRead() and
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
      def.getTarget() = v and
      not exists(PreSsa::Definition ssaDef |
        ar = ssaDef.getAFirstRead() and
        ssaDef.getDefinition() = def
      )
    )
  )
}

query predicate readReadInconsistency(
  LocalScopeVariableRead read1, LocalScopeVariableRead read2, PreSsa::SourceVariable v, boolean b
) {
  // Exclude definitions in callables with CFG splitting, as SSA definitions may be
  // very different from pre-SSA definitions
  not read1.getEnclosingCallable() instanceof CallableWithSplitting and
  (
    b = true and
    v = read1.getTarget() and
    PreSsa::adjacentReadPairSameVar(read1, read2) and
    not SsaImpl::adjacentReadPairSameVar(_, read1.getAControlFlowNode(), read2.getAControlFlowNode())
    or
    b = false and
    v = read1.getTarget() and
    SsaImpl::adjacentReadPairSameVar(_, read1.getAControlFlowNode(), read2.getAControlFlowNode()) and
    read1.getTarget() instanceof PreSsa::SourceVariable and
    not PreSsa::adjacentReadPairSameVar(read1, read2) and
    // Exclude split CFG elements because SSA may be more precise than pre-SSA
    // in those cases
    not read1 instanceof SplitControlFlowElement and
    not read2 instanceof SplitControlFlowElement
  )
}

query predicate phiInconsistency(ControlFlowElement cfe, Expr e, PreSsa::SourceVariable v, boolean b) {
  // Exclude definitions in callables with CFG splitting, as SSA definitions may be
  // very different from pre-SSA definitions
  not cfe.getEnclosingCallable() instanceof CallableWithSplitting and
  exists(AssignableDefinition adef | e = adef.getExpr() |
    b = true and
    exists(PreSsa::PhiNode prePhi | v = prePhi.getSourceVariable() |
      adef = prePhi.getAnInput+().getDefinition() and
      cfe = prePhi.getBasicBlock().getFirstElement() and
      not exists(Ssa::PhiNode phi, ControlFlow::BasicBlock bb, Ssa::ExplicitDefinition edef |
        edef = phi.getAnUltimateDefinition()
      |
        edef.getADefinition() = adef and
        phi.definesAt(_, bb, _) and
        cfe = bb.getFirstNode().getElement()
      )
    )
    or
    b = false and
    exists(Ssa::PhiNode phi, ControlFlow::BasicBlock bb, Ssa::ExplicitDefinition edef |
      v = phi.getSourceVariable().getAssignable()
    |
      edef = phi.getAnUltimateDefinition() and
      edef.getADefinition() = adef and
      phi.definesAt(_, bb, _) and
      cfe = bb.getFirstNode().getElement() and
      not exists(PreSsa::PhiNode prePhi |
        adef = prePhi.getAnInput+().getDefinition() and
        cfe = prePhi.getBasicBlock().getFirstElement()
      )
    )
  )
}
