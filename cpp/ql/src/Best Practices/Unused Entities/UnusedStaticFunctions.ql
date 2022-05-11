/**
 * @name Unused static function
 * @description A static function that is never called or accessed may be an
 *              indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/unused-static-function
 * @tags efficiency
 *       useless-code
 *       external/cwe/cwe-561
 */

import cpp

predicate immediatelyReachableFunction(Function f) {
  not f.isStatic() or
  exists(BlockExpr be | be.getFunction() = f) or
  f instanceof MemberFunction or
  f instanceof TemplateFunction or
  f.getFile() instanceof HeaderFile or
  f.getAnAttribute().hasName("constructor") or
  f.getAnAttribute().hasName("destructor") or
  f.getAnAttribute().hasName("used") or
  f.getAnAttribute().hasName("unused")
}

predicate immediatelyReachableVariable(Variable v) {
  v.isTopLevel() and not v.isStatic()
  or
  exists(v.getDeclaringType())
  or
  v.getFile() instanceof HeaderFile
  or
  v.getAnAttribute().hasName("used")
  or
  v.getAnAttribute().hasName("unused")
}

class ImmediatelyReachableThing extends Thing {
  ImmediatelyReachableThing() {
    immediatelyReachableFunction(this) or
    immediatelyReachableVariable(this)
  }
}

predicate reachableThing(Thing t) {
  t instanceof ImmediatelyReachableThing
  or
  exists(Thing mid | reachableThing(mid) and mid.callsOrAccesses() = t)
}

pragma[nomagic]
predicate callsOrAccessesPlus(Thing thing1, FunctionToRemove thing2) {
  thing1.callsOrAccesses() = thing2
  or
  exists(Thing mid |
    thing1.callsOrAccesses() = mid and
    callsOrAccessesPlus(mid, thing2)
  )
}

class Thing extends Locatable {
  Thing() {
    this instanceof Function or
    this instanceof Variable
  }

  string getName() {
    result = this.(Function).getName() or
    result = this.(Variable).getName()
  }

  Thing callsOrAccesses() {
    this.(Function).calls(result)
    or
    this.(Function).accesses(result.(Function))
    or
    this.(Function).accesses(result.(Variable))
    or
    exists(Access a | this.(Variable).getInitializer().getExpr().getAChild*() = a |
      result = a.getTarget()
    )
  }
}

class FunctionToRemove extends Function {
  FunctionToRemove() {
    this.hasDefinition() and
    not reachableThing(this)
  }

  Thing getOther() {
    callsOrAccessesPlus(result, this) and
    this != result and
    // We will already be reporting the enclosing function of a
    // local variable, so don't also report the variable
    not result instanceof LocalVariable
  }
}

from FunctionToRemove f, string clarification, Thing other
where
  if exists(f.getOther())
  then (
    clarification = " ($@ must be removed at the same time)" and
    other = f.getOther()
  ) else (
    clarification = "" and other = f
  )
select f, "Static function " + f.getName() + " is unreachable" + clarification, other,
  other.getName()
