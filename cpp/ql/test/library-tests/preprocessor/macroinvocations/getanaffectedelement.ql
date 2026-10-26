import cpp

predicate reason(MacroInvocation mi, Element e, string reason) {
  mi.getAnAffectedElement() = e and reason = "getAnAffectedElement()"
  or
  mi.getAnExpandedElement() = e and reason = "getAnExpandedElement()"
  or
  mi.getAGeneratedElement() = e and reason = "getAGeneratedElement()"
  or
  mi.getExpr() = e and reason = "getExpr()"
  or
  mi.getStmt() = e and reason = "getStmt()"
  or
  mi.getEnclosingFunction() = e and reason = "getEnclosingFunction()"
}

string reasons(MacroInvocation mi, Element e) {
  result = concat(string reason | reason(mi, e, reason) | reason, " " order by reason)
}

from MacroInvocation mi, Element e
where reason(mi, e, _)
select mi, e, reasons(mi, e)
