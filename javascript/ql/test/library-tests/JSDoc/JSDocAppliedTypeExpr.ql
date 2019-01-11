import semmle.javascript.JSDoc

from JSDocAppliedTypeExpr jsdate, int idx
select jsdate, jsdate.getHead(), idx, jsdate.getArgument(idx)
