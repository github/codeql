import cpp

from SizeofOperator sto, string elemDesc, Element e
where
  elemDesc = "SizeofOperator.getTypeOperand()" and
  e = sto.getTypeOperand()
  or
  elemDesc = "SizeofExprOperator.getExprOperand()" and
  e = sto.(SizeofExprOperator).getExprOperand()
select sto, sto.getValue(), elemDesc, e
