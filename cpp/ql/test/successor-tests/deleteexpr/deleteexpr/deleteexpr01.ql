/**
 * @name deleteexpr01
 * @description The expression statement is followed by the reeference to c, which is followed by the delete call.
 */

import cpp

from ControlFlowNode node
where node.getControlFlowScope().getName() = "f"
select node, node.getASuccessor()
