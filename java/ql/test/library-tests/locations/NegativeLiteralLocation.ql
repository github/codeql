import default

from MinusExpr me, Literal l
where l = me.getOperand()
select me, l
