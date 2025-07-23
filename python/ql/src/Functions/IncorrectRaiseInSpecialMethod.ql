/**
 * @name Non-standard exception raised in special method
 * @description Raising a non-standard exception in a special method alters the expected interface of that method.
 * @kind problem
 * @tags quality
 *       reliability
 *       error-handling
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/unexpected-raise-in-special-method
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch

private predicate attributeMethod(string name) {
  name = "__getattribute__" or name = "__getattr__" or name = "__setattr__"
}

private predicate indexingMethod(string name) {
  name = "__getitem__" or name = "__setitem__" or name = "__delitem__"
}

private predicate arithmeticMethod(string name) {
  name in [
      "__add__", "__sub__", "__or__", "__xor__", "__rshift__", "__pow__", "__mul__", "__neg__",
      "__radd__", "__rsub__", "__rdiv__", "__rfloordiv__", "__div__", "__rdiv__", "__rlshift__",
      "__rand__", "__ror__", "__rxor__", "__rrshift__", "__rpow__", "__rmul__", "__truediv__",
      "__rtruediv__", "__pos__", "__iadd__", "__isub__", "__idiv__", "__ifloordiv__", "__idiv__",
      "__ilshift__", "__iand__", "__ior__", "__ixor__", "__irshift__", "__abs__", "__ipow__",
      "__imul__", "__itruediv__", "__floordiv__", "__div__", "__divmod__", "__lshift__", "__and__"
    ]
}

private predicate orderingMethod(string name) {
  name = "__lt__"
  or
  name = "__le__"
  or
  name = "__gt__"
  or
  name = "__ge__"
}

private predicate castMethod(string name) {
  name = "__int__"
  or
  name = "__float__"
  or
  name = "__long__"
  or
  name = "__trunc__"
  or
  name = "__complex__"
}

predicate correctRaise(string name, Expr exec) {
  execIsOfType(exec, "TypeError") and
  (
    indexingMethod(name) or
    attributeMethod(name)
  )
  or
  exists(string execName |
    preferredRaise(name, execName, _) and
    execIsOfType(exec, execName)
  )
}

predicate preferredRaise(string name, string execName, string message) {
  // TODO: execName should be an IPA type
  attributeMethod(name) and
  execName = "AttributeError" and
  message = "should raise an AttributeError instead."
  or
  indexingMethod(name) and
  execName = "LookupError" and
  message = "should raise a LookupError (KeyError or IndexError) instead."
  or
  orderingMethod(name) and
  execName = "TypeError" and
  message = "should raise a TypeError, or return NotImplemented instead."
  or
  arithmeticMethod(name) and
  execName = "ArithmeticError" and
  message = "should raise an ArithmeticError, or return NotImplemented instead."
  or
  name = "__bool__" and
  execName = "TypeError" and
  message = "should raise a TypeError instead."
}

predicate execIsOfType(Expr exec, string execName) {
  exists(string subclass |
    execName = "TypeError" and
    subclass = "TypeError"
    or
    execName = "LookupError" and
    subclass = ["LookupError", "KeyError", "IndexError"]
    or
    execName = "ArithmeticError" and
    subclass = ["ArithmeticError", "FloatingPointError", "OverflowError", "ZeroDivisionError"]
    or
    execName = "AttributeError" and
    subclass = "AttributeError"
  |
    exec = API::builtin(subclass).getACall().asExpr()
    or
    exec = API::builtin(subclass).getASubclass().getACall().asExpr()
  )
}

predicate noNeedToAlwaysRaise(Function meth, string message, boolean allowNotImplemented) {
  meth.getName() = "__hash__" and
  message = "use __hash__ = None instead." and
  allowNotImplemented = false
  or
  castMethod(meth.getName()) and
  message = "this method does not need to be implemented." and
  allowNotImplemented = true and
  not exists(Function overridden |
    overridden.getName() = meth.getName() and
    overridden.getScope() = getADirectSuperclass+(meth.getScope()) and
    alwaysRaises(overridden, _)
  )
}

predicate isAbstract(Function func) { func.getADecorator().(Name).getId().matches("%abstract%") }

predicate alwaysRaises(Function f, Expr exec) {
  directlyRaises(f, exec) and
  strictcount(Expr e | directlyRaises(f, e)) = 1 and
  not exists(f.getANormalExit())
}

predicate directlyRaises(Function f, Expr exec) {
  exists(Raise r |
    r.getScope() = f and
    exec = r.getException() and
    not exec = API::builtin("StopIteration").asSource().asExpr()
  )
}

predicate isNotImplementedError(Expr exec) {
  exec = API::builtin("NotImplementedError").getACall().asExpr()
}

from Function f, Expr exec, string message
where
  f.isSpecialMethod() and
  not isAbstract(f) and
  directlyRaises(f, exec) and
  (
    exists(boolean allowNotImplemented, string subMessage |
      alwaysRaises(f, exec) and
      noNeedToAlwaysRaise(f, subMessage, allowNotImplemented) and
      (allowNotImplemented = false or not isNotImplementedError(exec)) and
      message = "This method always raises $@ - " + subMessage
    )
    or
    alwaysRaises(f, exec) and // for now consider only alwaysRaises cases as original query
    not isNotImplementedError(exec) and
    not correctRaise(f.getName(), exec) and
    exists(string subMessage | preferredRaise(f.getName(), _, subMessage) |
      message = "This method always raises $@ - " + subMessage
    )
  )
select f, message, exec, exec.toString() // TODO: remove tostring
