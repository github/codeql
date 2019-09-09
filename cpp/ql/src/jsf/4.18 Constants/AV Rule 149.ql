/**
 * @name AV Rule 149
 * @description Octal constants (other than zero) shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-149
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

from OctalLiteral l
where
  l.fromSource() and
  l.getValue() != "0"
select l, "AV Rule 149: Octal constants (other than zero) shall not be used."
