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
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.DataFlowDispatch
import codeql.util.Option

/** Holds if `base` is overridden by `sub` */
predicate overrides(Function base, Function sub) {
  base.getName() = sub.getName() and
  base.getScope() = getADirectSuperclass+(sub.getScope())
}

/** Constructs a string to pluralize `str` depending on `num`. */
bindingset[num, str]
string plural(int num, string str) {
  num = 1 and result = "1 " + str
  or
  num != 1 and result = num.toString() + " " + str + "s"
}

/** Describes the minimum number of arguments `func` can accept, using "at least" if it may accept more. */
string describeMin(Function func) {
  exists(string descr | descr = plural(func.getMinPositionalArguments(), "positional argument") |
    if func.getMinPositionalArguments() = func.getMaxPositionalArguments()
    then result = descr
    else result = "at least " + descr
  )
}

/** Described the maximum number of arguments `func` can accept, using "at most" if it may accept fewer, and "arbitrarily many" if it has a vararg. */
string describeMax(Function func) {
  if func.hasVarArg()
  then result = "arbitrarily many positional arguments"
  else
    exists(string descr | descr = plural(func.getMaxPositionalArguments(), "positional argument") |
      if func.getMinPositionalArguments() = func.getMaxPositionalArguments()
      then result = descr
      else result = "at most " + descr
    )
}

/** Describes the minimum number of arguments `func` can accept, without repeating "positional arguments". */
string describeMinShort(Function func) {
  exists(string descr | descr = func.getMinPositionalArguments().toString() |
    if func.getMinPositionalArguments() = func.getMaxPositionalArguments()
    then result = descr
    else result = "at least " + descr
  )
}

/** Describes the maximum number of arguments `func` can accept, without repeating "positional arguments". */
string describeMaxShort(Function func) {
  if func.hasVarArg()
  then result = "arbitrarily many"
  else
    exists(string descr | descr = func.getMaxPositionalArguments().toString() |
      if func.getMinPositionalArguments() = func.getMaxPositionalArguments()
      then result = descr
      else result = "at most " + descr
    )
}

/** Describe an upper bound on the number of arguments `func` may accept, without specifying "at most". */
string describeMaxBound(Function func) {
  if func.hasVarArg()
  then result = "arbitrarily many"
  else result = func.getMaxPositionalArguments().toString()
}

/** Holds if no way to call `base` would be valid for `sub`. The `msg` applies to the `sub method. */
predicate strongSignatureMismatch(Function base, Function sub, string msg) {
  overrides(base, sub) and
  (
    sub.getMinPositionalArguments() > base.getMaxPositionalArguments() and
    msg =
      "requires " + describeMin(sub) + ", whereas overridden $@ requires " + describeMaxShort(base) +
        "."
    or
    sub.getMaxPositionalArguments() < base.getMinPositionalArguments() and
    msg =
      "requires " + describeMax(sub) + ", whereas overridden $@ requires " + describeMinShort(base) +
        "."
  )
}

/** Holds if there may be some ways to call `base` that would not be valid for `sub`. The `msg` applies to the `sub` method. */
predicate weakSignatureMismatch(Function base, Function sub, string msg) {
  overrides(base, sub) and
  (
    sub.getMinPositionalArguments() > base.getMinPositionalArguments() and
    msg =
      "requires " + describeMin(sub) + ", whereas overridden $@ may be called with " +
        base.getMinPositionalArguments().toString() + "."
    or
    sub.getMaxPositionalArguments() < base.getMaxPositionalArguments() and
    msg =
      "requires " + describeMax(sub) + ", whereas overridden $@ may be called with " +
        describeMaxBound(base) + "."
    or
    sub.getMinPositionalArguments() <= base.getMinPositionalArguments() and
    sub.getMaxPositionalArguments() >= base.getMaxPositionalArguments() and
    exists(string arg |
      // TODO: positional-only args not considered
      // e.g. `def foo(x, y, /, z):` has x,y as positional only args, should not be considered as possible kw args
      // However, this likely does not create FPs, as we require a 'witness' call to generate an alert.
      arg = base.getAnArg().getName() and
      not arg = sub.getAnArg().getName() and
      not exists(sub.getKwarg()) and
      msg = "does not accept keyword argument `" + arg + "`, which overridden $@ does."
    )
    or
    exists(base.getKwarg()) and
    not exists(sub.getKwarg()) and
    msg = "does not accept arbitrary keyword arguments, which overridden $@ does."
  )
}

