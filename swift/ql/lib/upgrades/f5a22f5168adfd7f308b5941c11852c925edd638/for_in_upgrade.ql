class Element extends @element {
  string toString() { none() }
}

class ForEachStmt extends Element, @for_each_stmt {
  Element getSequence() { for_each_stmts(this, _, result, _) }

  Pattern getPattern() { for_each_stmts(this, result, _, _) }
}

class Pattern extends Element, @pattern {
  string getGeneratorString() { result = "$generator" }
}

class NamedPattern extends Pattern, @named_pattern {
  override string getGeneratorString() {
    exists(string name |
      named_patterns(this, name) and
      result = "$" + name + "$generator"
    )
  }
}

newtype TAddedElement =
  TIteratorVar(ForEachStmt stmt) or
  TIteratorVarPattern(ForEachStmt stmt) or
  TIteratorVarConcreteDecl(ForEachStmt stmt) or
  TNextCall(ForEachStmt stmt) or
  TNextCallMethodLookup(ForEachStmt stmt) or
  TNextCallInOutConversion(ForEachStmt stmt) or
  TNextCallVarRef(ForEachStmt stmt) or
  TNextCallFuncRef(ForEachStmt stmt)

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

query predicate new_for_each_stmts(ForEachStmt id, Pattern pattern, Element body) {
  for_each_stmts(id, pattern, _, body)
}

query predicate for_each_stmt_iterator_vars(ForEachStmt id, NewElement iteratorVar) {
  Fresh::map(TIteratorVar(id)) = iteratorVar
}

query predicate new_pattern_binding_decls(NewElement id) {
  pattern_binding_decls(id)
  or
  Fresh::map(TIteratorVar(_)) = id
}

query predicate new_pattern_binding_decl_patterns(NewElement id, int index, NewElement pattern) {
  pattern_binding_decl_patterns(id, index, pattern)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TIteratorVar(foreach)) = id and
    Fresh::map(TIteratorVarPattern(foreach)) = pattern and
    index = 0
  )
}

query predicate new_named_patterns(NewElement id, string name) {
  named_patterns(id, name)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TIteratorVarPattern(foreach)) = id and
    name = foreach.getPattern().getGeneratorString()
  )
}

query predicate new_pattern_binding_decl_inits(NewElement id, int index, NewElement init) {
  pattern_binding_decl_inits(id, index, init)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TIteratorVar(foreach)) = id and
    foreach.getSequence() = init and
    index = 0
  )
}

query predicate for_each_stmt_next_calls(ForEachStmt id, NewElement nextCall) {
  Fresh::map(TNextCall(id)) = nextCall
}

query predicate new_dot_syntax_call_exprs(NewElement id) {
  dot_syntax_call_exprs(id)
  or
  Fresh::map(TNextCallMethodLookup(_)) = id
}

query predicate new_self_apply_exprs(NewElement id, NewElement base) {
  self_apply_exprs(id, base)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallMethodLookup(foreach)) = id and
    Fresh::map(TNextCallInOutConversion(foreach)) = base
  )
}

query predicate new_in_out_exprs(NewElement inOutExpr, NewElement subExpr) {
  in_out_exprs(inOutExpr, subExpr)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallInOutConversion(foreach)) = inOutExpr and
    Fresh::map(TNextCallVarRef(foreach)) = subExpr
  )
}

query predicate new_apply_exprs(NewElement id, NewElement func) {
  apply_exprs(id, func)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCall(foreach)) = id and
    Fresh::map(TNextCallMethodLookup(foreach)) = func
  )
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallMethodLookup(foreach)) = id and
    Fresh::map(TNextCallFuncRef(foreach)) = func
  )
}

Element getParent(Element type) {
  any_generic_type_parents(type, result)
  or
  // there may be an extension that implements IteratorProtocol
  exists(@extension_decl extDecl, @nominal_type_decl typeDecl, @protocol_decl protocolDecl |
    any_generic_types(type, typeDecl) and
    extension_decls(extDecl, typeDecl) and
    extension_decl_protocols(extDecl, _, protocolDecl) and
    any_generic_types(result, protocolDecl)
  )
}

