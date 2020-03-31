/**
 * @name Source links of commits
 * @kind source-link
 * @id py/commit-source-links
 * @metricType commit
 */

import python
import external.VCS

from Commit c, File f
where f.fromSource() and f = c.getAnAffectedFile()
select c.getRevisionName(), f
