/**
 * @name Variable name is too short
 * @description Using meaningful names for variables makes code easier to understand.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/short-variable-name
 * @tags maintainability
 */

import csharp

predicate sourceFile(File f) {
  f.fromSource() and
  not f.getAbsolutePath() = "null" and
  not f.getAbsolutePath().matches("%ActivXTabControl%.cs")
}

from Variable variable, string name
where
  name = variable.getName() and
  variable.fromSource() and
  sourceFile(variable.getFile()) and
  not allowedName(name) and
  not allowedVariable(variable) and
  //
  // Adjustable parameter:
  //
  name.length() < 3
//
select variable, "Variable name '" + name + "' is too short."

//
// Adjustable: acceptable short names
//
predicate allowedName(string name) {
  name = "url" or
  name = "cmd" or
  name = "UK" or
  name = "uri" or
  name = "top" or
  name = "row" or
  name = "pin" or
  name = "log" or
  name = "key" or
  name = "_"
}

//
// Adjustable: variables that are allowed to have short names
//
predicate allowedVariable(Variable variable) {
  exists(Parameter param |
    variable = param and
    not exists(param.getAnAccess()) and
    param.getType().getName().matches("%EventArgs")
  )
  or
  exists(LocalVariable local |
    variable = local and
    local.getVariableDeclExpr().getParent() instanceof CatchClause
  )
  or
  exists(Call c, LambdaExpr le | le.getAParameter() = variable | c.getAnArgument() = le)
}
