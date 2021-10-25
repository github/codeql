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

string reasonspart(MacroInvocation mi, Element e) {
  reason(mi, e, result)
  or
  exists(string a, string b |
    a = reasonspart(mi, e) and
    reason(mi, e, b) and
    not a.splitAt(" ") >= b and
    result = a + " " + b
  )
}

string reasons(MacroInvocation mi, Element e) {
  result = reasonspart(mi, e) and
  not reasonspart(mi, e).length() > result.length()
}

from MacroInvocation mi, Element e
where reason(mi, e, _)
select mi, e, reasons(mi, e)
