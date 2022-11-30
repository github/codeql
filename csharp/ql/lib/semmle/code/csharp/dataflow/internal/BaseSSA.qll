import csharp

/**
 * Provides a simple SSA implementation for local scope variables.
 */
module BaseSsa {
  private import AssignableDefinitions
  private import codeql.ssa.Ssa as SsaImplCommon

  /**
   * Holds if the `i`th node of basic block `bb` is assignable definition `def`,
   * targeting local scope variable `v`.
   */
  private predicate definitionAt(
    AssignableDefinition def, ControlFlow::BasicBlock bb, int i, SsaInput::SourceVariable v
  ) {
    bb.getNode(i) = def.getAControlFlowNode() and
    v = def.getTarget() and
    // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
    not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = def |
      second.getAssignment() = first.getAssignment() and
      second.getEvaluationOrder() > first.getEvaluationOrder() and
      second.getTarget() = v
    )
  }

  private module SsaInput implements SsaImplCommon::InputSig {
    class BasicBlock = ControlFlow::BasicBlock;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    class ExitBasicBlock = ControlFlow::BasicBlocks::ExitBlock;

    pragma[noinline]
    private Callable getAnAssigningCallable(LocalScopeVariable v) {
      result = any(AssignableDefinition def | def.getTarget() = v).getEnclosingCallable()
    }

    class SourceVariable extends LocalScopeVariable {
      SourceVariable() { not getAnAssigningCallable(this) != getAnAssigningCallable(this) }
    }

    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignableDefinition def |
        definitionAt(def, bb, i, v) and
        if def.isCertain() then certain = true else certain = false
      )
    }

    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignableRead read |
        read.getAControlFlowNode() = bb.getNode(i) and
        read.getTarget() = v and
        certain = true
      )
    }
  }

  private module SsaImpl = SsaImplCommon::Make<SsaInput>;

  class Definition extends SsaImpl::Definition {
    final AssignableRead getARead() {
      exists(ControlFlow::BasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(_, this, bb, i) and
        result.getAControlFlowNode() = bb.getNode(i)
      )
    }

    final AssignableDefinition getDefinition() {
      exists(ControlFlow::BasicBlock bb, int i, SsaInput::SourceVariable v |
        this.definesAt(v, bb, i) and
        definitionAt(result, bb, i, v)
      )
    }

    private Definition getAPhiInputOrPriorDefinition() {
      result = this.(PhiNode).getAnInput() or
      SsaImpl::uncertainWriteDefinitionInput(this, result)
    }

    final Definition getAnUltimateDefinition() {
      result = this.getAPhiInputOrPriorDefinition*() and
      not result instanceof PhiNode
    }

    Location getLocation() { result = this.getDefinition().getLocation() }
  }

  class PhiNode extends SsaImpl::PhiNode, Definition {
    override Location getLocation() { result = this.getBasicBlock().getLocation() }

    final Definition getAnInput() { SsaImpl::phiHasInputFromBlock(this, result, _) }
  }
}
