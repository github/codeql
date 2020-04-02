/**
 * @name Source links of classes
 * @kind source-link
 * @id py/class-source-links
 * @metricType reftype
 */

import python

from Class c
select c, c.getLocation().getFile()
