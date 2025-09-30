/**
 * @name Non-standard exception raised in special method
 * @description Raising a non-standard exception in a special method alters the expected interface of that method.
 * @kind problem
 * @tags quality
 *       reliability
 *       error-handling
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/unexpected-raise-in-special-method
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch

/** Holds if `name` is the name of a special method for attribute access such as `a.b`, that should raise an `AttributeError`. */
private predicate attributeMethod(string name) {
  name = ["__getattribute__", "__getattr__", "__delattr__"] // __setattr__ excluded as it makes sense to raise different kinds of errors based on the `value` parameter
}

/** Holds if `name` is the name of a special method for indexing operations such as `a[b]`, that should raise a `LookupError`. */
private predicate indexingMethod(string name) {
  name = ["__getitem__", "__delitem__"] // __setitem__ excluded as it makes sense to raise different kinds of errors based on the `value` parameter
}

/** Holds if `name` is the name of a special method for arithmetic operations. */
private predicate arithmeticMethod(string name) {
  name =
    [
      "__add__", "__sub__", "__and__", "__or__", "__xor__", "__lshift__", "__rshift__", "__pow__",
      "__mul__", "__div__", "__divmod__", "__truediv__", "__floordiv__", "__matmul__", "__radd__",
      "__rsub__", "__rand__", "__ror__", "__rxor__", "__rlshift__", "__rrshift__", "__rpow__",
      "__rmul__", "__rdiv__", "__rdivmod__", "__rtruediv__", "__rfloordiv__", "__rmatmul__",
      "__iadd__", "__isub__", "__iand__", "__ior__", "__ixor__", "__ilshift__", "__irshift__",
      "__ipow__", "__imul__", "__idiv__", "__idivmod__", "__itruediv__", "__ifloordiv__",
      "__imatmul__", "__pos__", "__neg__", "__abs__", "__invert__",
    ]
}

/** Holds if `name is the name of a special method for ordering operations such as `a < b`. */
private predicate orderingMethod(string name) {
  name =
    [
      "__lt__",
      "__le__",
      "__gt__",
      "__ge__",
    ]
}

/** Holds if `name` is the name of a special method for casting an object to a numeric type, such as `int(x)` */
private predicate castMethod(string name) {
  name =
    [
      "__int__",
      "__float__",
      "__index__",
      "__trunc__",
      "__complex__"
    ] // __bool__ excluded as it makes sense to allow it to always raise
}

/** Holds if we allow a special method named `name` to raise `exec` as an exception. */
predicate correctRaise(string name, Expr exec) {
  execIsOfType(exec, "TypeError") and
  (
    indexingMethod(name) or
    attributeMethod(name) or
    // Allow add methods to raise a TypeError, as they can be used for sequence concatenation as well as arithmetic
    name = ["__add__", "__iadd__", "__radd__"]
  )
  or
  exists(string execName |
    preferredRaise(name, execName, _) and
    execIsOfType(exec, execName)
  )
}

/** Holds if it is preferred for `name` to raise exceptions of type `execName`. `message` is the alert message. */
predicate preferredRaise(string name, string execName, string message) {
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
  message = "should raise a TypeError or return NotImplemented instead."
  or
  arithmeticMethod(name) and
  execName = "ArithmeticError" and
  message = "should raise an ArithmeticError or return NotImplemented instead."
  or
  name = "__bool__" and
  execName = "TypeError" and
  message = "should raise a TypeError instead."
}

/** Holds if `exec` is an exception object of the type named `execName`. */
predicate execIsOfType(Expr exec, string execName) {
  // Might make sense to have execName be an IPA type here. Or part of a more general API modeling builtin/stdlib subclass relations.
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

/**
 * Holds if `meth` need not be implemented if it always raises. `message` is the alert message, and `allowNotImplemented` is true
 * if we still allow the method to always raise `NotImplementedError`.
 */
predicate noNeedToAlwaysRaise(Function meth, string message, boolean allowNotImplemented) {
  meth.getName() = "__hash__" and
  message = "use __hash__ = None instead." and
  allowNotImplemented = false
  or
  castMethod(meth.getName()) and
  message = "this method does not need to be implemented." and
  allowNotImplemented = true and
  // Allow an always raising cast method if it's overriding other behavior
  not exists(Function overridden |
    overridden.getName() = meth.getName() and
    overridden.getScope() = getADirectSuperclass+(meth.getScope()) and
    not alwaysRaises(overridden, _)
  )
}

/** Holds if `func` has a decorator likely marking it as an abstract method. */
predicate isAbstract(Function func) { func.getADecorator().(Name).getId().matches("%abstract%") }

/** Holds if `f` always raises the exception `exec`. */
predicate alwaysRaises(Function f, Expr exec) {
  directlyRaises(f, exec) and
  strictcount(Expr e | directlyRaises(f, e)) = 1 and
  not exists(f.getANormalExit())
}

/** Holds if `f` directly raises `exec` using a `raise` statement. */
predicate directlyRaises(Function f, Expr exec) {
  exists(Raise r |
    r.getScope() = f and
    exec = r.getException() and
    exec instanceof Call
  )
}

/** Holds if `exec` is a `NotImplementedError`. */
predicate isNotImplementedError(Expr exec) {
  exec = API::builtin("NotImplementedError").getACall().asExpr()
}

/** Gets the name of the builtin exception type `exec` constructs, if it can be determined. */
string getExecName(Expr exec) { result = exec.(Call).getFunc().(Name).getId() }

from Function f, Expr exec, string message
where
  f.isSpecialMethod() and
  not isAbstract(f) and
  directlyRaises(f, exec) and
  (
    exists(boolean allowNotImplemented, string subMessage |
      alwaysRaises(f, exec) and
      noNeedToAlwaysRaise(f, subMessage, allowNotImplemented) and
      (allowNotImplemented = true implies not isNotImplementedError(exec)) and // don't alert if it's a NotImplementedError and that's ok
      message = "This method always raises $@ - " + subMessage
    )
    or
    not isNotImplementedError(exec) and
    not correctRaise(f.getName(), exec) and
    exists(string subMessage | preferredRaise(f.getName(), _, subMessage) |
      if alwaysRaises(f, exec)
      then message = "This method always raises $@ - " + subMessage
      else message = "This method raises $@ - " + subMessage
    )
  )
select f, message, exec, getExecName(exec)
