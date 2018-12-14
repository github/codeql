/**
 * @name Number of authors (version control)
 * @description The number of distinct authors (by version control history) of a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 * @id java/vcs/authors-per-file
 * @deprecated
 */

import java
import external.VCS

from File f
select f, count(Author author | author.getAnEditedFile() = f)
