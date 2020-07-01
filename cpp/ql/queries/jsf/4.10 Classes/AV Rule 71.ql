/**
 * @name AV Rule 71
 * @description Calls to an externally visible operation of an object, other than its constructors, shall not be allowed until the object has been fully initialized.
 * @kind problem
 * @id cpp/jsf/av-rule-71
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * Implementation of the rule: partial, bug-finding approach based on the cases listed as
 * examples in the JSF spec. Of those,
 *
 *  (1) is checked by 71.1 (no virtual calls in ctors)
 *  (2) is approximated. We cannot know about preconditions of methods, but we make sure
 *  that no public or protected method that reads a member M is called before M is
 *  initialised in the constructor
 *  (3) make sure that constructors initialise all fields
 *
 * Incomplete on (2): take transitive chains only through public member functions. Context-insensitive
 * except inside the constructor itself
 */

/*
 * Part 1: call chains of public/protected member functions and the variables
 * they need
 */

predicate memberDirectlyNeedsVariable(MemberFunction mf, Class c, MemberVariable mv) {
  (mf.isPublic() or mf.isProtected()) and
  c = mf.getDeclaringType() and
  c = mv.getDeclaringType() and
  exists(VariableAccess va |
    va = mv.getAnAccess() and
    not exists(Assignment a | va = a.getLValue()) and
    va.getEnclosingFunction() = mf
  )
}

predicate memberNeedsVariable(MemberFunction mf, Class c, MemberVariable mv) {
  memberDirectlyNeedsVariable(mf, c, mv)
  or
  exists(MemberFunction mf2 |
    memberNeedsVariable(mf2, c, mv) and
    mf.getDeclaringType() = c and
    (mf.isPublic() or mf.isProtected()) and
    mf.calls(mf2)
  )
}

/*
 * Part 2: call chains of members of the class and the variables they
 * initialise (include private members)
 */

predicate memberDirectlyInitialisesVariable(MemberFunction mf, Class c, MemberVariable mv) {
  c = mf.getDeclaringType() and
  c = mv.getDeclaringType() and
  mv.getAnAssignedValue().getEnclosingFunction() = mf
}

predicate memberInitialisesVariable(MemberFunction mf, Class c, MemberVariable mv) {
  memberDirectlyInitialisesVariable(mf, c, mv)
  or
  exists(MemberFunction mf2 |
    memberDirectlyInitialisesVariable(_, c, mv) and // (optimizer hint)
    memberInitialisesVariable(mf2, c, mv) and
    mf.getDeclaringType() = c and
    mf.calls(mf2)
  )
}

/*
 * Part 3: which variable a constructor initialises through assignment, calls
 * or initialisers
 */

predicate preInitialises(Constructor c, MemberVariable mv) {
  exists(ConstructorFieldInit cfi | cfi = c.getAnInitializer() | cfi.getTarget() = mv)
}

predicate exprInitialises(Constructor c, ControlFlowNode cf, MemberVariable mv) {
  cf.getControlFlowScope() = c and
  (
    cf.(Assignment).getLValue() = mv.getAnAccess() or
    memberInitialisesVariable(cf.(FunctionCall).getTarget(), c.getDeclaringType(), mv)
  )
}

predicate initialises(Constructor c, MemberVariable mv) {
  exprInitialises(c, _, mv) or
  preInitialises(c, mv)
}

predicate doesNotInitialise(Constructor c, MemberVariable mv) {
  mv.getDeclaringType() = c.getDeclaringType() and
  not initialises(c, mv)
}

/*
 * Part 4: flow-sensitive analysis of the constructor (only) to check the
 * order: only make public/protected calls that require the value of a variable
 * after it has been initialised.
 */

predicate reachableWithoutInitialising(Constructor c, ControlFlowNode cf, MemberVariable mv) {
  not preInitialises(c, mv) and
  (
    cf = c.getBlock()
    or
    exists(ControlFlowNode mid |
      reachableWithoutInitialising(c, mid, mv) and
      cf = mid.getASuccessor() and
      not exprInitialises(c, cf, mv)
    )
  )
}

predicate badCall(Constructor c, FunctionCall call, MemberVariable mv) {
  reachableWithoutInitialising(c, call, mv) and
  memberNeedsVariable(call.getTarget(), c.getDeclaringType(), mv)
}

/*
 * Query
 */

from Element e, MemberVariable mv, string message
where
  doesNotInitialise(e, mv) and
  message = "Constructor does not initialize member variable " + mv.getName() + "."
  or
  badCall(_, e, mv) and
  message = "Constructor calls function using " + mv.getName() + " before it is initialized."
select e, "AV Rule 71: " + message
