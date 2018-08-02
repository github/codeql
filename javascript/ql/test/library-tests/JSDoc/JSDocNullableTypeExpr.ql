import semmle.javascript.JSDoc

from JSDocNullableTypeExpr jsdnte, string fixity
where (if jsdnte.isPrefix() then fixity = "prefix" else fixity = "postfix")
select jsdnte, jsdnte.getTypeExpr(), fixity