class Element extends @element {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

class Decl extends @decl {
  string toString() { none() }
}

class DeclOrNone extends @decl_or_none {
  string toString() { none() }
}

class ModuleOrNone extends @module_decl_or_none {
  string toString() { none() }
}

class Type extends @type {
  string toString() { none() }
}

class TypeOrNone extends @type_or_none {
  string toString() { none() }
}

query predicate new_decls(Decl decl, ModuleOrNone moduleOrNone) {
  decls(decl, moduleOrNone) and not using_decls(decl)
}

query predicate new_decl_members(Decl decl, int index, DeclOrNone declOrNone) {
  decl_members(decl, index, declOrNone) and not using_decls(decl)
}

query predicate new_expr_types(Expr id, TypeOrNone typeOrNone) {
  expr_types(id, typeOrNone) and not unsafe_exprs(id)
}

query predicate new_types(Type id, string name, TypeOrNone typeOrNone) {
  types(id, name, typeOrNone) and not inline_array_types(id, _, _)
}

query predicate new_unspecified_elements(Element id, string property, string error) {
  unspecified_elements(id, property, error)
  or
  using_decls(id) and
  property = "" and
  error = "UsingDecl removed during database downgrade. Please update your CodeQL."
  or
  unsafe_exprs(id) and
  property = "" and
  error = "UnsafeExpr removed during database downgrade. Please update your CodeQL."
  or
  inline_array_types(id, _, _) and
  property = "" and
  error = "InlineArrayType removed during database downgrade. Please update your CodeQL."
}
