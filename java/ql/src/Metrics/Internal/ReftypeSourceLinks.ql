/**
 * @name Source links of reference types
 * @kind source-link
 * @metricType reftype
 * @id java/reference-type-source-links
 */

import java

from RefType t
where t.fromSource()
select t, t.getFile()
