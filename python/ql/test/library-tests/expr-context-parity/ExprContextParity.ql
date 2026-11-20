import python

private predicate inferredContext(Expr e, int kind) {
  kind = 2 and e.isDeleteContext()
  or
  kind = 3 and e.isLoadContext()
  or
  kind = 4 and e.isParameterContext()
  or
  kind = 5 and e.isStoreContext()
}

from Expr e, int kind, string problem
where
  py_expr_contexts(_, kind, e) and
  not inferredContext(e, kind) and
  problem = "Extracted-only context"
  or
  inferredContext(e, kind) and
  not py_expr_contexts(_, kind, e) and
  problem = "Inferred-only context"
select e, problem, kind
