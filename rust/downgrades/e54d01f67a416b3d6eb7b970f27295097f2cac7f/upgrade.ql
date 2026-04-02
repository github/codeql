class Element extends @element {
  string toString() { none() }
}

class ArgList extends Element, @arg_list { }

class Attr extends Element, @attr { }

query predicate call_expr_base_arg_lists(Element c, ArgList l) {
  call_expr_base_arg_lists(c, l)
  or
  method_call_expr_arg_lists(c, l)
}

query predicate call_expr_base_attrs(Element c, int i, Attr a) {
  call_expr_attrs(c, i, a)
  or
  method_call_expr_attrs(c, i, a)
}
