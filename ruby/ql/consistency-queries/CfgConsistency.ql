import codeql.ruby.controlflow.internal.ControlFlowGraphImplShared::Consistency
import codeql.ruby.AST
import codeql.ruby.controlflow.internal.Completion
import codeql.ruby.controlflow.internal.ControlFlowGraphImpl

/**
 * All `Expr` nodes are `PostOrderTree`s
 */
query predicate nonPostOrderExpr(Expr e, string cls) {
  cls = e.getPrimaryQlClasses() and
  not exists(e.getDesugared()) and
  not e instanceof BeginExpr and
  not e instanceof Namespace and
  not e instanceof Toplevel and
  exists(AstNode last, Completion c |
    last(e, last, c) and
    last != e and
    c instanceof NormalCompletion
  )
}
