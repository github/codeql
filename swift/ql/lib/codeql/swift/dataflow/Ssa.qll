cached
module Ssa {
  private import swift
  private import codeql.ssa.Ssa as SsaImplCommon
  private import codeql.swift.controlflow.CfgNodes
  private import codeql.swift.controlflow.ControlFlowGraph
  private import codeql.swift.controlflow.BasicBlocks as BasicBlocks

  private module SsaInput implements SsaImplCommon::InputSig<Location, BasicBlocks::BasicBlock> {
    private import internal.DataFlowPrivate
    private import codeql.swift.controlflow.CfgNodes

    private newtype TSourceVariable =
      TNormalSourceVariable(VarDecl v) or
      TKeyPathSourceVariable(EntryNode entry) { entry.getScope() instanceof KeyPathExpr }

    abstract class SourceVariable extends TSourceVariable {
      abstract string toString();

      VarDecl asVarDecl() { none() }

      EntryNode asKeyPath() { none() }

      DeclRefExpr getAnAccess() { result.getDecl() = this.asVarDecl() }

      Location getLocation() {
        result = this.asVarDecl().getLocation()
        or
        result = this.asKeyPath().getLocation()
      }
    }

    private class NormalSourceVariable extends SourceVariable, TNormalSourceVariable {
      VarDecl v;

      NormalSourceVariable() { this = TNormalSourceVariable(v) }

      override string toString() { result = v.toString() }

      override VarDecl asVarDecl() { result = v }
    }

    private class KeyPathSourceVariable extends SourceVariable, TKeyPathSourceVariable {
      EntryNode enter;

      KeyPathSourceVariable() { this = TKeyPathSourceVariable(enter) }

      override string toString() { result = enter.toString() }

      override EntryNode asKeyPath() { result = enter }
    }

    predicate variableWrite(BasicBlocks::BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignExpr assign |
        bb.getNode(i).getNode().asAstNode() = assign and
        assign.getDest() = v.getAnAccess() and
        certain = true
      )
      or
      // Any variable initialization through pattern matching. For example each `x*` in:
      // ```
      // var x1 = v
      // let x2 = v
      // let (x3, x4) = tuple
      // if let x5 = optional { ... }
      // guard let x6 = optional else { ... }
      // ```
      exists(NamedPattern pattern |
        bb.getNode(i).getNode().asAstNode() = pattern and
        v.asVarDecl() = pattern.getVarDecl() and
        certain = true
      )
      or
      exists(ParamDecl p |
        p = v.asVarDecl() and
        bb.getNode(i).getNode().asAstNode() = p and
        certain = true
      )
      or
      bb.getNode(i) = v.asKeyPath() and
      certain = true
      or
      // Mark the subexpression as a write of the local variable declared in the `TapExpr`.
      exists(TapExpr tap |
        v.asVarDecl() = tap.getVar() and
        bb.getNode(i).getNode().asAstNode() = tap.getSubExpr() and
        certain = true
      )
    }

    predicate variableRead(BasicBlocks::BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(DeclRefExpr ref |
        not isLValue(ref) and
        bb.getNode(i).getNode().asAstNode() = ref and
        v.asVarDecl() = ref.getDecl() and
        certain = true
      )
      or
      exists(InOutExpr expr |
        bb.getNode(i).getNode().asAstNode() = expr and
        expr.getSubExpr() = v.getAnAccess() and
        certain = true
      )
      or
      exists(ExitNode exit, Function func |
        [func.getAParam(), func.getSelfParam()] = v.asVarDecl() and
        bb.getNode(i) = exit and
        modifiableParam(v.asVarDecl()) and
        bb.getScope() = func and
        certain = true
      )
      or
      // Mark the `TapExpr` as a read of the of the local variable.
      exists(TapExpr tap |
        v.asVarDecl() = tap.getVar() and
        bb.getNode(i).getNode().asAstNode() = tap and
        certain = true
      )
    }
  }

  /**
   * INTERNAL: Do not use.
   */
  module SsaImpl = SsaImplCommon::Make<Location, BasicBlocks::Cfg, SsaInput>;

  cached
  class Definition extends SsaImpl::Definition {
    cached
    override Location getLocation() { none() }

    cached
    ControlFlowNode getARead() {
      exists(SsaInput::SourceVariable v, BasicBlocks::BasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(v, this, bb, i) and
        SsaInput::variableRead(bb, i, v, true) and
        result = bb.getNode(i)
      )
    }

    cached
    ControlFlowNode getAFirstRead() {
      exists(BasicBlocks::BasicBlock bb, int i |
        SsaImpl::firstUse(this, bb, i, true) and
        result = bb.getNode(i)
      )
    }

    cached
    predicate adjacentReadPair(ControlFlowNode read1, ControlFlowNode read2) {
      read1 = this.getARead() and
      exists(BasicBlocks::BasicBlock bb1, int i1, BasicBlocks::BasicBlock bb2, int i2 |
        read1 = bb1.getNode(i1) and
        SsaImpl::adjacentUseUse(bb1, i1, bb2, i2, _, true) and
        read2 = bb2.getNode(i2)
      )
    }

    cached
    deprecated predicate lastRefRedef(BasicBlocks::BasicBlock bb, int i, Definition next) {
      SsaImpl::lastRefRedef(this, bb, i, next)
    }
  }

  cached
  class WriteDefinition extends Definition, SsaImpl::WriteDefinition {
    cached
    override Location getLocation() {
      exists(BasicBlocks::BasicBlock bb, int i |
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
      exists(AssignExpr a, BasicBlocks::BasicBlock bb, int i |
        this.definesAt(_, bb, i) and
        a = bb.getNode(i).getNode().asAstNode() and
        value.getNode().asAstNode() = a.getSource()
      )
      or
      exists(BasicBlocks::BasicBlock bb, int blockIndex, NamedPattern np |
        this.definesAt(_, bb, blockIndex) and
        np = bb.getNode(blockIndex).getNode().asAstNode() and
        value.getNode().asAstNode() = np
      )
      or
      exists(BasicBlocks::BasicBlock bb, int blockIndex, ConditionElement ce, Expr init |
        this.definesAt(_, bb, blockIndex) and
        ce.getPattern() = bb.getNode(blockIndex).getNode().asAstNode() and
        init = ce.getInitializer() and
        strictcount(Ssa::WriteDefinition alt | alt.definesAt(_, bb, blockIndex)) = 1 // exclude cases where there are multiple writes from the same pattern, this is at best taint flow.
      |
        value.getAst() = init
      )
    }
  }

  cached
  class PhiDefinition extends Definition, SsaImpl::PhiNode {
    cached
    override Location getLocation() {
      exists(BasicBlocks::BasicBlock bb |
        this.definesAt(_, bb, _) and
        result = bb.getLocation()
      )
    }

    cached
    Definition getPhiInput(BasicBlocks::BasicBlock bb) {
      SsaImpl::phiHasInputFromBlock(this, result, bb)
    }

    cached
    Definition getAPhiInput() { result = this.getPhiInput(_) }
  }
}
