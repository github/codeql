import cpp

from VectorFillOperation vf, Expr operand
where operand = vf.getOperand()
select vf, vf.getType(), operand, operand.getType()
