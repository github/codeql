import cpp

string varInit(Variable v) {
  if exists(v.getInitializer().getExpr())
  then result = v.getInitializer().getExpr().toString()
  else result = "<no initialiser expr>"
}

from Variable v
select v.getFile().toString(), v.getName(), varInit(v)