/** Holds if `f` should be ignored for considering signature mismatches. */
predicate ignore(Function f) {
  isClassmethod(f)
  or
  exists(
    Function g // other functions with the same name, e.g. @property getters/setters.
  |
    g.getScope() = f.getScope() and
    g.getName() = f.getName() and
    g != f
  )
}

/** Gets a function that `call` may resolve to. */
Function resolveCall(Call call) {
  exists(DataFlowCall dfc | call = dfc.getNode().(CallNode).getNode() |
    result = viableCallable(dfc).(DataFlowFunction).getScope()
  )
}

/** Holds if `call` may resolve to either `base` or `sub`, and `base` is overridden by `sub`. */
predicate callViableForEitherOverride(Function base, Function sub, Call call) {
  overrides(base, sub) and
  base = resolveCall(call) and
  sub = resolveCall(call)
}

/** Holds if either both `base` and `sub` are static methods, or both are not static methods, and `base` is overridden by `sub`. */
predicate matchingStatic(Function base, Function sub) {
  overrides(base, sub) and
  (
    isStaticmethod(base) and
    isStaticmethod(sub)
    or
    not isStaticmethod(base) and
    not isStaticmethod(sub)
  )
}

int extraSelfArg(Function func) { if isStaticmethod(func) then result = 0 else result = 1 }

/** Holds if the call `call` matches the signature for `func`. */
predicate callMatchesSignature(Function func, Call call) {
  func = resolveCall(call) and
  (
    // Each parameter of the function is accounted for in the call
    forall(Parameter param, int i | param = func.getArg(i) |
      // self arg
      i = 0 and not isStaticmethod(func)
      or
      // positional arg
      i - extraSelfArg(func) < call.getPositionalArgumentCount()
      or
      // has default
      exists(param.getDefault())
      or
      // keyword arg
      call.getANamedArgumentName() = param.getName()
    )
    or
    // arbitrary varargs or kwargs
    exists(call.getStarArg())
    or
    exists(call.getKwargs())
  ) and
  // No excess parameters
  call.getPositionalArgumentCount() + extraSelfArg(func) <= func.getMaxPositionalArguments() and
  (
    exists(func.getKwarg())
    or
    forall(string name | name = call.getANamedArgumentName() | exists(func.getArgByName(name)))
  )
}

pragma[nomagic]
private File getFunctionFile(Function f) { result = f.getLocation().getFile() }

/** Gets a call which matches the signature of `base`, but not of overridden `sub`. */
Call getASignatureMismatchWitness(Function base, Function sub) {
  callViableForEitherOverride(base, sub, result) and
  callMatchesSignature(base, result) and
  not callMatchesSignature(sub, result)
}

pragma[inline]
string preferredFile(File callFile, Function base, Function sub) {
  if callFile = getFunctionFile(base)
  then result = " A"
  else
    if callFile = getFunctionFile(sub)
    then result = " B"
    else result = callFile.getAbsolutePath()
}

/** Choose a 'witnessing' call that matches the signature of `base` but not of overridden `sub`. */
Call chooseASignatureMismatchWitness(Function base, Function sub) {
  exists(getASignatureMismatchWitness(base, sub)) and
  result =
    min(Call c |
      c = getASignatureMismatchWitness(base, sub)
    |
      c
      order by
        preferredFile(c.getLocation().getFile(), base, sub), c.getLocation().getStartLine(),
        c.getLocation().getStartColumn()
    )
}

module CallOption = LocatableOption<Location, Call>;

from Function base, Function sub, string msg, string extraMsg, CallOption::Option call
where
  not sub.isSpecialMethod() and
  sub.getName() != "__init__" and
  not ignore(sub) and
  not ignore(base) and
  matchingStatic(base, sub) and
  (
    // If we have a witness, alert for a 'weak' mismatch, but prefer the message for a 'strong' mismatch if that holds.
    call.asSome() = chooseASignatureMismatchWitness(base, sub) and
    extraMsg =
      " $@ correctly calls the base method, but does not match the signature of the overriding method." and
    (
      strongSignatureMismatch(base, sub, msg)
      or
      not strongSignatureMismatch(base, sub, _) and
      weakSignatureMismatch(base, sub, msg)
    )
    or
    // With no witness, only alert for 'strong' mismatches.
    not exists(getASignatureMismatchWitness(base, sub)) and
    call.isNone() and
    strongSignatureMismatch(base, sub, msg) and
    extraMsg = ""
  )
select sub, "This method " + msg + extraMsg, base, base.getQualifiedName(), call, "This call"
