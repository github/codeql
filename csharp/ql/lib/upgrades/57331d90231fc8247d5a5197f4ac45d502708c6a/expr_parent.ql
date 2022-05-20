class Expr extends @expr {
  string toString() { none() }
}

class ControlFlowElement extends @control_flow_element {
  string toString() { none() }
}

private predicate discardTypeCaseStmt(@case cs, @type_access_expr ta) {
  expr_parent(ta, 1, cs) and
  expr_parent(any(@discard_expr de), 0, cs)
}

private predicate expr_parent_adjusted(Expr child, int i, ControlFlowElement parent) {
  if parent instanceof @is_expr
  then
    i = 0 and
    expr_parent(child, i, parent)
    or
    // e.g. `x is string s` or `x is null`
    i = 1 and
    expr_parent(child, any(int j | j in [2 .. 3]), parent)
    or
    // e.g. `x is string`
    i = 1 and
    not expr_parent(_, any(int j | j in [2 .. 3]), parent) and
    expr_parent(child, i, parent)
  else
    if parent instanceof @case
    then
      // e.g. `case string s:` or `case 5:`
      i = 0 and
      expr_parent(child, i, parent) and
      not discardTypeCaseStmt(parent, _)
      or
      // e.g. `case string _`
      i = 0 and
      discardTypeCaseStmt(parent, child)
      or
      i = 1 and
      expr_parent(child, 2, parent)
    else expr_parent(child, i, parent)
}

from Expr child, int i, ControlFlowElement parent
where expr_parent_adjusted(child, i, parent)
select child, i, parent
