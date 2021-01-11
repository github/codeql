/**
 * Provides the module `Ssa` for working with static single assignment (SSA) form.
 */

private import CIL

/**
 * Provides classes for working with static single assignment (SSA) form.
 */
module Ssa {
  private import internal.SsaImplCommon as SsaImpl

  /** An SSA definition. */
  class Definition extends SsaImpl::Definition {
    /** Gets a read of this SSA definition. */
    final ReadAccess getARead() {
      exists(BasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(_, this, bb, i) and
        result = bb.getNode(i)
      )
    }

    /** Gets the underlying variable update, if any. */
    final VariableUpdate getVariableUpdate() {
      exists(BasicBlock bb, int i |
        result.updatesAt(bb, i) and
        this.definesAt(result.getVariable(), bb, i)
      )
    }

    /** Gets a first read of this SSA definition. */
    final ReadAccess getAFirstRead() {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        this.definesAt(_, bb1, i1) and
        SsaImpl::adjacentDefRead(this, bb1, i1, bb2, i2) and
        result = bb2.getNode(i2)
      )
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

    final Definition getAnInput() { SsaImpl::phiHasInputFromBlock(this, result, _) }
  }
}
