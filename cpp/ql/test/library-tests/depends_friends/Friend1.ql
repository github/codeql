/**
 * @name Friends1
 * @description Check that a class depends on its friend class.
 */

import cpp

from MetricClass c, Class f1
where c.getAClassDependency() = f1
select c, f1
