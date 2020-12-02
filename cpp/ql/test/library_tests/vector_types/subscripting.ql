import cpp

from ArrayExpr ae
select ae, ae.getType(), ae.getArrayBase().getType(), ae.getArrayOffset().getType()
