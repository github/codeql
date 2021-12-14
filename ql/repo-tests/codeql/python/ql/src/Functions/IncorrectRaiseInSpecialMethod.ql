/**
 * @name Non-standard exception raised in special method
 * @description Raising a non-standard exception in a special method alters the expected interface of that method.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       convention
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/unexpected-raise-in-special-method
 */

import python

private predicate attribute_method(string name) {
  name = "__getattribute__" or name = "__getattr__" or name = "__setattr__"
}

private predicate indexing_method(string name) {
  name = "__getitem__" or name = "__setitem__" or name = "__delitem__"
}

private predicate arithmetic_method(string name) {
  name in [
      "__add__", "__sub__", "__or__", "__xor__", "__rshift__", "__pow__", "__mul__", "__neg__",
      "__radd__", "__rsub__", "__rdiv__", "__rfloordiv__", "__div__", "__rdiv__", "__rlshift__",
      "__rand__", "__ror__", "__rxor__", "__rrshift__", "__rpow__", "__rmul__", "__truediv__",
      "__rtruediv__", "__pos__", "__iadd__", "__isub__", "__idiv__", "__ifloordiv__", "__idiv__",
      "__ilshift__", "__iand__", "__ior__", "__ixor__", "__irshift__", "__abs__", "__ipow__",
      "__imul__", "__itruediv__", "__floordiv__", "__div__", "__divmod__", "__lshift__", "__and__"
    ]
}

private predicate ordering_method(string name) {
  name = "__lt__"
  or
  name = "__le__"
  or
  name = "__gt__"
  or
  name = "__ge__"
  or
  name = "__cmp__" and major_version() = 2
}

private predicate cast_method(string name) {
  name = "__nonzero__" and major_version() = 2
  or
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

predicate correct_raise(string name, ClassObject ex) {
  ex.getAnImproperSuperType() = theTypeErrorType() and
  (
    name = "__copy__" or
    name = "__deepcopy__" or
    name = "__call__" or
    indexing_method(name) or
    attribute_method(name)
  )
  or
  preferred_raise(name, ex)
  or
  preferred_raise(name, ex.getASuperType())
}

predicate preferred_raise(string name, ClassObject ex) {
  attribute_method(name) and ex = theAttributeErrorType()
  or
  indexing_method(name) and ex = Object::builtin("LookupError")
  or
  ordering_method(name) and ex = theTypeErrorType()
  or
  arithmetic_method(name) and ex = Object::builtin("ArithmeticError")
  or
  name = "__bool__" and ex = theTypeErrorType()
}

predicate no_need_to_raise(string name, string message) {
  name = "__hash__" and message = "use __hash__ = None instead"
  or
  cast_method(name) and message = "there is no need to implement the method at all."
}

predicate is_abstract(FunctionObject func) {
  func.getFunction().getADecorator().(Name).getId().matches("%abstract%")
}

predicate always_raises(FunctionObject f, ClassObject ex) {
  ex = f.getARaisedType() and
  strictcount(f.getARaisedType()) = 1 and
  not exists(f.getFunction().getANormalExit()) and
  /* raising StopIteration is equivalent to a return in a generator */
  not ex = theStopIterationType()
}

from FunctionObject f, ClassObject cls, string message
where
  f.getFunction().isSpecialMethod() and
  not is_abstract(f) and
  always_raises(f, cls) and
  (
    no_need_to_raise(f.getName(), message) and not cls.getName() = "NotImplementedError"
    or
    not correct_raise(f.getName(), cls) and
    not cls.getName() = "NotImplementedError" and
    exists(ClassObject preferred | preferred_raise(f.getName(), preferred) |
      message = "raise " + preferred.getName() + " instead"
    )
  )
select f, "Function always raises $@; " + message, cls, cls.toString()
