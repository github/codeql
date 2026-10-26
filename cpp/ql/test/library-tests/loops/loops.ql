import cpp

class ExprStmt_ extends ExprStmt {
  override string toString() { result = "ExprStmt: " + this.getExpr().toString() }
}

from Loop l, string s, Element e
where
  s = "getCondition()" and
  e = l.getCondition()
  or
  s = "getStmt()" and
  e = l.getStmt()
  or
  s = "(ForStmt).getInitialization()" and
  e = l.(ForStmt).getInitialization()
  or
  s = "(ForStmt).getUpdate()" and
  e = l.(ForStmt).getUpdate()
  or
  s = "(ForStmt).getAnIterationVariable()" and
  e = l.(ForStmt).getAnIterationVariable()
  or
  s = "(RangeBasedForStmt).getVariable()" and
  e = l.(RangeBasedForStmt).getVariable()
  or
  s = "(RangeBasedForStmt).getUpdate()" and
  e = l.(RangeBasedForStmt).getUpdate()
  or
  s = "(RangeBasedForStmt).getEnclosingFunction().getATemplateArgument()" and
  e = l.(RangeBasedForStmt).getEnclosingFunction().getATemplateArgument()
select l, s, e
