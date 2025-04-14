import cpp

from DatasizeofOperator sto, string elemDesc, Element e
where
  elemDesc = "DatasizeofTypeOperator.getTypeOperand()" and
  e = sto.(DatasizeofTypeOperator).getTypeOperand()
  or
  elemDesc = "DatasizeofExprOperator.getExprOperand()" and
  e = sto.(DatasizeofExprOperator).getExprOperand()
select sto, sto.getValue(), elemDesc, e
