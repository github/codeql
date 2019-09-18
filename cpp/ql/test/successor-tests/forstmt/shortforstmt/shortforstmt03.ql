/**
 * @name shortforstmt03
 * @description No for condition has no more than two successors.
 */

import cpp

from ForStmt fs
where count(fs.getCondition().getASuccessor()) > 2
select fs
