/**
 * @name AV Rule 52
 * @description Identifiers for constant and enumerator values shall be lowercase.
 * @kind problem
 * @id cpp/jsf/av-rule-52
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import Naming

predicate relevant(Declaration d, string kind) {
  d instanceof EnumConstant and kind = "enumerator"
  or
  d.(Variable).isConst() and kind = "constant"
}

from Declaration d, Word w, string kind
where
  relevant(d, kind) and
  w = d.getName().(Name).getAWord() and
  not (w.couldBeUppercaseAcronym() and w != d.getName()) and
  not w.isLowercase()
select d, "AV Rule 52: identifiers for " + kind + " values shall be lowercase."
