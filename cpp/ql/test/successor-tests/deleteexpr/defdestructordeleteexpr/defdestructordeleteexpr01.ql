/**
 * @name defdestructordeleteexpr01
 * @description Control flow that involves a default constructor.
 */

import cpp

from ControlFlowNode c
where c.getControlFlowScope().getName() = "f"
select c, c.getASuccessor()
