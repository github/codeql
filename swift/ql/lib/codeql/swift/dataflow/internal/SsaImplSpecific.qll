/** Provides the Swift specific parameters for `SsaImplCommon.qll`. */

private import swift
private import codeql.swift.controlflow.BasicBlocks as BasicBlocks
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.CfgNodes

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
  exists(CallExpr call, Argument arg |
    arg.getExpr().(InOutExpr).getSubExpr() = v.getAnAccess() and
    call.getAnArgument() = arg and
    call.getStaticTarget().getParam(arg.getIndex()).isInout() and
    bb.getNode(i).getNode().asAstNode() = call and
    certain = false
  )
  or
  v instanceof ParamDecl and
  bb.getNode(i).getNode().asAstNode() = v and
  certain = true
}

private predicate isLValue(DeclRefExpr ref) { any(AssignExpr assign).getDest() = ref }

predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  exists(DeclRefExpr ref |
    not isLValue(ref) and
    bb.getNode(i).getNode().asAstNode() = ref and
    v = ref.getDecl() and
    certain = true
  )
  or
  exists(ExitNode exit, AbstractFunctionDecl func |
    bb.getNode(i) = exit and
    v.(ParamDecl).isInout() and
    func.getAParam() = v and
    bb.getScope() = func and
    certain = true
  )
}
