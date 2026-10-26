/**
 * @name Specifiers2
 */

import cpp

from Variable v
where v.hasSpecifier("extern")
select v.getLocation().getStartLine(), v.getName()
