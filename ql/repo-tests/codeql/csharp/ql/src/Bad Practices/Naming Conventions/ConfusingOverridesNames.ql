/**
 * @name Confusing method names because of overriding
 * @description Finds methods m1 and m2, where m1 would override m2, except that
 *              their names differ in capitalization.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/confusing-override-name
 * @tags reliability
 *       readability
 *       naming
 */

import csharp

predicate hasSubtypeStar(RefType t, RefType u) {
  t = u or
  u.getABaseType+() = t
}

/**
 * For each class, get all methods from this class or its
 * superclasses, with their names in lowercase
 */
predicate methodNames(RefType t, Method m, string lowercase) {
  exists(RefType t2 |
    m.getDeclaringType() = t2 and
    hasSubtypeStar(t2, t)
  ) and
  lowercase = m.getName().toLowerCase() and
  lowercase.length() > 1
}

/**
 * For each class, find the pairs of methods that
 * are candidates for being confusing in this class
 */
predicate confusing(Method m1, Method m2) {
  exists(RefType t, string lower |
    methodNames(t, m1, lower) and
    methodNames(t, m2, lower) and
    m1.getName() != m2.getName()
  )
}

// Two method names are confusing if all of the following conditions hold:
//   They are both static methods or both instance methods.
//   They are not declared in the same class, and the superclass method is
//     not overridden in an intermediate class
//   They have different names.
//   They have the same names if case is ignored.
//   There is no method in the subclass that has the same name as
//     the superclass method
// There is an additional check that only methods with names longer than one character
// can be considered confusing.
from Method m1, Method m2
where
  confusing(m1, m2) and
  m1.getDeclaringType() != m2.getDeclaringType() and
  (
    m1.isStatic() and m2.isStatic()
    or
    not m1.isStatic() and not m2.isStatic()
  ) and
  not exists(Method mid |
    confusing(m1, mid) and
    mid.getDeclaringType().getABaseType+() = m2.getDeclaringType()
  ) and
  not exists(Method notConfusing |
    notConfusing.getDeclaringType() = m1.getDeclaringType() and
    notConfusing.getName() = m2.getName()
  ) and
  m1.fromSource()
select m1,
  "confusing to have methods " + m1.getName() + " in " + m1.getDeclaringType().getName() + " and " +
    m2.getName() + " in " + m2.getDeclaringType().getName() + "."
