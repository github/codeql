/**
 * @name AV Rule 47
 * @description Identifiers will not begin with the underscore character.
 * @kind problem
 * @id cpp/jsf/av-rule-47
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Declaration d
where
  d.fromSource() and
  d.getName().matches("\\_%")
select d, "Identifiers will not begin with the underscore character."
