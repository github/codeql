import default

from MinusExpr me, Literal l
where l = me.getExpr()
select me, l
