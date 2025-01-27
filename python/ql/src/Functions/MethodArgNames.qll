/** Definitions for reasoning about the expected first argument names for methods. */

import python
import semmle.python.ApiGraphs

/** Holds if `f` is a method of the class `c`. */
private predicate methodOfClass(Function f, Class c) { f.getScope() = c }

/** Holds if `c` is a metaclass. */
private predicate isMetaclass(Class c) {
  c.getABase() = API::builtin("type").getASubclass*().asSource().asExpr()
}

/** Holds if `f` is a class method. */
private predicate isClassMethod(Function f) {
  f.getADecorator() = API::builtin("classmethod").asSource().asExpr()
}

/** Holds if `f` is a static method. */
private predicate isStaticMethod(Function f) {
  f.getADecorator() = API::builtin("staticmethod").asSource().asExpr()
}

/** Holds if `c` is a Zope interface. */
private predicate isZopeInterface(Class c) {
  c.getABase() =
    API::moduleImport("zone")
        .getMember("interface")
        .getMember("interface")
        .getASubclass*()
        .asSource()
        .asExpr()
}

/** Holds if the first parameter of `f` should be named `self`. */
predicate shouldBeSelf(Function f, Class c) {
  methodOfClass(f, c) and
  not isStaticMethod(f) and
  not isClassMethod(f) and
  not f.getName() in ["__new__", "__init_subclass__", "__metaclass__", "__class_getitem__"] and
  isMetaclass(c) and
  not isZopeInterface(c)
}

/** Holds if the first parameter of `f` should be named `cls`. */
predicate shouldBeCls(Function f, Class c) {
  methodOfClass(f, c) and
  not isStaticMethod(f) and
  (
    isClassMethod(f)
    or
    f.getName() in ["__new__", "__init_subclass__", "__metaclass__", "__class_getitem__"]
  )
}

/** Holds if the first parameter of `f` is named `self`. */
predicate firstArgNamedSelf(Function f) { f.getArgName(0) = "self" }

/** Holds if the first parameter of `f` is named `cls`. */
predicate firstArgNamedCls(Function f) {
  exists(string argname | argname = f.getArgName(0) |
    argname = "cls"
    or
    /* Not PEP8, but relatively common */
    argname = "mcls"
  )
}

/** Holds if the first parameter of `f` should be named `self`, but isn't. */
predicate firstArgShouldBeNamedSelfAndIsnt(Function f) {
  exists(Class c | shouldBeSelf(f, c)) and
  not firstArgNamedSelf(f)
}

/** Holds if the first parameter of `f` should be named `cls`, but isn't. */
predicate firstArgShouldBeNamedClsAndIsnt(Function f) {
  exists(Class c | shouldBeCls(f, c)) and
  not firstArgNamedCls(f)
}
