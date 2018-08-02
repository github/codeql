import semmle.javascript.JSDoc

from JSDocTypeExpr jsdte
select jsdte, jsdte.getParent(), jsdte.getIndex()