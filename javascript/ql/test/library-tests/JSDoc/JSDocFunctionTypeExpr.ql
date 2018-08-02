import semmle.javascript.JSDoc

from JSDocFunctionTypeExpr jsdfte, string ret, string recv, int idx, string isctor
where (if exists(jsdfte.getResultType()) then ret = jsdfte.getResultType().toString() else ret = "(none)") and
      (if exists(jsdfte.getReceiverType()) then recv = jsdfte.getReceiverType().toString() else recv = "(none)") and
      (if jsdfte.isConstructorType() then isctor = "yes" else isctor = "no")
select jsdfte, ret, recv, idx, jsdfte.getParameterType(idx), isctor
