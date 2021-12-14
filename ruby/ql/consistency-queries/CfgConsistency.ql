import codeql.ruby.controlflow.internal.ControlFlowGraphImplShared::Consistency
import codeql.ruby.AST
import codeql.ruby.controlflow.internal.ControlFlowGraphImpl

/**
 * All `Expr` nodes are `PostOrderTree`s
 */
query predicate nonPostOrderExprTypes(string cls) {
  exists(Expr e |
    e instanceof ControlFlowTree and
    not exists(e.getDesugared()) and
    cls = e.getAPrimaryQlClass() and
    not e instanceof PostOrderTree and
    not e instanceof LeafTree
  )
  or
  exists(Expr e |
    e instanceof ControlFlowTree and
    e = any(AstNode x).getDesugared() and
    cls = e.getAPrimaryQlClass() and
    not e instanceof PostOrderTree and
    not e instanceof LeafTree
  )
}
