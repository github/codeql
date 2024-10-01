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
  not e instanceof LogicalAndExpr and // todo
  not e instanceof LogicalOrExpr and
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
