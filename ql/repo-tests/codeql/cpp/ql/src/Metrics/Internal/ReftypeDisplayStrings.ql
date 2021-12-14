/**
 * @name Display strings of classes
 * @kind display-string
 * @id cpp/reference-type-display-strings
 * @metricType reftype
 */

import cpp

from Class c
where c.fromSource()
select c, c.getName()
