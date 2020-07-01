/**
 * @name AV Rule 51
 * @description All letters contained in function and variable names will be lowercase.
 * @kind problem
 * @id cpp/jsf/av-rule-51
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import Naming

predicate relevant(Declaration d, string kind) {
  d instanceof Function and kind = "function"
  or
  d instanceof Variable and kind = "variable"
}

from Declaration d, Word w, string kind
where
  relevant(d, kind) and
  w = d.getName().(Name).getAWord() and
  not (w.couldBeUppercaseAcronym() and w != d.getName()) and
  not w.isLowercase()
select d, "AV Rule 51: All letters contained in " + kind + " names will be lowercase."
