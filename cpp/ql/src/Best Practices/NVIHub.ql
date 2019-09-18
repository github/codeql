/**
 * @name Public virtual method in Hub Class
 * @description When public methods can be overridden, base classes are unable
 *              to enforce invariants that should hold for the whole hierarchy.
 *              This is especially problematic in classes with many
 *              dependencies or dependents.
 * @kind problem
 * @id cpp/nvi-hub
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 */

import cpp

//see http://www.gotw.ca/publications/mill18.htm
from MemberFunction f, int hubIndex, Class fclass
where
  f.hasSpecifier("public") and
  f.hasSpecifier("virtual") and
  f.getFile().fromSource() and
  not f instanceof Destructor and
  fclass = f.getDeclaringType() and
  hubIndex = fclass.getMetrics().getAfferentCoupling() * fclass.getMetrics().getEfferentCoupling() and
  hubIndex > 100
select f, "Avoid having public virtual methods (NVI idiom)"
