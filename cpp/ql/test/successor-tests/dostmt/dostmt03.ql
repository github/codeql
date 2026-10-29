/**
 * @name dostmt03
 * @description No do statement condition has more than two successors.
 */

import cpp

from DoStmt ds
where count(ds.getCondition().getASuccessor()) > 2
select ds
