import ruby

from Operation o, string operator, Expr operand, string pClass
where
  operator = o.getOperator() and
  operand = o.getAnOperand() and
  pClass = o.getAPrimaryQlClass()
select o, operator, operand, pClass
