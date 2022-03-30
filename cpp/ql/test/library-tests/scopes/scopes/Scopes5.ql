/**
 * @name Scopes5
 * @kind table
 */

import cpp

from GlobalNamespace gn
select gn, count(gn.getParentScope())
