/**
 * @name Iterator does not return self from `__iter__` method
 * @description Iterator does not return self from `__iter__` method, violating the iterator protocol.
 * @kind problem
 * @tags reliability
 *       correctness
 *       quality
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/iter-returns-non-self
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

/** Holds if `f` is a method of the class `c`. */
private predicate methodOfClass(Function f, Class c) {
  exists(FunctionDef d | d.getDefinedFunction() = f and d.getScope() = c)
}

Function iterMethod(Class c) { methodOfClass(result, c) and result.getName() = "__iter__" }

Function nextMethod(Class c) { methodOfClass(result, c) and result.getName() = "__next__" }

predicate isSelfVar(Function f, Name var) { var.getVariable() = f.getArg(0).(Name).getVariable() }

predicate isGoodReturn(Function f, Expr e) {
  isSelfVar(f, e)
  or
  exists(DataFlow::CallCfgNode call, DataFlow::AttrRead read, DataFlow::Node selfNode |
    e = call.asExpr()
  |
    call = API::builtin("iter").getACall() and
    call.getArg(0) = read and
    read.accesses(selfNode, "__next__") and
    isSelfVar(f, selfNode.asExpr()) and
    call.getArg(1).asExpr() instanceof None
  )
}

predicate returnsNonSelf(Function f) {
  exists(f.getFallthroughNode())
  or
  exists(Return r | r.getScope() = f and not isGoodReturn(f, r.getValue()))
  or
  exists(Return r | r.getScope() = f and not exists(r.getValue()))
}

from Class c, Function iter
where
  exists(nextMethod(c)) and
  iter = iterMethod(c) and
  returnsNonSelf(iter)
select iter, "Iter method of iterator $@ does not return `" + iter.getArg(0).getName() + "`.", c,
  c.getName()
