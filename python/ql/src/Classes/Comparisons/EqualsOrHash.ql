/**
 * @name Inconsistent equality and hashing
 * @description Defining a hash operation without defining equality may be a mistake.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-581
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/equals-hash-mismatch
 */

import python

predicate missingEquality(Class cls, Function defined) {
  defined = cls.getMethod("__hash__") and
  not exists(cls.getMethod("__eq__"))
  // In python 3, the case of defined eq without hash automatically makes the class unhashable (even if a superclass defined hash)
  // So this is not an issue.
}

from Class cls, Function defined
where missingEquality(cls, defined)
select cls, "This class implements $@, but does not implement __eq__.", defined, defined.getName()
