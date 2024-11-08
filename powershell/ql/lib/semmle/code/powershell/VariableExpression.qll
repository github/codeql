import powershell
private import internal.ExplicitWrite::Private

private predicate isParameterName(@variable_expression ve) { parameter(_, ve, _, _) }

class VarAccess extends @variable_expression, Expr {
  VarAccess() { not isParameterName(this) }

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

  Variable getVariable() { result.getAnAccess() = this }
}

private predicate isImplicitVariableWriteAccess(Expr e) { none() }

class VarReadAccess extends VarAccess {
  VarReadAccess() { not this instanceof VarWriteAccess }
}

class VarWriteAccess extends VarAccess {
  VarWriteAccess() { isExplicitWrite(this, _) or isImplicitVariableWriteAccess(this) }

  predicate isExplicit(AssignStmt assign) { isExplicitWrite(this, assign) }

  predicate isImplicit() { isImplicitVariableWriteAccess(this) }
}

/** An access to an environment variable such as `$Env:PATH` */
class EnvVarAccess extends VarAccess {
  EnvVarAccess() { super.getVariable() instanceof EnvVariable }

  override EnvVariable getVariable() { result = super.getVariable() }

  string getEnvironmentVariable() { result = this.getVariable().getEnvironmentVariable() }
}
