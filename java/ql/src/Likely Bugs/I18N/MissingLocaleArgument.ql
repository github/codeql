/**
 * @name Missing Locale parameter to toUpperCase() or toLowerCase()
 * @description Calling 'String.toUpperCase()' or 'String.toLowerCase()' without specifying the
 *              locale may cause unexpected results for certain default locales.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/missing-locale-argument
 * @tags reliability
 *       maintainability
 */

import java

from MethodCall ma, Method changecase
where
  (
    changecase.hasName("toUpperCase") or
    changecase.hasName("toLowerCase")
  ) and
  changecase.hasNoParameters() and
  changecase.getDeclaringType() instanceof TypeString and
  ma.getMethod() = changecase
select ma, changecase.getName() + " without locale parameter."
