import cpp

from AlignofOperator sto, string elemDesc, Element e
where
  elemDesc = "AlignofTypeOperator.getTypeOperand()" and
  e = sto.(AlignofTypeOperator).getTypeOperand()
  or
  elemDesc = "AlignofExprOperator.getExprOperand()" and
  e = sto.(AlignofExprOperator).getExprOperand()
select sto, elemDesc, e
