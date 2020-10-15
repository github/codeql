/**
 * @deprecated
 * @name Similar lines in files
 * @description The number of lines in a file, including code, comment and whitespace lines,
 *              which are similar to lines in at least one other place.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/similar-lines-per-file
 * @tags testability
 */

import external.CodeDuplication

from File f, int n
where
  n =
    count(int line |
      exists(SimilarBlock d | d.sourceFile() = f |
        line in [d.sourceStartLine() .. d.sourceEndLine()] and
        not whitelistedLineForDuplication(f, line)
      )
    )
select f, n order by n desc
