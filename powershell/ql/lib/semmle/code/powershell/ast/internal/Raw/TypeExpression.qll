private import Raw

class TypeNameExpr extends @type_expression, Expr {
  string getName() { type_expression(this, result, _) }

  override SourceLocation getLocation() { type_expression_location(this, result) }

  /** Gets the type referred to by this `TypeNameExpr`. */
  TypeStmt getType() { result.getName() = this.getName() }
}
