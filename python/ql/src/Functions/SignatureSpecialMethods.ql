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
import semmle.python.dataflow.new.internal.DataFlowDispatch as DD

predicate is_unary_op(string name) {
  name in [
      "__del__", "__repr__", "__neg__", "__pos__", "__abs__", "__invert__", "__complex__",
      "__int__", "__float__", "__long__", "__oct__", "__hex__", "__str__", "__index__", "__enter__",
      "__hash__", "__bool__", "__nonzero__", "__unicode__", "__len__", "__iter__", "__reversed__",
      "__aenter__", "__aiter__", "__anext__", "__await__", "__ceil__", "__floor__", "__trunc__",
      "__length_hint__", "__dir__", "__bytes__"
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
      "__ifloordiv__", "__idiv__", "__itruediv__", "__ge__", "__imod__", "__ipow__", "__ilshift__",
      "__irshift__", "__iand__", "__ixor__", "__ior__", "__coerce__", "__cmp__", "__rcmp__",
      "__getattr__", "__getattribute__", "__buffer__", "__release_buffer__", "__matmul__",
      "__rmatmul__", "__imatmul__", "__missing__", "__class_getitem__", "__mro_entries__",
      "__format__"
    ]
}

predicate is_ternary_op(string name) {
  name in ["__setattr__", "__set__", "__setitem__", "__getslice__", "__delslice__", "__set_name__"]
}

predicate is_quad_op(string name) { name in ["__setslice__", "__exit__", "__aexit__"] }

int argument_count(string name) {
  is_unary_op(name) and result = 1
  or
  is_binary_op(name) and result = 2
  or
  is_ternary_op(name) and result = 3
  or
  is_quad_op(name) and result = 4
}

/**
 * Returns 1 if `func` is a static method, and 0 otherwise. This predicate is used to adjust the
 * number of expected arguments for a special method accordingly.
 */
int staticmethod_correction(Function func) {
  if DD::isStaticmethod(func) then result = 1 else result = 0
}

predicate incorrect_special_method_defn(
  Function func, string message, boolean show_counts, string name, boolean is_unused_default
) {
  exists(int required, int correction |
    required = argument_count(name) - correction and correction = staticmethod_correction(func)
  |
    /* actual_non_default <= actual */
    if required > func.getMaxPositionalArguments()
    then message = "Too few parameters" and show_counts = true and is_unused_default = false
    else
      if required < func.getMinPositionalArguments()
      then message = "Too many parameters" and show_counts = true and is_unused_default = false
      else (
        func.getMinPositionalArguments() < required and
        not func.hasVarArg() and
        message =
          (required - func.getMinPositionalArguments()) + " default values(s) will never be used" and
        show_counts = false and
        is_unused_default = true
      )
  )
}

predicate incorrect_pow(
  Function func, string message, boolean show_counts, boolean is_unused_default
) {
  exists(int correction | correction = staticmethod_correction(func) |
    func.getMaxPositionalArguments() < 2 - correction and
    message = "Too few parameters" and
    show_counts = true and
    is_unused_default = false
    or
    func.getMinPositionalArguments() > 3 - correction and
    message = "Too many parameters" and
    show_counts = true and
    is_unused_default = false
    or
    func.getMinPositionalArguments() < 2 - correction and
    message = (2 - func.getMinPositionalArguments()) + " default value(s) will never be used" and
    show_counts = false and
    is_unused_default = true
    or
    func.getMinPositionalArguments() = 3 - correction and
    message = "Third parameter to __pow__ should have a default value" and
    show_counts = false and
    is_unused_default = false
  )
}

predicate incorrect_round(
  Function func, string message, boolean show_counts, boolean is_unused_default
) {
  exists(int correction | correction = staticmethod_correction(func) |
    func.getMaxPositionalArguments() < 1 - correction and
    message = "Too few parameters" and
    show_counts = true and
    is_unused_default = false
    or
    func.getMinPositionalArguments() > 2 - correction and
    message = "Too many parameters" and
    show_counts = true and
    is_unused_default = false
    or
    func.getMinPositionalArguments() = 2 - correction and
    message = "Second parameter to __round__ should have a default value" and
    show_counts = false and
    is_unused_default = false
  )
}

predicate incorrect_get(
  Function func, string message, boolean show_counts, boolean is_unused_default
) {
  exists(int correction | correction = staticmethod_correction(func) |
    func.getMaxPositionalArguments() < 3 - correction and
    message = "Too few parameters" and
    show_counts = true and
    is_unused_default = false
    or
    func.getMinPositionalArguments() > 3 - correction and
    message = "Too many parameters" and
    show_counts = true and
    is_unused_default = false
    or
    func.getMinPositionalArguments() < 2 - correction and
    not func.hasVarArg() and
    message = (2 - func.getMinPositionalArguments()) + " default value(s) will never be used" and
    show_counts = false and
    is_unused_default = true
  )
}

string should_have_parameters(string name) {
  if name in ["__pow__", "__get__"]
  then result = "2 or 3"
  else result = argument_count(name).toString()
}

string has_parameters(Function f) {
  exists(int i | i = f.getMinPositionalArguments() |
    i = 0 and result = "no parameters"
    or
    i = 1 and result = "1 parameter"
    or
    i > 1 and result = i.toString() + " parameters"
  )
}

/** Holds if `f` is likely to be a placeholder, and hence not interesting enough to report. */
predicate isLikelyPlaceholderFunction(Function f) {
  // Body has only a single statement.
  f.getBody().getItem(0) = f.getBody().getLastItem() and
  (
    // Body is a string literal. This is a common pattern for Zope interfaces.
    f.getBody().getLastItem().(ExprStmt).getValue() instanceof StringLiteral
    or
    // Body just raises an exception.
    f.getBody().getLastItem() instanceof Raise
    or
    // Body is a pass statement.
    f.getBody().getLastItem() instanceof Pass
  )
}

from
  PythonFunctionValue f, string message, string sizes, boolean show_counts, string name,
  ClassValue owner, boolean show_unused_defaults
where
  owner.getScope().getAMethod() = f.getScope() and
  f.getScope().getName() = name and
  (
    incorrect_special_method_defn(f.getScope(), message, show_counts, name, show_unused_defaults)
    or
    incorrect_pow(f.getScope(), message, show_counts, show_unused_defaults) and name = "__pow__"
    or
    incorrect_get(f.getScope(), message, show_counts, show_unused_defaults) and name = "__get__"
    or
    incorrect_round(f.getScope(), message, show_counts, show_unused_defaults) and
    name = "__round__"
  ) and
  not isLikelyPlaceholderFunction(f.getScope()) and
  show_unused_defaults = false and
  (
    show_counts = false and sizes = ""
    or
    show_counts = true and
    sizes =
      ", which has " + has_parameters(f.getScope()) + ", but should have " +
        should_have_parameters(name)
  )
select f, message + " for special method " + name + sizes + ", in class $@.", owner, owner.getName()
