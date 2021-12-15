/**
 * @name Undisciplined multiple inheritance
 * @description Multiple inheritance should only be used in the following restricted form: n interfaces plus m private implementations, plus at most one protected implementation. Multiple inheritance can lead to complicated inheritance hierarchies that are difficult to comprehend and maintain.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/undisciplined-multiple-inheritance
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/**
 * In the context of this rule, an interface is specified by a class which has
 * the following properties:
 * - it is intended to be an interface,
 * - its public methods are pure virtual functions, and
 * - it does not hold any data, unless those data items are small and function
 *   as part of the interface (e.g. a unique object identifier).
 *
 * An approximation of this definition is classes with pure virtual functions
 * and less than 3 member variables.
 */
class InterfaceClass extends Class {
  InterfaceClass() {
    exists(MemberFunction m |
      m.getDeclaringType() = this and not compgenerated(unresolveElement(m))
    ) and
    forall(MemberFunction m |
      m.getDeclaringType() = this and not compgenerated(unresolveElement(m))
    |
      m instanceof PureVirtualFunction
    ) and
    count(MemberVariable v | v.getDeclaringType() = this) < 3
  }
}

class InterfaceImplementor extends Class {
  InterfaceImplementor() {
    exists(ClassDerivation d |
      d.getDerivedClass() = this and d.getBaseClass() instanceof InterfaceClass
    )
  }

  int getNumInterfaces() {
    result =
      count(ClassDerivation d |
        d.getDerivedClass() = this and d.getBaseClass() instanceof InterfaceClass
      )
  }

  int getNumProtectedImplementations() {
    result =
      count(ClassDerivation d |
        d.hasSpecifier("protected") and
        d.getDerivedClass() = this and
        not d.getBaseClass() instanceof InterfaceClass
      )
  }

  int getNumPrivateImplementations() {
    result =
      count(ClassDerivation d |
        d.hasSpecifier("private") and
        d.getDerivedClass() = this and
        not d.getBaseClass() instanceof InterfaceClass
      )
  }

  int getNumPublicImplementations() {
    result =
      count(ClassDerivation d |
        d.hasSpecifier("public") and
        d.getDerivedClass() = this and
        not d.getBaseClass() instanceof InterfaceClass
      )
  }
}

from InterfaceImplementor d
where
  d.getNumPublicImplementations() > 0 or
  d.getNumProtectedImplementations() > 1
select d,
  "Multiple inheritance should not be used with " + d.getNumInterfaces().toString() +
    " interfaces, " + d.getNumPrivateImplementations().toString() + " private implementations, " +
    d.getNumProtectedImplementations().toString() + " protected implementations, and " +
    d.getNumPublicImplementations().toString() + " public implementations."
