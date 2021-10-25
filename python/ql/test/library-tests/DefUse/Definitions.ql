/**
 * @name Definitions
 * @description Insert description here...
 * @kind table
 * @problem.severity warning
 */

import python

from Name d
where d.defines(_)
select d.getId(), d.getLocation().getStartLine()
