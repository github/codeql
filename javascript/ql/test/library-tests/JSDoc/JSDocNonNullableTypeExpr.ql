import semmle.javascript.JSDoc

from JSDocNonNullableTypeExpr jsdnte, string fixity
where (if jsdnte.isPrefix() then fixity = "prefix" else fixity = "postfix")
select jsdnte, jsdnte.getTypeExpr(), fixity