Element getNextMethod(ForEachStmt foreach) {
  exists(@element sequence, @element exprType, @element parentType, @element typeDecl |
    sequence = foreach.getSequence() and
    expr_types(sequence, exprType) and
    parentType = getParent*(exprType) and
    any_generic_types(parentType, typeDecl) and
    decl_members(typeDecl, _, result) and
    callable_names(result, "next()")
  )
}

query predicate new_decl_ref_exprs(NewElement id, NewElement decl) {
  decl_ref_exprs(id, decl)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallVarRef(foreach)) = id and
    Fresh::map(TIteratorVarConcreteDecl(foreach)) = decl
  )
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallFuncRef(foreach)) = id and
    decl = getNextMethod(foreach)
  )
}

query predicate new_lookup_exprs(NewElement id, NewElement base) {
  lookup_exprs(id, base)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallMethodLookup(foreach)) = id and
    Fresh::map(TNextCallVarRef(foreach)) = base
  )
}

query predicate new_call_exprs(NewElement id) {
  call_exprs(id) or
  Fresh::map(TNextCall(_)) = id
}

query predicate new_locatable_locations(NewElement locatable, NewElement location) {
  locatable_locations(locatable, location)
  or
  exists(ForEachStmt stmt |
    locatable = Fresh::map(TIteratorVarPattern(stmt)) or
    locatable = Fresh::map(TIteratorVarConcreteDecl(stmt)) or
    locatable = Fresh::map(TNextCall(stmt)) or
    locatable = Fresh::map(TNextCallMethodLookup(stmt)) or
    locatable = Fresh::map(TNextCallInOutConversion(stmt)) or
    locatable = Fresh::map(TNextCallVarRef(stmt))
  |
    locatable_locations(stmt, location)
  )
}

query predicate new_concrete_var_decls(NewElement decl, int introducer_int) {
  concrete_var_decls(decl, introducer_int)
  or
  exists(ForEachStmt stmt |
    decl = Fresh::map(TIteratorVarConcreteDecl(stmt)) and
    introducer_int = 1
  )
}

query predicate new_var_decls(NewElement decl, string name, Element type) {
  var_decls(decl, name, type)
  or
  exists(ForEachStmt stmt |
    decl = Fresh::map(TIteratorVarConcreteDecl(stmt)) and
    expr_types(stmt.getSequence(), type) and
    name = stmt.getPattern().getGeneratorString()
  )
}

query predicate new_var_decl_parent_patterns(NewElement decl, NewElement pattern) {
  var_decl_parent_patterns(decl, pattern)
  or
  exists(ForEachStmt stmt |
    decl = Fresh::map(TIteratorVarConcreteDecl(stmt)) and
    pattern = Fresh::map(TIteratorVarPattern(stmt))
  )
}

query predicate new_var_decl_parent_initializers(NewElement decl, NewElement init) {
  var_decl_parent_initializers(decl, init)
  or
  exists(ForEachStmt stmt |
    decl = Fresh::map(TIteratorVarConcreteDecl(stmt)) and
    init = stmt.getSequence()
  )
}

query predicate new_expr_types(NewElement expr, NewElement type) {
  expr_types(expr, type)
  or
  exists(ForEachStmt stmt, Element pattern, Element var_decl |
    expr = Fresh::map(TNextCall(stmt)) and
    for_each_stmts(stmt, pattern, _, _) and
    var_decl_parent_patterns(var_decl, pattern) and
    var_decls(var_decl, _, type)
  )
  or
  exists(ForEachStmt stmt |
    expr = Fresh::map(TNextCallMethodLookup(stmt)) and
    value_decls(getNextMethod(stmt), type)
  )
  or
  exists(ForEachStmt stmt |
    expr = Fresh::map(TNextCallVarRef(stmt)) and
    expr_types(stmt.getSequence(), type)
  )
  or
  exists(ForEachStmt stmt |
    expr = Fresh::map(TNextCallFuncRef(stmt)) and
    value_decls(getNextMethod(stmt), type)
  )
  or
  exists(ForEachStmt stmt, NewElement plainType |
    expr = Fresh::map(TNextCallInOutConversion(stmt)) and
    expr_types(stmt.getSequence(), plainType) and
    in_out_types(type, plainType)
  )
}
