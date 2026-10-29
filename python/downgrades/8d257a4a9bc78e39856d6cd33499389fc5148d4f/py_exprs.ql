// We must wrap the DB types, as these cannot appear in argument lists
class Expr_ extends @py_expr {
  string toString() { result = "Expr" }
}

class ExprParent_ extends @py_expr_parent {
  string toString() { result = "ExprList" }
}

query predicate py_exprs_without_template_strings(Expr_ id, int kind, ExprParent_ parent, int idx) {
  py_exprs(id, kind, parent, idx) and
  // From the dbscheme:
  //
  // case @py_expr.kind of
  // ...
  // |   39 = @py_SpecialOperation
  // |   40 = @py_TemplateString
  // |   41 = @py_JoinedTemplateString
  // |   42 = @py_TemplateStringPart;
  not kind in [40, 41, 42]
}
