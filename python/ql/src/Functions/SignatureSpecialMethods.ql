/**
 * @name Special method has incorrect signature
 * @description Special method has incorrect signature
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/special-method-wrong-signature
 */

import python

predicate is_unary_op(string name) {
  name in [
      "__del__", "__repr__", "__neg__", "__pos__", "__abs__", "__invert__", "__complex__",
      "__int__", "__float__", "__long__", "__oct__", "__hex__", "__str__", "__index__", "__enter__",
      "__hash__", "__bool__", "__nonzero__", "__unicode__", "__len__", "__iter__", "__reversed__"
    ]
}

predicate is_binary_op(string name) {
  name in [
      "__lt__", "__le__", "__delattr__", "__delete__", "__instancecheck__", "__subclasscheck__",
      "__getitem__", "__delitem__", "__contains__", "__add__", "__sub__", "__mul__", "__eq__",
      "__floordiv__", "__div__", "__truediv__", "__mod__", "__divmod__", "__lshift__", "__rshift__",
      "__and__", "__xor__", "__or__", "__ne__", "__radd__", "__rsub__", "__rmul__", "__rfloordiv__",
      "__rdiv__", "__rtruediv__", "__rmod__", "__rdivmod__", "__rpow__", "__rlshift__", "__gt__",
      "__rrshift__", "__rand__", "__rxor__", "__ror__", "__iadd__", "__isub__", "__imul__",
      "__ifloordiv__", "__idiv__", "__itruediv__", "__ge__", "__imod__", "__idivmod__", "__ipow__",
      "__ilshift__", "__irshift__", "__iand__", "__ixor__", "__ior__", "__coerce__", "__cmp__",
      "__rcmp__", "__getattr___", "__getattribute___"
    ]
}

predicate is_ternary_op(string name) {
  name in ["__setattr__", "__set__", "__setitem__", "__getslice__", "__delslice__"]
}

predicate is_quad_op(string name) { name = "__setslice__" or name = "__exit__" }

int argument_count(PythonFunctionValue f, string name, ClassValue cls) {
  cls.declaredAttribute(name) = f and
  (
    is_unary_op(name) and result = 1
    or
    is_binary_op(name) and result = 2
    or
    is_ternary_op(name) and result = 3
    or
    is_quad_op(name) and result = 4
  )
}

predicate incorrect_special_method_defn(
  PythonFunctionValue func, string message, boolean show_counts, string name, ClassValue owner
) {
  exists(int required | required = argument_count(func, name, owner) |
    /* actual_non_default <= actual */
    if required > func.maxParameters()
    then message = "Too few parameters" and show_counts = true
    else
      if required < func.minParameters()
      then message = "Too many parameters" and show_counts = true
      else (
        func.minParameters() < required and
        not func.getScope().hasVarArg() and
        message = (required - func.minParameters()) + " default values(s) will never be used" and
        show_counts = false
      )
  )
}

predicate incorrect_pow(FunctionValue func, string message, boolean show_counts, ClassValue owner) {
  owner.declaredAttribute("__pow__") = func and
  (
    func.maxParameters() < 2 and message = "Too few parameters" and show_counts = true
    or
    func.minParameters() > 3 and message = "Too many parameters" and show_counts = true
    or
    func.minParameters() < 2 and
    message = (2 - func.minParameters()) + " default value(s) will never be used" and
    show_counts = false
    or
    func.minParameters() = 3 and
    message = "Third parameter to __pow__ should have a default value" and
    show_counts = false
  )
}

predicate incorrect_get(FunctionValue func, string message, boolean show_counts, ClassValue owner) {
  owner.declaredAttribute("__get__") = func and
  (
    func.maxParameters() < 3 and message = "Too few parameters" and show_counts = true
    or
    func.minParameters() > 3 and message = "Too many parameters" and show_counts = true
    or
    func.minParameters() < 2 and
    not func.getScope().hasVarArg() and
    message = (2 - func.minParameters()) + " default value(s) will never be used" and
    show_counts = false
  )
}

string should_have_parameters(PythonFunctionValue f, string name, ClassValue owner) {
  exists(int i | i = argument_count(f, name, owner) | result = i.toString())
  or
  owner.declaredAttribute(name) = f and
  (name = "__get__" or name = "__pow__") and
  result = "2 or 3"
}

string has_parameters(PythonFunctionValue f) {
  exists(int i | i = f.minParameters() |
    i = 0 and result = "no parameters"
    or
    i = 1 and result = "1 parameter"
    or
    i > 1 and result = i.toString() + " parameters"
  )
}

from
  PythonFunctionValue f, string message, string sizes, boolean show_counts, string name,
  ClassValue owner
where
  (
    incorrect_special_method_defn(f, message, show_counts, name, owner)
    or
    incorrect_pow(f, message, show_counts, owner) and name = "__pow__"
    or
    incorrect_get(f, message, show_counts, owner) and name = "__get__"
  ) and
  (
    show_counts = false and sizes = ""
    or
    show_counts = true and
    sizes =
      ", which has " + has_parameters(f) + ", but should have " +
        should_have_parameters(f, name, owner)
  )
select f, message + " for special method " + name + sizes + ", in class $@.", owner, owner.getName()
