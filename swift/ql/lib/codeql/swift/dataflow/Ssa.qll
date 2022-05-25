cached
module Ssa {
  private import swift
  private import internal.SsaImplCommon as SsaImplCommon
  private import internal.SsaImplSpecific as SsaImplSpecific
  private import codeql.swift.controlflow.CfgNodes
  private import codeql.swift.controlflow.ControlFlowGraph
  private import codeql.swift.controlflow.BasicBlocks

  cached
  class Definition extends SsaImplCommon::Definition {
    cached
    Location getLocation() { none() }

    cached
    ControlFlowNode getARead() {
      exists(VarDecl v, BasicBlock bb, int i |
        SsaImplCommon::ssaDefReachesRead(v, this, bb, i) and
        SsaImplSpecific::variableRead(bb, i, v, true) and
        result = bb.getNode(i)
      )
    }

    cached
    ControlFlowNode getAFirstRead() {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        this.definesAt(_, bb1, i1) and
        SsaImplCommon::adjacentDefNoUncertainReads(this, bb1, i1, bb2, i2) and
        result = bb2.getNode(i2)
      )
    }

    cached
    predicate adjacentReadPair(ControlFlowNode read1, ControlFlowNode read2) {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        read1 = bb1.getNode(i1) and
        SsaImplSpecific::variableRead(bb1, i1, _, true) and
        SsaImplCommon::adjacentDefNoUncertainReads(this, bb1, i1, bb2, i2) and
        read2 = bb2.getNode(i2)
      )
    }
  }

  cached
  class WriteDefinition extends Definition, SsaImplCommon::WriteDefinition {
    cached
    override Location getLocation() {
      exists(BasicBlock bb, int i |
        this.definesAt(_, bb, i) and
        result = bb.getNode(i).getLocation()
      )
    }

    /**
     * Holds if this SSA definition represents a direct assignment of `value`
     * to the underlying variable.
     */
    cached
    predicate assigns(ExprCfgNode value) {
      exists(
        AssignExpr a, BasicBlock bb, int i // TODO: use CFG node for assignment expr
      |
        this.definesAt(_, bb, i) and
        a = bb.getNode(i).getNode().asAstNode() and
        value.getNode().asAstNode() = a.getSource()
      )
      or
      exists(VarDecl var, BasicBlock bb, int blockIndex, PatternBindingDecl pbd |
        this.definesAt(var, bb, blockIndex) and
        pbd.getAPattern() = bb.getNode(blockIndex).getNode().asAstNode() and
        value.getNode().asAstNode() = var.getParentInitializer()
      )
    }
  }
}
