/**
 * @name Usages
 * @description Insert description here...
 * @kind problem
 * @problem.severity warning
 */

import python

from Name u
where u.uses(_)
select u.getId(), u.getLocation().getStartLine()