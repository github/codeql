/**
 * @name Call to `memset` may be deleted
 * @description Calling `memset` or `ZeroMemory` on a buffer in order to clear its contents may get optimized away
 *              by the compiler if said buffer is not subsequently used.  This is not desirable
 *              behavior if the buffer contains sensitive data that could be exploited by an attacker.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/memset-may-be-deleted
 * @tags security
 *       external/cwe/cwe-14
 */

import semmle.code.cpp.dataflow.TaintTracking

private predicate memsetName(string fn) {
  fn = "memset" or
  fn = "bzero" or
  fn = "ZeroMemory" or
  fn = "FillMemory" or
  fn = "__builtin_memset"
}

private Expr getVariable(Expr expr) {
  expr instanceof CStyleCast and result = getVariable(expr.(CStyleCast).getExpr())
  or
  expr instanceof PointerAddExpr and result = getVariable(expr.getChild(0))
  or
  expr instanceof ArrayToPointerConversion and result = getVariable(expr.getChild(0))
  or
  result = expr
}

from FunctionCall fc, Expr arg
where
  memsetName(fc.getTarget().getName()) and
  arg = fc.getArgument(0) and
  not exists(Expr succ |
    TaintTracking::localTaint(DataFlow::definitionByReferenceNodeFromArgument(arg),
      DataFlow::exprNode(succ))
  ) and
  not exists(Parameter parm |
    TaintTracking::localTaint(DataFlow::parameterNode(parm), DataFlow::exprNode(arg))
  )
select fc, "Call to " + fc.getTarget().getName() + " may be deleted by the compiler."
