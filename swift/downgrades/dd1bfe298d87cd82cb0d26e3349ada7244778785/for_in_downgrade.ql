class Element extends @element {
  string toString() { none() }
}

class ForEachStmt extends Element, @for_each_stmt {
  Element getPattern() { for_each_stmts(this, result, _) }

  Element getIteratorVar() { for_each_stmt_iterator_vars(this, result) }

  Element getIteratorVarPattern() {
    pattern_binding_decl_patterns(this.getIteratorVar(), _, result)
  }

  Element getIteratorVarConcreteDecl() { decl_ref_exprs(this.getNextCallVarRef(), result) }

  Element getNextCall() { for_each_stmt_next_calls(this, result) }

  Element getNextCallMethodLookup() { apply_exprs(this.getNextCall(), result) }

  Element getNextCallFuncRef() { apply_exprs(this.getNextCallMethodLookup(), result) }

  Element getNextCallInOutConversion() { self_apply_exprs(this.getNextCallMethodLookup(), result) }

  Element getNextCallVarRef() { in_out_exprs(this.getNextCallInOutConversion(), result) }
}

query predicate new_for_each_stmts(ForEachStmt stmt, Element pattern, Element body, Element sequence) {
  exists(Element iteratorVar |
    for_each_stmts(stmt, pattern, body) and
    for_each_stmt_iterator_vars(stmt, iteratorVar) and
    pattern_binding_decl_inits(iteratorVar, _, sequence)
  )
}

query predicate new_pattern_binding_decls(Element id) {
  pattern_binding_decls(id) and
  not for_each_stmt_iterator_vars(_, id)
}

query predicate new_pattern_binding_decl_patterns(Element id, int index, Element pattern) {
  pattern_binding_decl_patterns(id, index, pattern) and
  not for_each_stmt_iterator_vars(_, id)
}

query predicate new_named_patterns(Element pattern, string name) {
  named_patterns(pattern, name) and
  not exists(Element decl |
    pattern_binding_decl_patterns(decl, _, pattern) and
    for_each_stmt_iterator_vars(_, decl)
  )
}

query predicate new_pattern_binding_decl_inits(Element id, int index, Element init) {
  pattern_binding_decl_inits(id, index, init) and
  not for_each_stmt_iterator_vars(_, id)
}

query predicate new_dot_syntax_call_exprs(Element id) {
  dot_syntax_call_exprs(id) and
  not exists(ForEachStmt stmt | id = stmt.getNextCallMethodLookup())
}

query predicate new_self_apply_exprs(Element id, Element base) {
  self_apply_exprs(id, base) and
  not exists(ForEachStmt stmt | id = stmt.getNextCallMethodLookup())
}

query predicate new_in_out_exprs(Element inOutExpr, Element subExpr) {
  in_out_exprs(inOutExpr, subExpr) and
  not exists(ForEachStmt stmt | inOutExpr = stmt.getNextCallInOutConversion())
}

query predicate new_apply_exprs(Element id, Element func) {
  apply_exprs(id, func) and
  not exists(ForEachStmt stmt | id = stmt.getNextCall() or id = stmt.getNextCallMethodLookup())
}

query predicate new_decl_ref_exprs(Element id, Element decl) {
  decl_ref_exprs(id, decl) and
  not exists(ForEachStmt stmt | stmt.getNextCallVarRef() = id or stmt.getNextCallFuncRef() = id)
}

query predicate new_lookup_exprs(Element id, Element base) {
  lookup_exprs(id, base) and
  not exists(ForEachStmt stmt | stmt.getNextCallMethodLookup() = id)
}

query predicate new_call_exprs(Element id) {
  call_exprs(id) and
  not exists(ForEachStmt stmt | stmt.getNextCall() = id)
}

query predicate new_locatable_locations(Element locatable, Element location) {
  locatable_locations(locatable, location) and
  not exists(ForEachStmt stmt |
    locatable = stmt.getIteratorVarPattern() or
    locatable = stmt.getIteratorVarConcreteDecl() or
    locatable = stmt.getNextCall() or
    locatable = stmt.getNextCallMethodLookup() or
    locatable = stmt.getNextCallInOutConversion() or
    locatable = stmt.getNextCallVarRef()
  )
}

query predicate new_concrete_var_decls(Element decl, int introducer_int) {
  concrete_var_decls(decl, introducer_int) and
  not exists(ForEachStmt stmt | stmt.getIteratorVarConcreteDecl() = decl)
}

query predicate new_var_decls(Element decl, string name, Element type) {
  var_decls(decl, name, type) and
  not exists(ForEachStmt stmt | stmt.getIteratorVarConcreteDecl() = decl)
}

query predicate new_var_decl_parent_patterns(Element decl, Element pattern) {
  var_decl_parent_patterns(decl, pattern) and
  not exists(ForEachStmt stmt | stmt.getIteratorVarConcreteDecl() = decl)
}

query predicate new_var_decl_parent_initializers(Element decl, Element init) {
  var_decl_parent_initializers(decl, init) and
  not exists(ForEachStmt stmt | stmt.getIteratorVarConcreteDecl() = decl)
}

query predicate new_expr_types(Element expr, Element type) {
  expr_types(expr, type) and
  not exists(ForEachStmt stmt |
    expr = stmt.getNextCall() or
    expr = stmt.getNextCallMethodLookup() or
    expr = stmt.getNextCallVarRef() or
    expr = stmt.getNextCallFuncRef() or
    expr = stmt.getNextCallInOutConversion()
  )
}
