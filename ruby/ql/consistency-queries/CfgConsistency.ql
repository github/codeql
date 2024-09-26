import codeql.ruby.controlflow.internal.ControlFlowGraphImpl::Consistency
import codeql.ruby.AST
import codeql.ruby.CFG
import codeql.ruby.controlflow.internal.Completion
import codeql.ruby.controlflow.internal.ControlFlowGraphImpl as CfgImpl

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
    CfgImpl::last(e, last, c) and
    last != e and
    c instanceof NormalCompletion
  )
}
