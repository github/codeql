/**
 * Provides classes for recognizing control flow graph inconsistencies.
 */

private import rust
private import codeql.rust.controlflow.internal.ControlFlowGraphImpl::Consistency as Consistency
import Consistency
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.internal.ControlFlowGraphImpl as CfgImpl
private import codeql.rust.controlflow.internal.Completion
private import codeql.rust.controlflow.internal.CfgNodes::Consistency as CfgNodes
private import codeql.rust.Diagnostics

private predicate nonPostOrderExpr(Expr e) {
  not e instanceof LetExpr and
  not e instanceof ParenExpr and
  exists(AstNode last, Completion c |
    CfgImpl::last(e, last, c) and
    last != e and
    c instanceof NormalCompletion
  )
}

/**
 * All `Expr` nodes are `PostOrderTree`s
 */
query predicate nonPostOrderExpr(Expr e, string cls) {
  nonPostOrderExpr(e) and
  cls = e.getPrimaryQlClasses()
}

/**
 * Holds if CFG scope `scope` lacks an initial AST node.  Overrides shared consistency predicate.
 */
query predicate scopeNoFirst(CfgScope scope) {
  Consistency::scopeNoFirst(scope) and
  not scope =
    [
      any(AstNode f | not f.(Function).hasBody()),
      any(ClosureExpr c | not c.hasBody()),
      any(AsyncBlockExpr b | not b.hasStmtList())
    ]
}

/** Holds if  `be` is the `else` branch of a `let` statement that results in a panic. */
private predicate letElsePanic(BlockExpr be) {
  be = any(LetStmt let).getLetElse().getBlockExpr() and
  exists(Completion c | CfgImpl::last(be, _, c) | completionIsNormal(c))
}

/**
 * Holds if `node` is lacking a successor. Overrides shared consistency predicate.
 */
query predicate deadEnd(CfgImpl::Node node) {
  Consistency::deadEnd(node) and
  not letElsePanic(node.getAstNode())
}

pragma[nomagic]
private predicate successfullyExtractedFile(File f) {
  not exists(ExtractionWarning ee | ee.getLocation().getFile() = f)
}

query predicate missingCfgChild(CfgNode parent, string pred, int i, AstNode child) {
  CfgNodes::missingCfgChild(parent, pred, i, child) and
  successfullyExtractedFile(child.getLocation().getFile()) and
  not exists(AstNode last, CfgImpl::Completion c | CfgImpl::last(child, last, c) |
    // In for example `if (a && true) ...`, there is no edge from the CFG node
    // for `true` into the `[false] a && true` node.
    strictcount(ConditionalSuccessor cs | exists(last.getACfgNode().getASuccessor(cs)) | cs) = 1
    or
    // In for example `x && return`, there is no edge from the node for
    // `return` into the `&&` node.
    not c instanceof CfgImpl::NormalCompletion
  )
}

/**
 * Gets counts of control flow graph inconsistencies of each type.
 */
int getCfgInconsistencyCounts(string type) {
  // total results from all the CFG consistency query predicates in:
  //  - `codeql.rust.controlflow.internal.CfgConsistency` (this file)
  //  - `shared.controlflow.codeql.controlflow.Cfg`
  type = "Non-unique set representation" and
  result = count(CfgImpl::Splits ss | nonUniqueSetRepresentation(ss, _) | ss)
  or
  type = "Splitting invariant 2" and
  result = count(AstNode n | breakInvariant2(n, _, _, _, _, _) | n)
  or
  type = "Splitting invariant 3" and
  result = count(AstNode n | breakInvariant3(n, _, _, _, _, _) | n)
  or
  type = "Splitting invariant 4" and
  result = count(AstNode n | breakInvariant4(n, _, _, _, _, _) | n)
  or
  type = "Splitting invariant 5" and
  result = count(AstNode n | breakInvariant5(n, _, _, _, _, _) | n)
  or
  type = "Multiple successors of the same type" and
  result = count(CfgNode n | multipleSuccessors(n, _, _) | n)
  or
  type = "Simple and normal successors" and
  result = count(CfgNode n | simpleAndNormalSuccessors(n, _, _, _, _) | n)
  or
  type = "Dead end" and
  result = count(CfgNode n | deadEnd(n) | n)
  or
  type = "Non-unique split kind" and
  result = count(CfgImpl::SplitImpl si | nonUniqueSplitKind(si, _) | si)
  or
  type = "Non-unique list order" and
  result = count(CfgImpl::SplitKind sk | nonUniqueListOrder(sk, _) | sk)
  or
  type = "Multiple toStrings" and
  result = count(CfgNode n | multipleToString(n) | n)
  or
  type = "CFG scope lacks initial AST node" and
  result = count(CfgScope s | scopeNoFirst(s) | s)
  or
  type = "Non-PostOrderTree Expr node" and
  result = count(Expr e | nonPostOrderExpr(e) | e)
  or
  type = "Missing CFG child" and
  result = count(CfgNode parent, string pred, int child | missingCfgChild(parent, pred, child, _))
}
