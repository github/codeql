import cpp

from SizeofOperator sto, string elemDesc, Element e
where
  elemDesc = "SizeofTypeOperator.getTypeOperand()" and
  e = sto.(SizeofOperator).getTypeOperand()
  or
  elemDesc = "SizeofExprOperator.getExprOperand()" and
  e = sto.(SizeofExprOperator).getExprOperand()
select sto, sto.getValue(), elemDesc, e
