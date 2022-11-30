/**
 * Provides the module `Ssa` for working with static single assignment (SSA) form.
 */

private import CIL

/**
 * Provides classes for working with static single assignment (SSA) form.
 */
module Ssa {
  private import internal.SsaImpl as SsaImpl

  /** An SSA definition. */
  class Definition extends SsaImpl::Definition {
    /** Gets a read of this SSA definition. */
    final ReadAccess getARead() { result = SsaImpl::getARead(this) }

    /** Gets the underlying variable update, if any. */
    final VariableUpdate getVariableUpdate() {
      exists(BasicBlock bb, int i |
        result.updatesAt(bb, i) and
        this.definesAt(result.getVariable(), bb, i)
      )
    }

    /** Gets a first read of this SSA definition. */
    deprecated final ReadAccess getAFirstRead() { result = SsaImpl::getAFirstRead(this) }

    /** Holds if `first` and `second` are adjacent reads of this SSA definition. */
    deprecated final predicate hasAdjacentReads(ReadAccess first, ReadAccess second) {
      SsaImpl::hasAdjacentReads(this, first, second)
    }

    private Definition getAPhiInput() { result = this.(PhiNode).getAnInput() }

    /**
     * Gets a definition that ultimately defines this SSA definition and is
     * not itself a phi node.
     */
    final Definition getAnUltimateDefinition() {
      result = this.getAPhiInput*() and
      not result instanceof PhiNode
    }

    /** Gets the location of this SSA definition. */
    Location getLocation() { result = this.getVariableUpdate().getLocation() }
  }

  /** A phi node. */
  class PhiNode extends SsaImpl::PhiNode, Definition {
    final override Location getLocation() { result = this.getBasicBlock().getLocation() }

    /** Gets an input to this phi node. */
    final Definition getAnInput() { result = SsaImpl::getAPhiInput(this) }

    /**
     * Holds if if `def` is an input to this phi node, and a reference to `def` at
     * index `i` in basic block `bb` can reach this phi node without going through
     * other references.
     */
    deprecated final predicate hasLastInputRef(Definition def, BasicBlock bb, int i) {
      SsaImpl::lastRefRedef(def, bb, i, this) and
      def = SsaImpl::getAPhiInput(this)
    }
  }
}
