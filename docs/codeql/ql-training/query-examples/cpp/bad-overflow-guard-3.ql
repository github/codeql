import cpp

predicate isSmall(Expr e) { e.getType().getSize() < 4 }

from AddExpr a, Variable v, RelationalOperation cmp
where
  a.getAnOperand() = v.getAnAccess() and
  cmp.getAnOperand() = a and
  cmp.getAnOperand() = v.getAnAccess() and
  forall(Expr op | op = a.getAnOperand() | isSmall(op)) and
  not isSmall(a.getExplicitlyConverted())
select cmp, "Bad overflow check"