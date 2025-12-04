class Element extends @element {
  string toString() { none() }
}

class CallExpr extends Element, @call_expr { }

class ArgList extends Element, @arg_list { }

class Attr extends Element, @attr { }

class MethodCallExpr extends Element, @method_call_expr { }

query predicate call_expr_arg_lists(CallExpr c, ArgList l) { call_expr_base_arg_lists(c, l) }

query predicate call_expr_attrs(CallExpr c, int i, Attr a) { call_expr_base_attrs(c, i, a) }

query predicate method_call_expr_arg_lists(MethodCallExpr c, ArgList l) {
  call_expr_base_arg_lists(c, l)
}

query predicate method_call_expr_attrs(MethodCallExpr c, int i, Attr a) {
  call_expr_base_attrs(c, i, a)
}
