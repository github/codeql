import python as PY

/**
 * Provides a simple SSA implementation for local scope variables.
 */
module BaseSsa {
  private import semmle.python.Flow as Flow
  private import codeql.ssa.Ssa as SsaImplCommon

  /**
   * Holds if the `i`th node of basic block `bb` is a definition `def`,
   * targeting local scope variable `v`.
   *
   * See `SsaCompute::variableDefine`.
   */
  private predicate definitionAt(
    PY::ControlFlowNode def, SsaInput::BasicBlock bb, int i, SsaInput::SourceVariable v
  ) {
    v.hasDefiningNode(def) and
    exists(int j |
      def = bb.getNode(j) and
      i = j * 2 + 1
    )
  }

  /**
   * Holds if the `i`th node of basic block `bb` is a read `read`,
   * targeting local scope variable `v`.
   *
   * See `SsaCompute::variableUse`.
   */
  private predicate readAt(
    PY::ControlFlowNode read, SsaInput::BasicBlock bb, int i, SsaInput::SourceVariable v
  ) {
    (v.getAUse() = read or v.hasRefinement(read, _)) and
    exists(int j |
      bb.getNode(j) = read and
      i = 2 * j
    )
  }

  private module SsaInput implements SsaImplCommon::InputSig {
    class BasicBlock = Flow::BasicBlock;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    /**
     * An exit basic block, that is, a basic block whose last node is
     * the exit node of a callable.
     */
    class ExitBasicBlock extends BasicBlock {
      ExitBasicBlock() { this.getLastNode().isNormalExit() }
    }

    class SourceVariable = Flow::SsaSourceVariable;

    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(PY::ControlFlowNode def |
        definitionAt(def, bb, i, v) and
        certain = true
      )
    }

    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(PY::ControlFlowNode read |
        readAt(read, bb, i, v) and
        certain = true
      )
    }
  }

  private module SsaImpl = SsaImplCommon::Make<SsaInput>;

  class Definition extends SsaImpl::Definition {
    final PY::ControlFlowNode getARead() {
      exists(SsaInput::BasicBlock bb, int i, SsaInput::SourceVariable v |
        SsaImpl::ssaDefReachesRead(v, this, bb, i) and
        readAt(result, bb, i, v)
      )
    }

    final PY::ControlFlowNode getDefinition() {
      exists(SsaInput::BasicBlock bb, int i, SsaInput::SourceVariable v |
        this.definesAt(v, bb, i) and
        definitionAt(result, bb, i, v)
      )
    }

    final PY::ControlFlowNode firstUse() {
      exists(SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2 |
        this.definesAt(_, bb1, i1) and
        SsaImpl::adjacentDefRead(this, bb1, i1, bb2, i2) and
        readAt(result, bb2, i2, _)
      )
    }

    final PY::ControlFlowNode nextUse(PY::ControlFlowNode use) {
      exists(SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2 |
        readAt(use, bb1, i1, _) and
        SsaImpl::adjacentDefRead(this, bb1, i1, bb2, i2) and
        readAt(result, bb2, i2, _)
      )
    }

    PY::Location getLocation() { result = this.getDefinition().getLocation() }
  }

  class PhiNode extends SsaImpl::PhiNode, Definition {
    override PY::Location getLocation() { result = this.getBasicBlock().getNode(0).getLocation() }

    final Definition getAnInput() { SsaImpl::phiHasInputFromBlock(this, result, _) }
  }

  predicate defToUse(PY::ControlFlowNode def, PY::ControlFlowNode use) {
    exists(Definition ssa |
      def = ssa.getDefinition() and
      use = ssa.firstUse()
    )
  }

  predicate useToUse(PY::ControlFlowNode use1, PY::ControlFlowNode use2) {
    exists(Definition ssa |
      use1 = ssa.getARead() and
      use2 = ssa.nextUse(use1)
    )
  }
}
