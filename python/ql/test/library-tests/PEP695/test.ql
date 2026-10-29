import python

string pretty_name(AstNode n) {
  result = "Function " + n.(Function).getName()
  or
  result = "Class " + n.(ClassExpr).getName()
  or
  result = "TypeAlias " + n.(TypeAlias).getName().getId()
}

query predicate type_vars_without_bound(TypeVar tv, string name, string parent) {
  tv.getName().getId() = name and
  not exists(tv.getBound()) and
  parent = pretty_name(tv.getParent().getParent())
}

query predicate type_vars_with_bound(TypeVar tv, string name, string bound, string parent) {
  tv.getName().getId() = name and
  bound = tv.getBound().(Name).getId() and
  parent = pretty_name(tv.getParent().getParent())
}

query predicate type_var_tuples(TypeVarTuple tvt, string name, string parent) {
  tvt.getName().getId() = name and
  parent = pretty_name(tvt.getParent().getParent())
}

query predicate param_specs(ParamSpec ps, string name, string parent) {
  ps.getName().getId() = name and
  parent = pretty_name(ps.getParent().getParent())
}

query predicate type_aliases(TypeAlias ta, string name, string value) {
  ta.getName().getId() = name and
  value = ta.getValue().(Name).getId()
}
