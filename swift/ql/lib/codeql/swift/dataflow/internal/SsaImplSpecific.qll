/** Provides the Swift specific parameters for `SsaImplCommon.qll`. */

private import swift
private import codeql.swift.controlflow.BasicBlocks as BasicBlocks
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.CfgNodes
private import DataFlowPrivate

class BasicBlock = BasicBlocks::BasicBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

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
  exists(PatternBindingDecl decl, Pattern pattern |
    bb.getNode(i).getNode().asAstNode() = pattern and
    decl.getAPattern() = pattern and
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
