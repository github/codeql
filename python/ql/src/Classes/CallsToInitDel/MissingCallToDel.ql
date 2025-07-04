/**
 * @name Missing call to superclass `__del__` during object destruction
 * @description An omitted call to a superclass `__del__` method may lead to class instances not being cleaned up properly.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       performance
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/missing-call-to-delete
 */

import python
import MethodCallOrder

Function getDelMethod(Class c) {
  result = c.getAMethod() and
  result.getName() = "__del__"
}

from Class base, Function shouldCall, FunctionOption possibleIssue, string msg
where
  not exists(Function newMethod | newMethod = base.getAMethod() and newMethod.getName() = "__new__") and
  exists(FunctionOption possiblyMissingSuper |
    missingCallToSuperclassMethodRestricted(base, shouldCall, "__del__") and
    possiblyMissingSuper = getPossibleMissingSuperOption(base, shouldCall, "__del__") and
    (
      not possiblyMissingSuper.isNone() and
      possibleIssue = possiblyMissingSuper and
      msg =
        "This class does not call $@ during finalization. ($@ may be missing a call to super().__del__)"
      or
      possiblyMissingSuper.isNone() and
      (
        possibleIssue.asSome() = getDelMethod(base) and
        msg =
          "This class does not call $@ during finalization. ($@ may be missing a call to a base class __del__)"
        or
        not exists(getDelMethod(base)) and
        possibleIssue.isNone() and
        msg =
          "This class does not call $@ during finalization. (The class lacks an __del__ method to ensure every base class __del__ is called.)"
      )
    )
  )
select base, msg, shouldCall, shouldCall.getQualifiedName(), possibleIssue,
  possibleIssue.getQualifiedName()
