import cpp
import semmle.code.cpp.controlflow.internal.ConstantExprs

predicate loopEntryConst(Expr condition, int val) {
  exists(LoopEntryConditionEvaluator x, ControlFlowNode loop |
    x.isLoopEntry(condition, loop) and
    val = x.getValue(condition)
  )
}
