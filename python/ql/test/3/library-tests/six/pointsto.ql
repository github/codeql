import python
private import LegacyPointsTo

string longname(Expr e) {
  result = e.(Name).getId()
  or
  exists(Attribute a | a = e | result = longname(a.getObject()) + "." + a.getName())
}

from ExprWithPointsTo e, Value v
where e.pointsTo(v) and e.getLocation().getFile().getShortName() = "test.py"
select longname(e), v.toString()
