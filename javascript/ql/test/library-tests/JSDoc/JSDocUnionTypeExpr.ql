import semmle.javascript.JSDoc

from JSDocUnionTypeExpr jsdute
select jsdute, jsdute.getAnAlternative()
