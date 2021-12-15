/**
 * @name whilestmt03
 * @description No while condition has more than two successors.
 */

import cpp

from WhileStmt ws
where count(ws.getCondition().getASuccessor()) > 2
select ws
