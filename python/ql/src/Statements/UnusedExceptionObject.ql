/**
 * @name Unused exception object
 * @description An exception object is created, but is not used.
 * @kind problem
 * @tags quality
 *       reliability
 *       error-handling
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/unused-exception-object
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.dataflow.new.internal.Builtins
private import semmle.python.ApiGraphs

/**
 * Holds if `cls` is a user-defined exception class, i.e. it transitively
 * extends one of the builtin exception base classes.
 */
predicate isUserDefinedExceptionClass(Class cls) {
  cls.getABase() =
    API::builtin(["BaseException", "Exception"]).getAValueReachableFromSource().asExpr()
  or
  isUserDefinedExceptionClass(getADirectSuperclass(cls))
}

/**
 * Gets the name of a builtin exception class.
 */
string getBuiltinExceptionName() {
  result = Builtins::getBuiltinName() and
  (
    result.matches("%Error") or
    result.matches("%Exception") or
    result.matches("%Warning") or
    result =
      ["GeneratorExit", "KeyboardInterrupt", "StopIteration", "StopAsyncIteration", "SystemExit"]
  )
}

/**
 * Holds if `call` is an instantiation of an exception class.
 */
predicate isExceptionInstantiation(Call call) {
  exists(Class cls |
    classTracker(cls).asExpr() = call.getFunc() and
    isUserDefinedExceptionClass(cls)
  )
  or
  call.getFunc() = API::builtin(getBuiltinExceptionName()).getAValueReachableFromSource().asExpr()
}

from Call call
where
  isExceptionInstantiation(call) and
  exists(ExprStmt s | s.getValue() = call)
select call, "Instantiating an exception, but not raising it, has no effect."
