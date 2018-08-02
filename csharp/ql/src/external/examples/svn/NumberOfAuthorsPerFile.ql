/**
 * @name Number of authors
 * @description Number of distinct authors for each file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg
 * @deprecated
 */
import csharp
import external.VCS

from File f, int n
where n = count(Author author | author.getAnEditedFile() = f)
  and f.fromSource()
select f, n
order by n desc
