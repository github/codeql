// Removes all nodes nested inside a qualified type access,
// and changes qualified type access nodes to "named type" nodes.
//
/*
 * jsdoc_type_exprs (unique int id: @jsdoc_type_expr,
 *                  int kind: int ref,
 *                  int parent: @jsdoc_type_expr_parent ref,
 *                  int idx: int ref,
 *                  varchar(900) tostring: string ref);
 */

class JSDocTypeExprParent extends @jsdoc_type_expr_parent {
  string toString() { none() }
}

class JSDocTypeExpr extends @jsdoc_type_expr {
  string toString() { none() }

  JSDocTypeExpr getChild(int n) { jsdoc_type_exprs(result, _, this, n, _) }

  int getNewKind() { jsdoc_type_exprs(this, result, _, _, _) }

  predicate shouldRemove() { this = any(JSDocQualifiedTypeAccess a).getChild(_) }
}

class JSDocQualifiedTypeAccess extends @jsdoc_qualified_type_expr, JSDocTypeExpr {
  override int getNewKind() {
    result = 5
    /* 5 = @jsdoc_named_type_expr */
  }
}

from JSDocTypeExpr node, JSDocTypeExprParent parent, int idx, string tostring
where
  jsdoc_type_exprs(node, _, parent, idx, tostring) and
  not node.shouldRemove()
select node, node.getNewKind(), parent, idx, tostring
