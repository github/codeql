/**
 * @name Inconsistent CompareTo and Equals
 * @description If a class implements 'IComparable.CompareTo' but does not override 'Equals', the two can be inconsistent.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/inconsistent-compareto-and-equals
 * @tags reliability
 *       maintainability
 */

import semmle.code.csharp.frameworks.System

from Class c, Method compareTo, Method compareToImpl
where
  c.fromSource() and
  (
    compareTo = any(SystemIComparableInterface i).getCompareToMethod()
    or
    compareTo = any(SystemIComparableTInterface i).getAConstructedGeneric().getAMethod() and
    compareTo.getSourceDeclaration() = any(SystemIComparableTInterface i).getCompareToMethod()
  ) and
  compareToImpl = c.getAMethod() and
  compareToImpl = compareTo.getAnUltimateImplementor() and
  not compareToImpl.isAbstract() and
  not c.getAMethod() = any(SystemObjectClass o).getEqualsMethod().getAnOverrider+()
select c,
  "Class " + c.getName() +
    " implements CompareTo but does not override Equals; the two could be inconsistent."
