/**
 * @name AV Rule 170
 * @description More than two levels of pointer indirection shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-170
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from PointerType t, Element e
where
  t.getPointerIndirectionLevel() > 2 and
  t.getATypeNameUse() = e
select e, "AV Rule 170: More than two levels of pointer indirection shall not be used."
