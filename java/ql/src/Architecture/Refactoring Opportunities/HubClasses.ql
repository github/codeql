/**
 * @name Hub classes
 * @description Hub classes, which are classes that use, and are used by, many other classes, are
 *              complex and difficult to change without affecting the rest of the system.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/hub-class
 * @tags maintainability
 *       modularity
 */

import java

from RefType t, int aff, int eff
where
  t.fromSource() and
  aff = t.getMetrics().getAfferentCoupling() and
  eff = t.getMetrics().getEfferentSourceCoupling() and
  aff > 15 and
  eff > 15
select t as Class,
  "Hub class: this class depends on " + eff.toString() + " classes and is used by " + aff.toString()
    + " classes."
