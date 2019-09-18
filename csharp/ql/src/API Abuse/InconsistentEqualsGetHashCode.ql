/**
 * @name Inconsistent Equals(object) and GetHashCode()
 * @description If a class overrides only one of 'Equals(object)' and 'GetHashCode()', it may mean that
 *              'Equals(object)' and 'GetHashCode()' are inconsistent.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/inconsistent-equals-and-gethashcode
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-581
 */

import csharp
import semmle.code.csharp.frameworks.System

from Class c, Method present, string missing
where
  c.isSourceDeclaration() and
  (
    present = c.getAMethod().(EqualsMethod) and
    not c.getAMethod() instanceof GetHashCodeMethod and
    missing = "GetHashCode()"
    or
    present = c.getAMethod().(GetHashCodeMethod) and
    not implementsEquals(c) and
    missing = "Equals(object)"
  )
select c, "Class '" + c.getName() + "' overrides $@, but not " + missing + ".", present,
  present.getName()
