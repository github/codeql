/**
 * @name Number of authors (version control)
 * @description The number of distinct authors (by version control history) below this location in the tree
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 * @id cs/vcs/authors-per-file
 */

import csharp
import external.VCS

from File f
select f, count(Author author | author.getAnEditedFile() = f)
