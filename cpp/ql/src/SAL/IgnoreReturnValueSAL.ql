/**
 * @name SAL requires inspecting return value
 * @description When a return value is discarded even though the SAL annotation
 *              requires inspecting it, a recoverable error may turn into a
 *              whole-program crash.
 * @kind problem
 * @problem.severity warning
 * @tags reliability
 *       external/cwe/cwe-573
 *       external/cwe/cwe-252
 * @opaque-id SM02344
 * @microsoft.severity Important
 * @id cpp/ignorereturnvaluesal
 */

import microsoft.SAL

from Function f, FunctionCall call
where
  call.getTarget() = f and
  call instanceof ExprInVoidContext and
  any(SALCheckReturn a).getDeclaration() = f and
  not any(Options o).okToIgnoreReturnValue(call)
select call, "Return value of $@ discarded although a SAL annotation " + "requires inspecting it.",
  f, f.getName()
