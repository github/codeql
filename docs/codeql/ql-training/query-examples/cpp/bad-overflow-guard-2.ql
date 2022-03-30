import cpp

from AddExpr a, Variable v, RelationalOperation cmp
where
  a.getAnOperand() = v.getAnAccess() and
  cmp.getAnOperand() = a and
  cmp.getAnOperand() = v.getAnAccess() and
  forall(Expr op | op = a.getAnOperand() | isSmall(op))
select cmp, "Bad overflow check."