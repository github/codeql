/**
 * @name First argument to super() is not enclosing class
 * @description Calling super with something other than the enclosing class may cause incorrect object initialization.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       convention
 *       external/cwe/cwe-687
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/super-not-enclosing-class
 */

import python

from CallNode call_to_super, string name
where
  exists(GlobalVariable gv, ControlFlowNode cn |
    call_to_super = ClassValue::super_().getACall() and
    gv.getId() = "super" and
    cn = call_to_super.getArg(0) and
    name = call_to_super.getScope().getScope().(Class).getName() and
    exists(ClassValue other |
      cn.pointsTo(other) and
      not other.getScope().getName() = name
    )
  )
select call_to_super.getNode(), "First argument to super() should be " + name + "."
