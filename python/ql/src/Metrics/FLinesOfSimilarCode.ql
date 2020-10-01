/**
 * @deprecated
 * @name Similar lines in files
 * @description The number of lines in a file, including code, comment and whitespace lines,
 *              which are similar in at least one other place.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision high
 * @tags testability
 * @id py/similar-lines-in-files
 */

import python
import external.CodeDuplication

from File f, int n
where
  n =
    count(int line |
      exists(SimilarBlock d | d.sourceFile() = f |
        line in [d.sourceStartLine() .. d.sourceEndLine()] and
        not allowlistedLineForDuplication(f, line)
      )
    )
select f, n order by n desc
