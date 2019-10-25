import cpp

from Expr e, string valcat
where
  e.isLValueCategory() and valcat = "lvalue"
  or
  e.isXValueCategory() and valcat = "xvalue"
select e, e.getType().toString(), valcat
