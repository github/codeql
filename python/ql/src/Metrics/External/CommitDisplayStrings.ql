/**
 * @name Display strings of commits
 * @kind display-string
 * @id py/commit-display-strings
 * @metricType commit
 */

import python
import external.VCS

from Commit c
select c.getRevisionName(), c.getMessage() + "(" + c.getDate().toString() + ")"
