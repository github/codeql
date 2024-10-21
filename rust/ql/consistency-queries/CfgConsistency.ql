import rust
import codeql.rust.controlflow.internal.ControlFlowGraphImpl::Consistency as Consistency
import Consistency
import codeql.rust.controlflow.ControlFlowGraph
import codeql.rust.controlflow.internal.ControlFlowGraphImpl as CfgImpl
import codeql.rust.controlflow.internal.Completion

/**
 * All `Expr` nodes are `PostOrderTree`s
 */
query predicate nonPostOrderExpr(Expr e, string cls) {
  cls = e.getPrimaryQlClasses() and
  not e instanceof LetExpr and
  not e instanceof ParenExpr and
  exists(AstNode last, Completion c |
    CfgImpl::last(e, last, c) and
    last != e and
    c instanceof NormalCompletion
  )
}

query predicate scopeNoFirst(CfgScope scope) {
  Consistency::scopeNoFirst(scope) and
  not scope = any(Function f | not exists(f.getBody())) and
  not scope = any(ClosureExpr c | not exists(c.getBody()))
}

/** Holds if  `be` is the `else` branch of a `let` statement that results in a panic. */
private predicate letElsePanic(BlockExpr be) {
  be = any(LetStmt let).getLetElse().getBlockExpr() and
  exists(Completion c | CfgImpl::last(be, _, c) | completionIsNormal(c))
}

query predicate deadEnd(CfgImpl::Node node) {
  Consistency::deadEnd(node) and
  not letElsePanic(node.getAstNode())
}
