/**
 * @name AV Rule 175
 * @description A pointer shall not be compared to NULL or be assigned NULL; use plain 0 instead.
 * @kind problem
 * @id cpp/jsf/av-rule-175
 * @problem.severity recommendation
 * @tags correctness
 *       external/jsf
 */

import cpp

from NULL null
where
  exists(Assignment a | null = a.getRValue()) or
  exists(ComparisonOperation op | null = op.getAnOperand())
select null, "A pointer shall not be compared to NULL or be assigned NULL; use plain 0 instead."
