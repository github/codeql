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
import semmle.python.ApiGraphs

/** Holds if `f` is a method of the class `c`. */
private predicate methodOfClass(Function f, Class c) {
  exists(FunctionDef d | d.getDefinedFunction() = f and d.getScope() = c)
}

/** Gets the __iter__ method of `c`. */
Function iterMethod(Class c) { methodOfClass(result, c) and result.getName() = "__iter__" }

/** Gets the `__next__` method of `c`. */
Function nextMethod(Class c) { methodOfClass(result, c) and result.getName() = "__next__" }

/** Holds if `var` is a variable referring to the `self` parameter of `f`. */
predicate isSelfVar(Function f, Name var) { var.getVariable() = f.getArg(0).(Name).getVariable() }

/** Holds if `e` is an expression that an iter function `f` should return. */
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

/** Holds if the iter method `f` does not return `self` or an equivalent. */
predicate returnsNonSelf(Function f) {
  exists(f.getFallthroughNode())
  or
  exists(Return r | r.getScope() = f and not isGoodReturn(f, r.getValue()))
  or
  exists(Return r | r.getScope() = f and not exists(r.getValue()))
}

/** Holds if `iter` and `next` methods are wrappers around some field. */
predicate iterWrapperMethods(Function iter, Function next) {
  exists(string field |
    exists(Return r, DataFlow::Node self, DataFlow::AttrRead read |
      r.getScope() = iter and
      r.getValue() = iterCall(read).asExpr() and
      read.accesses(self, field) and
      isSelfVar(iter, self.asExpr())
    ) and
    exists(Return r, DataFlow::Node self, DataFlow::AttrRead read |
      r.getScope() = next and
      r.getValue() = nextCall(read).asExpr() and
      read.accesses(self, field) and
      isSelfVar(next, self.asExpr())
    )
  )
}

DataFlow::CallCfgNode iterCall(DataFlow::Node arg) {
  result.(DataFlow::MethodCallNode).calls(arg, "__iter__")
  or
  result = API::builtin("iter").getACall() and
  arg = result.getArg(0) and
  not exists(result.getArg(1))
  or
  result = arg // assume the wrapping field is already an iterator
}

DataFlow::CallCfgNode nextCall(DataFlow::Node arg) {
  result.(DataFlow::MethodCallNode).calls(arg, "__next__")
  or
  result = API::builtin("next").getACall() and
  arg = result.getArg(0)
}

from Class c, Function iter, Function next
where
  next = nextMethod(c) and
  iter = iterMethod(c) and
  returnsNonSelf(iter) and
  not iterWrapperMethods(iter, next)
select iter, "Iter method of iterator $@ does not return `" + iter.getArg(0).getName() + "`.", c,
  c.getName()
