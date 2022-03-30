/**
 * @name Confusing method names because of overriding
 * @description A method that would override another method but does not, because the name is
 *              capitalized differently, is confusing and may be a mistake.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/confusing-override-name
 * @tags maintainability
 *       readability
 *       naming
 */

import java

/**
 * For each class, get all methods from this class or its
 * superclasses, with their names in lowercase.
 */
predicate methodNames(RefType t, Method m, string lowercase, string name) {
  exists(RefType t2 |
    m.getDeclaringType() = t2 and
    hasDescendant(t2, t)
  ) and
  name = m.getName() and
  lowercase = name.toLowerCase() and
  lowercase.length() > 1
}

/**
 * For each class, find the pairs of methods that
 * are candidates for being confusing in this class.
 */
predicate confusing(Method m1, Method m2) {
  exists(RefType t, string lower, string name1, string name2 |
    methodNames(t, m1, lower, name1) and
    methodNames(t, m2, lower, name2) and
    name1 != name2
  )
}

/*
 * Two methods are considered confusing if all of the following conditions hold:
 *
 * - They are both static methods or both instance methods.
 * - They are not declared in the same class, and the superclass method is
 *   not overridden in an intermediate class.
 * - They have different names.
 * - They have the same names if case is ignored.
 * - There is no method in the subclass that has the same name as
 *   the superclass method.
 *
 * There is an additional check that only methods with names longer than one character
 * can be considered confusing.
 */

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
    mid.getDeclaringType().getAStrictAncestor() = m2.getDeclaringType()
  ) and
  not exists(Method notConfusing |
    notConfusing.getDeclaringType() = m1.getDeclaringType() and
    notConfusing.getName() = m2.getName()
  )
select m1,
  "It is confusing to have methods " + m1.getName() + " in " + m1.getDeclaringType().getName() +
    " and " + m2.getName() + " in " + m2.getDeclaringType().getName() + "."
