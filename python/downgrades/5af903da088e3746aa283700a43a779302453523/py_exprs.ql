// We must wrap the DB types, as these cannot appear in argument lists
class TypeParameter_ extends @py_type_parameter {
  string toString() { result = "TypeParameter" }
}

class Expr_ extends @py_expr {
  string toString() { result = "Expr" }
}

class ExprParent_ extends @py_expr_parent {
  string toString() { result = "ExprParent" }
}

class TypeVar_ extends @py_TypeVar, TypeParameter_ {
  override string toString() { result = "TypeVar" }
}

class TypeVarTuple_ extends @py_TypeVarTuple, TypeParameter_ {
  override string toString() { result = "TypeVarTuple" }
}

class ParamSpec_ extends @py_ParamSpec, TypeParameter_ {
  override string toString() { result = "ParamSpec" }
}

// From the dbscheme:
// py_exprs(unique int id : @py_expr,
//    int kind: int ref,
//    int parent : @py_expr_parent ref,
//    int idx : int ref);
query predicate py_exprs_without_type_parameter_defaults(
  Expr_ id, int kind, ExprParent_ parent, int idx
) {
  py_exprs(id, kind, parent, idx) and
  // From the dbscheme
  // /* <Field> ParamSpec.default = 2, expr */
  // /* <Field> TypeVar.default = 3, expr */
  // /* <Field> TypeVarTuple.default = 2, expr */
  (parent instanceof ParamSpec_ implies idx != 2) and
  (parent instanceof TypeVar_ implies idx != 3) and
  (parent instanceof TypeVarTuple_ implies idx != 2)
}
