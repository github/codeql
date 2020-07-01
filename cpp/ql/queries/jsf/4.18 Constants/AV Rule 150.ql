/**
 * @name AV Rule 150
 * @description Hexadecimal constants will be represented using all uppercase letters.
 * @kind problem
 * @id cpp/jsf/av-rule-150
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

from HexLiteral l
where
  l.fromSource() and
  l.getValueText().regexpMatch(".*[a-z].*")
select l, "AV Rule 150: Hexadecimal constants will be represented using all uppercase letters."
