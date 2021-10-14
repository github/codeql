/**
 * @name AV Rule 14
 * @description Literal suffixes shall use uppercase rather than lowercase letters.
 * @kind problem
 * @id cpp/jsf/av-rule-14
 * @problem.severity error
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from Literal l
where
  l.fromSource() and
  l.getValueText().regexpMatch(".*[ul][uUlL]*\\s*")
select l, "AV Rule 14: Literal suffixes shall use uppercase rather than lowercase letters."
