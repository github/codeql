import csharp

/**
 * Provides a simple SSA implementation for local scope variables.
 */
module BaseSsa {
  import basessa.SsaImplSpecific
  private import basessa.SsaImplCommon as SsaImpl

  class Definition extends SsaImpl::Definition {
    final AssignableRead getARead() {
      exists(BasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(_, this, bb, i) and
        result.getAControlFlowNode() = bb.getNode(i)
      )
    }

    final AssignableDefinition getDefinition() {
      exists(BasicBlock bb, int i, SourceVariable v |
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
