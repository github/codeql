/**
 * @name AV Rule 70
 * @description A class will have friends only when a function or object requires access to
 *              the private elements of the class, but is unable to be a member of the class
 *              for logical or efficiency reasons.
 * @kind problem
 * @id cpp/jsf/av-rule-70
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

// whether b is the same as a, or b is "const a&"
predicate isTypeOrConstRef(Type a, Type b) {
  a = b
  or
  exists(ReferenceType r, SpecifiedType s |
    b = r and s = r.getBaseType() and s.hasSpecifier("const") and a = s.getUnspecifiedType()
  )
}

// whether the first parameter of f may be subject to implicit conversions
predicate implicitConvOnFirstParm(Function f) {
  exists(ImplicitConversionFunction conv |
    isTypeOrConstRef(conv.getDestType(), f.getParameter(0).getUnderlyingType())
  )
}

// whether f is declared as a friend by all its parameter types
predicate multiFriend(Function f) {
  f.getNumberOfParameters() > 1 and
  forall(Parameter p | p = f.getAParameter() |
    exists(FriendDecl fd |
      fd.getFriend() = f and
      p.getType().refersTo(fd.getDeclaringClass())
    )
  )
}

from FriendDecl fd
where
  not implicitConvOnFirstParm(fd.getFriend()) and
  not multiFriend(fd.getFriend())
select fd,
  "AV Rule 70: Friend declarations will only be used if the friend is unable to be a member of the class for logical or efficiency reasons."
