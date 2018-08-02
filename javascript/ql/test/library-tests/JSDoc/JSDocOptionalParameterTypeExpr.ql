import semmle.javascript.JSDoc

from JSDocOptionalParameterTypeExpr jsdopte
select jsdopte, jsdopte.getUnderlyingType()
