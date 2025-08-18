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

predicate overrides(Function base, Function sub) {
  base.getName() = sub.getName() and
  base.getScope() = getADirectSuperclass+(sub.getScope())
}

bindingset[num, str]
string plural(int num, string str) {
  num = 1 and result = "1 " + str
  or
  num != 1 and result = num.toString() + " " + str + "s"
}

string describeMin(Function func) {
  exists(string descr | descr = plural(func.getMinPositionalArguments(), "positional argument") |
    if func.getMinPositionalArguments() = func.getMaxPositionalArguments()
    then result = descr
    else result = "at least " + descr
  )
}

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

string describeMinShort(Function func) {
  exists(string descr | descr = func.getMinPositionalArguments().toString() |
    if func.getMinPositionalArguments() = func.getMaxPositionalArguments()
    then result = descr
    else result = "at least " + descr
  )
}

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

Function resolveCall(Call call) {
  exists(DataFlowCall dfc | call = dfc.getNode().(CallNode).getNode() |
    result = viableCallable(dfc).(DataFlowFunction).getScope()
  )
}

predicate callViableForEitherOverride(Function base, Function sub, Call call) {
  overrides(base, sub) and
  base = resolveCall(call) and
  sub = resolveCall(call)
}

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

predicate callMatchesSignature(Function func, Call call) {
  (
    // TODO: This is not fully precise.
    // For example, it does not detect that a method `def foo(self,x,y)` is matched by a call `obj.foo(1,y=2)`
    // since y is passed in the call as a keyword argument, but still counts toward a positional argument of the method.
    call.getPositionalArgumentCount() + extraSelfArg(func) >= func.getMinPositionalArguments()
    or
    exists(call.getStarArg())
    or
    exists(call.getKwargs())
  ) and
  call.getPositionalArgumentCount() + extraSelfArg(func) <= func.getMaxPositionalArguments() and
  (
    exists(func.getKwarg())
    or
    forall(string name | name = call.getANamedArgumentName() | exists(func.getArgByName(name)))
  )
}

Call getASignatureMismatchWitness(Function base, Function sub) {
  callViableForEitherOverride(base, sub, result) and
  callMatchesSignature(base, result) and
  not callMatchesSignature(sub, result)
}

Call chooseASignatureMismatchWitnessInFile(Function base, Function sub, File file) {
  result =
    min(Call c |
      c = getASignatureMismatchWitness(base, sub) and
      c.getLocation().getFile() = file
    |
      c order by c.getLocation().getStartLine(), c.getLocation().getStartColumn()
    )
}

Call chooseASignatureMismatchWitness(Function base, Function sub) {
  exists(getASignatureMismatchWitness(base, sub)) and
  (
    result = chooseASignatureMismatchWitnessInFile(base, sub, base.getLocation().getFile())
    or
    not exists(Call c |
      c = getASignatureMismatchWitness(base, sub) and
      c.getLocation().getFile() = base.getLocation().getFile()
    ) and
    result = chooseASignatureMismatchWitnessInFile(base, sub, base.getLocation().getFile())
    or
    not exists(Call c |
      c = getASignatureMismatchWitness(base, sub) and
      c.getLocation().getFile() = [base, sub].getLocation().getFile()
    ) and
    result =
      min(Call c |
        c = getASignatureMismatchWitness(base, sub)
      |
        c
        order by
          c.getLocation().getFile().getAbsolutePath(), c.getLocation().getStartLine(),
          c.getLocation().getStartColumn()
      )
  )
}

module CallOption = LocOption2<Location, Call>;

from Function base, Function sub, string msg, string extraMsg, CallOption::Option call
where
  not sub.isSpecialMethod() and
  sub.getName() != "__init__" and
  not ignore(sub) and
  not ignore(base) and
  matchingStatic(base, sub) and
  (
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
    not exists(getASignatureMismatchWitness(base, sub)) and
    call.isNone() and
    strongSignatureMismatch(base, sub, msg) and
    extraMsg = ""
  )
select sub, "This method " + msg + extraMsg, base, base.getQualifiedName(), call, "This call"
