import codeql.ruby.controlflow.internal.ControlFlowGraphImpl::Consistency as Consistency
import Consistency
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

query predicate scopeNoFirst(CfgScope scope) {
  Consistency::scopeNoFirst(scope) and
  not scope = any(StmtSequence seq | not exists(seq.getAStmt())) and
  not scope =
    any(Callable c |
      not exists(c.getAParameter()) and
      not c.(BodyStmt).hasEnsure() and
      not exists(c.(BodyStmt).getARescue())
    )
}
