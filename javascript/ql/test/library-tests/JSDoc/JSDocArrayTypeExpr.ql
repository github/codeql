import semmle.javascript.JSDoc

from JSDocArrayTypeExpr jsdate, int idx
select jsdate, idx, jsdate.getElementType(idx)