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
    bb.getNode(i) = def.getExpr().getAControlFlowNode() and
    v = def.getTarget() and
    // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
    not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = def |
      second.getAssignment() = first.getAssignment() and
      second.getEvaluationOrder() > first.getEvaluationOrder() and
      second.getTarget() = v
    )
  }

  private predicate implicitEntryDef(
    Callable c, ControlFlow::BasicBlocks::EntryBlock bb, SsaInput::SourceVariable v
  ) {
    exists(ControlFlow::ControlFlow::BasicBlocks::EntryBlock entry |
      c = entry.getCallable() and
      // In case `c` has multiple bodies, we want each body to get its own implicit
      // entry definition. In case `c` doesn't have multiple bodies, the line below
      // is simply the same as `bb = entry`, because `entry.getFirstNode().getASuccessor()`
      // will be in the entry block.
      bb = entry.getFirstNode().getASuccessor().getBasicBlock() and
      c = v.getCallable()
    |
      v.isReadonlyCapturedBy(c)
      or
      v instanceof Parameter
    )
  }

  private module SsaInput implements SsaImplCommon::InputSig<Location> {
    private import semmle.code.csharp.controlflow.internal.PreSsa

    class BasicBlock = ControlFlow::BasicBlock;

    class ControlFlowNode = ControlFlow::Node;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    class ExitBasicBlock extends BasicBlock, ControlFlow::BasicBlocks::ExitBlock { }

    class SourceVariable = PreSsa::SimpleLocalScopeVariable;

    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignableDefinition def |
        definitionAt(def, bb, i, v) and
        if def.isCertain() then certain = true else certain = false
      )
      or
      implicitEntryDef(_, bb, v) and
      i = -1 and
      certain = true
    }

    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignableRead read |
        read.getAControlFlowNode() = bb.getNode(i) and
        read.getTarget() = v and
        certain = true
      )
    }
  }

  private module SsaImpl = SsaImplCommon::Make<Location, SsaInput>;

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

    final predicate isImplicitEntryDefinition(SsaInput::SourceVariable v) {
      exists(ControlFlow::BasicBlock bb |
        this.definesAt(v, bb, -1) and
        implicitEntryDef(_, bb, v)
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

    override Location getLocation() {
      result = this.getDefinition().getLocation()
      or
      exists(Callable c, SsaInput::BasicBlock bb, SsaInput::SourceVariable v |
        this.definesAt(v, bb, -1) and
        implicitEntryDef(c, bb, v) and
        result = c.getLocation()
      )
    }
  }

  class PhiNode extends SsaImpl::PhiNode, Definition {
    override Location getLocation() { result = this.getBasicBlock().getLocation() }

    final Definition getAnInput() { SsaImpl::phiHasInputFromBlock(this, result, _) }
  }
}
