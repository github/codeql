/** Definitions for reasoning about the expected first argument names for methods. */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch
import DataFlow

/** Holds if `f` is a method of the class `c`. */
private predicate methodOfClass(Function f, Class c) {
  exists(FunctionDef d | d.getDefinedFunction() = f and d.getScope() = c)
}

/** Holds if `c` is a metaclass. */
private predicate isMetaclass(Class c) {
  c = API::builtin("type").getASubclass*().asSource().asExpr().(ClassExpr).getInnerScope()
}

/** Holds if `c` is a Zope interface. */
private predicate isZopeInterface(Class c) {
  c =
    API::moduleImport("zope")
        .getMember("interface")
        .getMember("Interface")
        .getASubclass*()
        .asSource()
        .asExpr()
        .(ClassExpr)
        .getInnerScope()
}

/**
 * Holds if `f` is used in the initialisation of `c`.
 * This means `f` isn't being used as a normal method.
 * Ideally it should be a `@staticmethod`; however this wasn't possible prior to Python 3.10.
 * We exclude this case from the `not-named-self` query.
 * However there is potential for a new query that specifically covers and alerts for this case.
 */
private predicate usedInInit(Function f, Class c) {
  methodOfClass(f, c) and
  exists(Call call |
    call.getScope() = c and
    DataFlow::localFlow(DataFlow::exprNode(f.getDefinition()), DataFlow::exprNode(call.getFunc()))
  )
}

/**
 * Holds if `f` has no arguments, and also has a decorator.
 * We assume that the decorator affect the method in such a way that a `self` parameter is unneeded.
 */
private predicate noArgsWithDecorator(Function f) {
  not exists(f.getAnArg()) and
  exists(f.getADecorator())
}

/** Holds if the first parameter of `f` should be named `self`. */
predicate shouldBeSelf(Function f, Class c) {
  methodOfClass(f, c) and
  not isStaticmethod(f) and
  not isClassmethod(f) and
  not isMetaclass(c) and
  not isZopeInterface(c) and
  not usedInInit(f, c) and
  not noArgsWithDecorator(f)
}

/** Holds if the first parameter of `f` should be named `cls`. */
predicate shouldBeCls(Function f, Class c) {
  methodOfClass(f, c) and
  not isStaticmethod(f) and
  (
    isClassmethod(f) and not isMetaclass(c)
    or
    isMetaclass(c) and not isClassmethod(f)
  )
}

/** Holds if the first parameter of `f` is named `self`. */
predicate firstArgNamedSelf(Function f) { f.getArgName(0) = "self" }

/** Holds if the first parameter of `f` refers to the class - it is either named `cls`, or it is named `self` and is a method of a metaclass. */
predicate firstArgRefersToCls(Function f, Class c) {
  methodOfClass(f, c) and
  exists(string argname | argname = f.getArgName(0) |
    argname = "cls"
    or
    /* Not PEP8, but relatively common */
    argname = "mcls"
    or
    /* If c is a metaclass, allow arguments named `self`. */
    argname = "self" and
    isMetaclass(c)
  )
}

/** Holds if the first parameter of `f` should be named `self`, but isn't. */
predicate firstArgShouldBeNamedSelfAndIsnt(Function f) {
  shouldBeSelf(f, _) and
  not firstArgNamedSelf(f)
}

/** Holds if the first parameter of `f` should be named `cls`, but isn't. */
predicate firstArgShouldReferToClsAndDoesnt(Function f) {
  exists(Class c |
    methodOfClass(f, c) and
    shouldBeCls(f, c) and
    not firstArgRefersToCls(f, c)
  )
}
