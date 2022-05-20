import default

from LocalVariableDeclExpr lvde, Type type, string name, string init, LocalVariableDecl var
where
  type = lvde.getType() and
  name = lvde.getName() and
  (if exists(lvde.getInit()) then init = lvde.getInit().toString() else init = "(none)") and
  var = lvde.getVariable()
select lvde, type.toString(), name, init, var
