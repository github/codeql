import powershell

class VariableExpression extends @variable_expression, Expression {
  override string toString() { result = this.getUserPath() }

  override SourceLocation getLocation() { variable_expression_location(this, result) }

  string getUserPath() { variable_expression(this, result, _, _, _, _, _, _, _, _, _, _) }

  string getDriveName() { variable_expression(this, _, result, _, _, _, _, _, _, _, _, _) }

  boolean isConstant() { variable_expression(this, _, _, result, _, _, _, _, _, _, _, _) }

  boolean isGlobal() { variable_expression(this, _, _, _, result, _, _, _, _, _, _, _) }

  boolean isLocal() { variable_expression(this, _, _, _, _, result, _, _, _, _, _, _) }

  boolean isPrivate() { variable_expression(this, _, _, _, _, _, result, _, _, _, _, _) }

  boolean isScript() { variable_expression(this, _, _, _, _, _, _, result, _, _, _, _) }

  boolean isUnqualified() { variable_expression(this, _, _, _, _, _, _, _, result, _, _, _) }

  boolean isUnscoped() { variable_expression(this, _, _, _, _, _, _, _, _, result, _, _) }

  boolean isVariable() { variable_expression(this, _, _, _, _, _, _, _, _, _, result, _) }

  boolean isDriveQualified() { variable_expression(this, _, _, _, _, _, _, _, _, _, _, result) }
}
