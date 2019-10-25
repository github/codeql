/**
 * @name ifelsestmt03
 * @description No if condition has more than two successors.
 */

import cpp

from IfStmt is
where count(is.getCondition().getASuccessor()) > 2
select is
