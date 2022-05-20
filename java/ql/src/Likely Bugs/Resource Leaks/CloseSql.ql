/**
 * @name Potential database resource leak
 * @description A database resource that is opened but not closed may cause a resource leak.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/database-resource-leak
 * @tags correctness
 *       resources
 *       external/cwe/cwe-404
 *       external/cwe/cwe-772
 */

import CloseType

from CloseableInitExpr cie, RefType t
where
  badCloseableInit(cie) and
  cie.getType() = t and
  sqlType(t) and
  not noNeedToClose(cie)
select cie, "This " + t.getName() + " is not always closed on method exit."
