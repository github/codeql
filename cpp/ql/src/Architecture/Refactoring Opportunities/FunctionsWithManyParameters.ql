/**
 * @name Functions with too many parameters
 * @description Finds functions with many parameters;
 *              they could probably be refactored by wrapping parameters into a struct.
 * @kind problem
 * @id cpp/architecture/functions-with-many-parameters
 * @problem.severity recommendation
 * @tags testability
 *       statistical
 *       non-attributable
 */

import cpp

from Function f
where
  f.fromSource() and
  f.getMetrics().getNumberOfParameters() > 15
select f,
  "This function has too many parameters (" + f.getMetrics().getNumberOfParameters().toString() +
    ")"
