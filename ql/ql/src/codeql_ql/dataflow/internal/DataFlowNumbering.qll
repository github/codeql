private import codeql_ql.ast.Ast
private import codeql_ql.ast.internal.AstNodeNumbering
private import NodesInternal

/** An arbitrary total ordering of data-flow nodes. */
private predicate internalOrderingKey(TNode node, int tag, int field1, int field2) {
  exists(AstNode ast |
    node = MkAstNodeNode(ast) and
    tag = 0 and
    field1 = getPreOrderId(ast) and
    field2 = 0
  )
  or
  exists(VarDef var, Formula scope |
    node = MkScopedVariable(var, scope) and
    tag = 1 and
    field1 = getPreOrderId(var) and
    field2 = getPreOrderId(scope)
  )
  or
  exists(Predicate pred |
    node = MkThisNode(pred) and
    tag = 2 and
    field1 = getPreOrderId(pred) and
    field2 = 0
  )
  or
  exists(Predicate pred |
    node = MkResultNode(pred) and
    tag = 3 and
    field1 = getPreOrderId(pred) and
    field2 = 0
  )
  or
  exists(Predicate pred, FieldDecl fieldDecl |
    node = MkFieldNode(pred, fieldDecl) and
    tag = 4 and
    field1 = getPreOrderId(pred) and
    field2 = getPreOrderId(fieldDecl)
  )
}

/** Gets an integer unique to `node`. */
int getInternalId(TNode node) {
  node =
    rank[result](TNode n, int tag, int field1, int field2 |
      internalOrderingKey(n, tag, field1, field2)
    |
      n order by tag, field1, field2
    )
}
