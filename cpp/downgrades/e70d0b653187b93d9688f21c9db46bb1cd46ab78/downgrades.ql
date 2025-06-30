class Accessible extends @accessible {
  string toString() { none() }
}

class Container extends @container {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

class Initialiser extends @initialiser {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

class Stmt extends @stmt {
  string toString() { none() }
}

predicate isLocationDefault(Location l) {
  diagnostics(_, _, _, _, _, l)
  or
  macroinvocations(_, _, l, _)
  or
  fun_decls(_, _, _, _, l)
  or
  var_decls(_, _, _, _, l)
  or
  type_decls(_, _, l)
  or
  namespace_decls(_, _, l, _)
  or
  namespace_decls(_, _, _, l)
  or
  usings(_, _, l, _)
  or
  static_asserts(_, _, _, l, _)
  or
  enumconstants(_, _, _, _, _, l)
  or
  concept_templates(_, _, l)
  or
  attributes(_, _, _, _, l)
  or
  attribute_args(_, _, _, _, l)
  or
  derivations(_, _, _, _, l)
  or
  frienddecls(_, _, _, l)
  or
  comments(_, _, l)
  or
  namequalifiers(_, _, _, l)
  or
  lambda_capture(_, _, _, _, _, _, l)
  or
  preprocdirects(_, _, l)
  or
  xmllocations(_, l)
  or
  locations_default(l, _, 0, 0, 0, 0) // For containers.
}

predicate isLocationExpr(Location l) {
  initialisers(_, _, _, l)
  or
  exprs(_, _, l)
}

predicate isLocationStmt(Location l) { stmts(_, _, l) }

newtype TExprOrStmtLocation =
  TExprLocation(Location l, Container c, int startLine, int startColumn, int endLine, int endColumn) {
    isLocationExpr(l) and
    (isLocationDefault(l) or isLocationStmt(l)) and
    locations_default(l, c, startLine, startColumn, endLine, endColumn)
  } or
  TStmtLocation(Location l, Container c, int startLine, int startColumn, int endLine, int endColumn) {
    isLocationStmt(l) and
    (isLocationDefault(l) or isLocationExpr(l)) and
    locations_default(l, c, startLine, startColumn, endLine, endColumn)
  }

module Fresh = QlBuiltins::NewEntity<TExprOrStmtLocation>;

class NewLocationBase = @location_default or Fresh::EntityId;

class NewLocation extends NewLocationBase {
  string toString() { none() }
}

query predicate new_locations_default(
  NewLocation l, Container c, int startLine, int startColumn, int endLine, int endColumn
) {
  isLocationDefault(l) and
  locations_default(l, c, startLine, startColumn, endLine, endColumn)
}

query predicate new_locations_expr(
  NewLocation l, Container c, int startLine, int startColumn, int endLine, int endColumn
) {
  exists(Location l_old |
    isLocationExpr(l_old) and
    locations_default(l_old, c, startLine, startColumn, endLine, endColumn)
  |
    if not isLocationDefault(l_old) and not isLocationStmt(l)
    then l = l_old
    else l = Fresh::map(TExprLocation(l_old, c, startLine, startColumn, endLine, endColumn))
  )
}

query predicate new_locations_stmt(
  NewLocation l, Container c, int startLine, int startColumn, int endLine, int endColumn
) {
  exists(Location l_old |
    isLocationStmt(l_old) and
    locations_default(l_old, c, startLine, startColumn, endLine, endColumn)
  |
    if not isLocationDefault(l_old) and not isLocationExpr(l)
    then l = l_old
    else l = Fresh::map(TStmtLocation(l_old, c, startLine, startColumn, endLine, endColumn))
  )
}

query predicate new_exprs(Expr e, int kind, NewLocation l) {
  exists(Location l_old, Container c, int startLine, int startColumn, int endLine, int endColumn |
    exprs(e, kind, l_old) and
    locations_default(l_old, c, startLine, startColumn, endLine, endColumn)
  |
    if not isLocationDefault(l_old) and not isLocationStmt(l)
    then l = l_old
    else l = Fresh::map(TExprLocation(l_old, c, startLine, startColumn, endLine, endColumn))
  )
}

query predicate new_initialisers(Initialiser i, Accessible v, Expr e, NewLocation l) {
  exists(Location l_old, Container c, int startLine, int startColumn, int endLine, int endColumn |
    initialisers(i, v, e, l_old) and
    locations_default(l_old, c, startLine, startColumn, endLine, endColumn)
  |
    if not isLocationDefault(l_old) and not isLocationStmt(l)
    then l = l_old
    else l = Fresh::map(TExprLocation(l_old, c, startLine, startColumn, endLine, endColumn))
  )
}

query predicate new_stmts(Stmt s, int kind, NewLocation l) {
  exists(Location l_old, Container c, int startLine, int startColumn, int endLine, int endColumn |
    stmts(s, kind, l_old) and
    locations_default(l_old, c, startLine, startColumn, endLine, endColumn)
  |
    if not isLocationDefault(l_old) and not isLocationExpr(l)
    then l = l_old
    else l = Fresh::map(TStmtLocation(l_old, c, startLine, startColumn, endLine, endColumn))
  )
}
