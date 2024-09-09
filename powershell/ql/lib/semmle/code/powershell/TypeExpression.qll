import powershell

class TypeNameExpr extends @type_expression, Expr {
  string getName() { type_expression(this, result, _) }

  string getFullyQualifiedName() { type_expression(this, _, result) }

  override string toString() { result = this.getName() }

  override SourceLocation getLocation() { type_expression_location(this, result) }
}
