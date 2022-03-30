/**
 * @name Potentially incorrect Equals(...) signature
 * @description The declaring type of a method with signature 'Equals(T)' does not implement 'Equals(object)'.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/wrong-equals-signature
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

class EqualsOtherMethod extends Method {
  EqualsOtherMethod() {
    this.hasName("Equals") and
    this.getNumberOfParameters() = 1 and
    this.getReturnType() instanceof BoolType and
    this.getDeclaringType() instanceof Class and
    not this instanceof EqualsMethod and
    not this instanceof IEquatableEqualsMethod
  }

  Type getType() { result = this.getParameter(0).getType() }
}

from EqualsOtherMethod equalsOther
where
  equalsOther.isSourceDeclaration() and
  not implementsEquals(equalsOther.getDeclaringType())
select equalsOther,
  "The $@ of this 'Equals(" + equalsOther.getType().getName() +
    ")' method does not override 'Equals(object)'.", equalsOther.getDeclaringType(),
  "declaring type"
