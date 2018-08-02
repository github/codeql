import semmle.javascript.JSDoc

from JSDocRestParameterTypeExpr jsdopte
select jsdopte, jsdopte.getUnderlyingType()
