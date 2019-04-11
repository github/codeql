/**
 * @name Classes with too many source dependencies
 * @description Finds classes that depend on many other types; they could probably be refactored into smaller classes with fewer dependencies.
 * @kind problem
 * @id cpp/architecture/classes-with-many-dependencies
 * @problem.severity recommendation
 * @workingset jhotdraw
 * @result succeed 20
 * @result_ondemand succeed 20
 * @tags maintainability
 *       statistical
 *       non-attributable
 */

import cpp

from Class t, int n
where
  t.fromSource() and
  n = t.getMetrics().getEfferentSourceCoupling() and
  n > 10
select t as Class, "This class has too many dependencies (" + n.toString() + ")"
