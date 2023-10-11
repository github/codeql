/**
 * @kind path-problem
 */

import swift

from Function f
where f.getName().matches("os_log%")
select f, concat(f.getInterfaceType().toString(), ", ")
