import cpp

string description(Expr e) {
  e = any(ConditionalExpr ce).getCondition() and result = "0:condition"
  or
  e = any(ConditionalExpr ce).getThen() and result = "1:then"
  or
  e = any(ConditionalExpr ce).getElse() and result = "2:else"
}

from Expr e
select strictconcat(description(e), " / "), e, e.getType(), e.getFullyConverted().getType()
