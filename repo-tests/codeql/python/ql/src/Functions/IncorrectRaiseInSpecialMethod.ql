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
  name = "__add__" or
  name = "__sub__" or
  name = "__div__" or
  name = "__pos__" or
  name = "__abs__" or
  name = "__floordiv__" or
  name = "__div__" or
  name = "__divmod__" or
  name = "__lshift__" or
  name = "__and__" or
  name = "__or__" or
  name = "__xor__" or
  name = "__rshift__" or
  name = "__pow__" or
  name = "__mul__" or
  name = "__neg__" or
  name = "__radd__" or
  name = "__rsub__" or
  name = "__rdiv__" or
  name = "__rfloordiv__" or
  name = "__rdiv__" or
  name = "__rlshift__" or
  name = "__rand__" or
  name = "__ror__" or
  name = "__rxor__" or
  name = "__rrshift__" or
  name = "__rpow__" or
  name = "__rmul__" or
  name = "__truediv__" or
  name = "__rtruediv__" or
  name = "__iadd__" or
  name = "__isub__" or
  name = "__idiv__" or
  name = "__ifloordiv__" or
  name = "__idiv__" or
  name = "__ilshift__" or
  name = "__iand__" or
  name = "__ior__" or
  name = "__ixor__" or
  name = "__irshift__" or
  name = "__ipow__" or
  name = "__imul__" or
  name = "__itruediv__"
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
