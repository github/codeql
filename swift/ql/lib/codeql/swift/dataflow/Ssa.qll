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

    cached
    predicate lastRefRedef(BasicBlock bb, int i, Definition next) {
      SsaImplCommon::lastRefRedef(this, bb, i, next)
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
    predicate assigns(CfgNode value) {
      exists(
        AssignExpr a, BasicBlock bb, int i // TODO: use CFG node for assignment expr
      |
        this.definesAt(_, bb, i) and
        a = bb.getNode(i).getNode().asAstNode() and
        value.getNode().asAstNode() = a.getSource()
      )
      or
      exists(VarDecl var, BasicBlock bb, int blockIndex, PatternBindingDecl pbd, Expr init |
        this.definesAt(var, bb, blockIndex) and
        pbd.getAPattern() = bb.getNode(blockIndex).getNode().asAstNode() and
        init = var.getParentInitializer()
      |
        value.getNode().asAstNode() = init
        or
        // TODO: We should probably enumerate more cfg nodes here.
        value.(PropertyGetterCfgNode).getRef() = init
      )
    }

    cached
    predicate isInoutDef(ExprCfgNode argument) {
      // TODO: This should probably not be only `ExprCfgNode`s.
      exists(
        ApplyExpr c, BasicBlock bb, int blockIndex, VarDecl v, InOutExpr argExpr // TODO: use CFG node for assignment expr
      |
        this.definesAt(v, bb, blockIndex) and
        bb.getNode(blockIndex).getNode().asAstNode() = c and
        [c.getAnArgument().getExpr(), c.getQualifier()] = argExpr and
        argExpr = argument.getNode().asAstNode() and
        argExpr.getSubExpr() = v.getAnAccess() // TODO: fields?
      )
    }
  }

  cached
  class PhiDefinition extends Definition, SsaImplCommon::PhiNode {
    cached
    override Location getLocation() {
      exists(BasicBlock bb, int i |
        this.definesAt(_, bb, i) and
        result = bb.getLocation()
      )
    }

    cached
    Definition getPhiInput(BasicBlock bb) { SsaImplCommon::phiHasInputFromBlock(this, result, bb) }

    cached
    Definition getAPhiInput() { result = this.getPhiInput(_) }
  }
}
