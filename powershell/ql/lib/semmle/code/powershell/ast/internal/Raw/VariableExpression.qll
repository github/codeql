private import Raw

class VarAccess extends @variable_expression, Expr {
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

  predicate isReadAccess() { not this.isWriteAccess() }

  predicate isWriteAccess() { any(AssignStmt assign).getLeftHandSide() = this }
}

class ThisAccess extends VarAccess {
  ThisAccess() { this.getUserPath() = "this" }
}

predicate isEnvVariableAccess(VarAccess va, string env) {
  va.getUserPath().toLowerCase() = "env:" + env
}

predicate isAutomaticVariableAccess(VarAccess va, string var) {
  va.getUserPath().toLowerCase() =
    [
      "args", "consolefilename", "enabledexperimentalfeatures", "error", "event", "eventargs",
      "eventsubscriber", "executioncontext", "home", "host", "input", "iscoreclr", "islinux",
      "ismacos", "iswindows", "lastexitcode", "myinvocation", "nestedpromptlevel", "pid", "profile",
      "psboundparameters", "pscmdlet", "pscommandpath", "psculture", "psdebugcontext", "psedition",
      "pshome", "psitem", "psscriptroot", "pssenderinfo", "psuiculture", "psversiontable", "pwd",
      "sender", "shellid", "stacktrace"
    ] and
  var = va.getUserPath().toLowerCase()
}
