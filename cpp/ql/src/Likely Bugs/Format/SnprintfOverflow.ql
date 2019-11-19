/**
 * @name Potentially overflowing call to snprintf
 * @description Using the return value from snprintf without proper checks can cause overflow.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/overflowing-snprintf
 * @tags reliability
 *       correctness
 *       security
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/**
 * Holds if there is a dataflow path from `source` to `sink`
 * with no bounds checks along the way. `pathMightOverflow` is
 * true if there is an arithmetic operation on the path that
 * might overflow.
 */
predicate flowsToExpr(Expr source, Expr sink, boolean pathMightOverflow) {
  // Might the current expression overflow?
  exists(boolean otherMightOverflow | flowsToExprImpl(source, sink, otherMightOverflow) |
    if convertedExprMightOverflow(sink)
    then pathMightOverflow = true
    else pathMightOverflow = otherMightOverflow
  )
}

/**
 * Implementation of `flowsToExpr`. Does everything except
 * checking whether the current expression might overflow.
 */
predicate flowsToExprImpl(Expr source, Expr sink, boolean pathMightOverflow) {
  source = sink and
  pathMightOverflow = false and
  source.(FunctionCall).getTarget().(Snprintf).returnsFullFormatLength()
  or
  exists(RangeSsaDefinition def, StackVariable v |
    flowsToDef(source, def, v, pathMightOverflow) and
    sink = def.getAUse(v)
  )
  or
  flowsToExpr(source, sink.(UnaryArithmeticOperation).getOperand(), pathMightOverflow)
  or
  flowsToExpr(source, sink.(BinaryArithmeticOperation).getAnOperand(), pathMightOverflow)
  or
  flowsToExpr(source, sink.(Assignment).getRValue(), pathMightOverflow)
  or
  flowsToExpr(source, sink.(AssignOperation).getLValue(), pathMightOverflow)
  or
  exists(FormattingFunctionCall call |
    sink = call and
    flowsToExpr(source, call.getArgument(call.getTarget().getSizeParameterIndex()),
      pathMightOverflow)
  )
}

/**
 * Holds if there is a dataflow path from `source` to the SSA
 * definition `(def,v)`. with no bounds checks along the way.
 * `pathMightOverflow` is true if there is an arithmetic operation
 * on the path that might overflow.
 */
predicate flowsToDef(Expr source, RangeSsaDefinition def, StackVariable v, boolean pathMightOverflow) {
  // Might the current definition overflow?
  exists(boolean otherMightOverflow | flowsToDefImpl(source, def, v, otherMightOverflow) |
    if defMightOverflow(def, v)
    then pathMightOverflow = true
    else pathMightOverflow = otherMightOverflow
  )
}

/**
 * Implementation of `flowsToDef`. Does everything except
 * checking whether the current definition might overflow.
 *
 * Note: RangeSsa is used to exclude paths that include a bounds check.
 * RangeSsa inserts extra definitions after conditions like `if (x < 10)`.
 * Such definitions are ignored here, so the path will terminate when
 * a bounds check is encounter. Of course it isn't super accurate
 * because useless checks such as `if (x >= 0)` will also terminate
 * the path. But it is a good way to reduce the number of false positives.
 */
predicate flowsToDefImpl(
  Expr source, RangeSsaDefinition def, StackVariable v, boolean pathMightOverflow
) {
  // Assignment or initialization: `e = v;`
  exists(Expr e |
    e = def.getDefiningValue(v) and
    flowsToExpr(source, e, pathMightOverflow)
  )
  or
  // `x++`
  exists(CrementOperation crem |
    def = crem and
    crem.getOperand() = v.getAnAccess() and
    flowsToExpr(source, crem.getOperand(), pathMightOverflow)
  )
  or
  // Phi definition.
  flowsToDef(source, def.getAPhiInput(v), v, pathMightOverflow)
}

from FormattingFunctionCall call, Expr sink
where
  flowsToExpr(call, sink, true) and
  sink = call.getArgument(call.getTarget().getSizeParameterIndex())
select call,
  "The $@ of this snprintf call is derived from its return value, which may exceed the size of the buffer and overflow.",
  sink, "size argument"
