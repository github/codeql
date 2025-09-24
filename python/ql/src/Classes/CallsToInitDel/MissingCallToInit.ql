/**
 * @name Missing call to superclass `__init__` during object initialization
 * @description An omitted call to a superclass `__init__` method may lead to objects of this class not being fully initialized.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/missing-call-to-init
 */

import python
import MethodCallOrder

from Class base, Function shouldCall, FunctionOption possibleIssue, string msg
where
  exists(FunctionOption possiblyMissingSuper |
    missingCallToSuperclassMethodRestricted(base, shouldCall, "__init__") and
    possiblyMissingSuper = getPossibleMissingSuperOption(base, shouldCall, "__init__") and
    (
      possibleIssue.asSome() = possiblyMissingSuper.asSome() and
      msg =
        "This class does not call $@ during initialization. ($@ may be missing a call to super().__init__)"
      or
      possiblyMissingSuper.isNone() and
      (
        possibleIssue.asSome() = base.getInitMethod() and
        msg =
          "This class does not call $@ during initialization. ($@ may be missing a call to a base class __init__)"
        or
        not exists(base.getInitMethod()) and
        possibleIssue.isNone() and
        msg =
          "This class does not call $@ during initialization. (The class lacks an __init__ method to ensure every base class __init__ is called.)"
      )
    )
  )
select base, msg, shouldCall, shouldCall.getQualifiedName(), possibleIssue,
  possibleIssue.getQualifiedName()
