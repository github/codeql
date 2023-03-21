cached
module Ssa {
  private import swift
  private import codeql.ssa.Ssa as SsaImplCommon
  private import codeql.swift.controlflow.CfgNodes
  private import codeql.swift.controlflow.ControlFlowGraph
  private import codeql.swift.controlflow.BasicBlocks as BasicBlocks

  private module SsaInput implements SsaImplCommon::InputSig {
    private import internal.DataFlowPrivate
    private import codeql.swift.controlflow.ControlFlowGraph
    private import codeql.swift.controlflow.CfgNodes

    class BasicBlock = BasicBlocks::BasicBlock;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    class ExitBasicBlock = BasicBlocks::ExitBasicBlock;

    class SourceVariable = VarDecl;

    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
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
      exists(Pattern pattern |
        bb.getNode(i).getNode().asAstNode() = pattern and
        v.getParentPattern() = pattern and
        certain = true
      )
      or
      v instanceof ParamDecl and
      bb.getNode(i).getNode().asAstNode() = v and
      certain = true
      or
      // Mark the subexpression as a write of the local variable declared in the `TapExpr`.
      exists(TapExpr tap |
        v = tap.getVar() and
        bb.getNode(i).getNode().asAstNode() = tap.getSubExpr() and
        certain = true
      )
    }

    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(DeclRefExpr ref |
        not isLValue(ref) and
        bb.getNode(i).getNode().asAstNode() = ref and
        v = ref.getDecl() and
        certain = true
      )
      or
      exists(InOutExpr expr |
        bb.getNode(i).getNode().asAstNode() = expr and
        expr.getSubExpr() = v.getAnAccess() and
        certain = true
      )
      or
      exists(ExitNode exit, AbstractFunctionDecl func |
        func.getAParam() = v or func.getSelfParam() = v
      |
        bb.getNode(i) = exit and
        modifiableParam(v) and
        bb.getScope() = func and
        certain = true
      )
      or
      // Mark the `TapExpr` as a read of the of the local variable.
      exists(TapExpr tap |
        v = tap.getVar() and
        bb.getNode(i).getNode().asAstNode() = tap and
        certain = true
      )
    }
  }

  private module SsaImpl = SsaImplCommon::Make<SsaInput>;

  cached
  class Definition extends SsaImpl::Definition {
    cached
    Location getLocation() { none() }

    cached
    ControlFlowNode getARead() {
      exists(VarDecl v, SsaInput::BasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(v, this, bb, i) and
        SsaInput::variableRead(bb, i, v, true) and
        result = bb.getNode(i)
      )
    }

    cached
    ControlFlowNode getAFirstRead() {
      exists(SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2 |
        this.definesAt(_, bb1, i1) and
        SsaImpl::adjacentDefRead(this, bb1, i1, bb2, i2) and
        result = bb2.getNode(i2)
      )
    }

    cached
    predicate adjacentReadPair(ControlFlowNode read1, ControlFlowNode read2) {
      exists(SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2 |
        read1 = bb1.getNode(i1) and
        SsaInput::variableRead(bb1, i1, _, true) and
        SsaImpl::adjacentDefRead(this, bb1, i1, bb2, i2) and
        read2 = bb2.getNode(i2)
      )
    }

    cached
    predicate lastRefRedef(SsaInput::BasicBlock bb, int i, Definition next) {
      SsaImpl::lastRefRedef(this, bb, i, next)
    }
  }

  cached
  class WriteDefinition extends Definition, SsaImpl::WriteDefinition {
    cached
    override Location getLocation() {
      exists(SsaInput::BasicBlock bb, int i |
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
        AssignExpr a, SsaInput::BasicBlock bb, int i // TODO: use CFG node for assignment expr
      |
        this.definesAt(_, bb, i) and
        a = bb.getNode(i).getNode().asAstNode() and
        value.getNode().asAstNode() = a.getSource()
      )
      or
      exists(
        VarDecl var, SsaInput::BasicBlock bb, int blockIndex, PatternBindingDecl pbd, Expr init
      |
        this.definesAt(var, bb, blockIndex) and
        pbd.getAPattern() = bb.getNode(blockIndex).getNode().asAstNode() and
        init = var.getParentInitializer()
      |
        value.getAst() = init
      )
      or
      exists(SsaInput::BasicBlock bb, int blockIndex, ConditionElement ce, Expr init |
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
      exists(SsaInput::BasicBlock bb |
        this.definesAt(_, bb, _) and
        result = bb.getLocation()
      )
    }

    cached
    Definition getPhiInput(SsaInput::BasicBlock bb) {
      SsaImpl::phiHasInputFromBlock(this, result, bb)
    }

    cached
    Definition getAPhiInput() { result = this.getPhiInput(_) }
  }
}
