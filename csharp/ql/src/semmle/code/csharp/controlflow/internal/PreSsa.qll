import csharp

/**
 * Provides an SSA implementation based on "pre-basic-blocks", restricted
 * to local scope variables and fields/properties that behave like local
 * scope variables.
 */
module PreSsa {
  import pressa.SsaImplSpecific
  private import pressa.SsaImplCommon as SsaImpl

  class Definition extends SsaImpl::Definition {
    final AssignableRead getARead() {
      exists(BasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(_, this, bb, i) and
        result = bb.getElement(i)
      )
    }

    final AssignableDefinition getDefinition() {
      exists(BasicBlock bb, int i, SourceVariable v |
        this.definesAt(v, bb, i) and
        definitionAt(result, bb, i, v)
      )
    }

    final AssignableRead getAFirstRead() {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        this.definesAt(_, bb1, i1) and
        SsaImpl::adjacentDefRead(this, bb1, i1, bb2, i2) and
        result = bb2.getElement(i2)
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

    final predicate isLiveAtEndOfBlock(BasicBlock bb) {
      SsaImpl::ssaDefReachesEndOfBlock(bb, this, _)
    }

    Location getLocation() {
      result = this.getDefinition().getLocation()
      or
      exists(Callable c, BasicBlock bb, SourceVariable v |
        this.definesAt(v, bb, -1) and
        implicitEntryDef(c, bb, v) and
        result = c.getLocation()
      )
    }
  }

  class PhiNode extends SsaImpl::PhiNode, Definition {
    final override Location getLocation() { result = this.getBasicBlock().getLocation() }

    final Definition getAnInput() { SsaImpl::phiHasInputFromBlock(this, result, _) }
  }

  predicate adjacentReadPairSameVar(AssignableRead read1, AssignableRead read2) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      read1 = bb1.getElement(i1) and
      variableRead(bb1, i1, _, true) and
      SsaImpl::adjacentDefRead(_, bb1, i1, bb2, i2) and
      read2 = bb2.getElement(i2)
    )
  }
}
