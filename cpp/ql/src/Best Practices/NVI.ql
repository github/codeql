/**
 * @name Public virtual method
 * @description When public methods can be overridden, base classes are unable
 *              to enforce invariants that should hold for the whole hierarchy.
 * @kind problem
 * @id cpp/nvi
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 */

import cpp

//see http://www.gotw.ca/publications/mill18.htm
from MemberFunction f
where
  f.hasSpecifier("public") and
  f.hasSpecifier("virtual") and
  f.getFile().fromSource() and
  not f instanceof Destructor
select f, "Avoid having public virtual methods (NVI idiom)"
