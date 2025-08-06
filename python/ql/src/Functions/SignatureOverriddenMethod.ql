/**
 * @name Signature mismatch in overriding method
 * @description Overriding a method without ensuring that both methods accept the same
 *              number and type of parameters has the potential to cause an error when there is a mismatch.
 * @kind problem
 * @problem.severity warning
 * @tags quality
 *       reliability
 *       correctness
 * @sub-severity high
 * @precision very-high
 * @id py/inheritance/signature-mismatch
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate overrides(Function base, Function sub) {
  base.getName() = sub.getName() and
  base.getScope() = getADirectSuperclass*(sub.getScope())
}

/** Holds if no way to call `base` would be valid for `sub`. The `msg` applies to the `sub method. */
predicate strongSignatureMismatch(Function base, Function sub, string msg) {
  overrides(base, sub) and
  (
    sub.getMinPositionalArguments() > base.getMaxPositionalArguments() and
    msg = "requires more positional arguments than overridden $@ allows."
    or
    sub.getMaxPositionalArguments() < base.getMinPositionalArguments() and
    msg = "requires fewer positional arguments than overridden $@ allows."
  )
}

/** Holds if there may be some ways to call `base` that would not be valid for `sub`. The `msg` applies to the `sub` method. */
predicate weakSignatureMismatch(Function base, Function sub, string msg) {
  overrides(base, sub) and
  (
    sub.getMinPositionalArguments() > base.getMinPositionalArguments() and
    msg = "requires more positional arguments than overridden $@ may accept."
    or
    sub.getMaxPositionalArguments() < base.getMaxPositionalArguments() and
    msg = "requires fewer positional arguments than overridden $@ may accept."
    or
    exists(string arg |
      // TODO: positional-only args not considered
      // e.g. `def foo(x, y, /, z):` has x,y as positional only args, should not be considered as possible kw args
      arg = base.getAnArg().getName() and
      not arg = sub.getAnArg().getName() and
      not exists(sub.getKwarg()) and
      msg = "does not accept keyword argument " + arg + ", which overridden $@ does."
    )
    or
    exists(base.getKwarg()) and
    not exists(sub.getKwarg()) and
    msg = "does not accept arbitrary keyword arguments, which overridden $@ does."
  )
}

predicate ignore(Function f) {
  isClassmethod(f)
  or
  exists(Function g |
    g.getScope() = f.getScope() and
    g.getName() = f.getName() and
    g != f
  )
}

from Function base, Function sub, string msg
where
  // not exists(base.getACall()) and
  // not exists(FunctionValue a_derived |
  //   a_derived.overrides(base) and
  //   exists(a_derived.getACall())
  // ) and
  not sub.isSpecialMethod() and
  sub.getName() != "__init__" and
  not ignore(sub) and
  not ignore(base) and
  strongSignatureMismatch(base, sub, msg)
select sub, "This method " + msg, base, base.getQualifiedName()
