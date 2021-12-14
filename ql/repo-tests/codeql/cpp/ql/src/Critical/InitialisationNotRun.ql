/**
 * @name Initialization code not run
 * @description Not running initialization code may lead to unexpected behavior.
 * @kind problem
 * @id cpp/initialization-not-run
 * @problem.severity warning
 * @security-severity 7.5
 * @tags reliability
 *       security
 *       external/cwe/cwe-456
 */

import cpp
import semmle.code.cpp.pointsto.CallGraph

predicate global(GlobalVariable v) {
  not exists(v.getInitializer()) and
  not v.getType() instanceof ArrayType and
  not v.getType() instanceof Class and
  v.getAnAccess().isUsedAsLValue()
}

predicate mainCalled(Function f) {
  f.hasGlobalName("main")
  or
  exists(Function caller | mainCalled(caller) and allCalls(caller, f))
}

predicate called(Function f) {
  mainCalled(f)
  or
  exists(FunctionAccess fa | fa.getTarget() = f)
}

from GlobalVariable v
where
  global(v) and
  not exists(VariableAccess lval |
    v.getAnAccess() = lval and
    lval.isUsedAsLValue() and
    called(lval.getEnclosingFunction())
  )
select v, "Initialization code for '" + v.getName() + "' is never run."
