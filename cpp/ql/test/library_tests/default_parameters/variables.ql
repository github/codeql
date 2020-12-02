import cpp

string istr(Initializer i) {
  if exists(i.toString()) then result = i.toString() else result = "<no str>"
}

string iloc(Initializer i) {
  if exists(i.getLocation().toString())
  then result = i.getLocation().toString()
  else result = "<no location>"
}

string init(Variable v) {
  if v.hasInitializer()
  then
    exists(Initializer i |
      i = v.getInitializer() and
      result = iloc(i) + " " + istr(i)
    )
  else result = "<no init>"
}

string estr(Expr e) { if exists(e.toString()) then result = e.toString() else result = "<no str>" }

string eloc(Expr e) {
  if exists(e.getLocation().toString())
  then result = e.getLocation().toString()
  else result = "<no location>"
}

string assigned(Variable v) {
  if exists(v.getAnAssignedValue())
  then
    exists(Expr e |
      e = v.getAnAssignedValue() and
      result = eloc(e) + " " + estr(e)
    )
  else result = "<no assigned>"
}

from Variable v
select v, count(init(v)), init(v), count(assigned(v)), assigned(v)
