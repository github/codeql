/**
 * @name Specifiers1
 */

import cpp

from Variable v
where v.isConst()
select v.getLocation().getStartLine(), v
