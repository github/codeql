predicate constructMethodCallExpr(@call_expr id) { exists(@self_apply_expr e | apply_exprs(id, e)) }
