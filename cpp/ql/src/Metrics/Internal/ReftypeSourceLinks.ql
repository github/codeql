/**
 * @name Source links of classes
 * @kind source-link
 * @id cpp/reference-type-source-links
 * @metricType reftype
 */

import cpp

from Class c
where c.fromSource()
select c, c.getFile()
