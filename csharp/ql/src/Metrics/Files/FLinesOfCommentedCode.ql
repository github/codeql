/**
 * @name Lines of commented-out code in files
 * @description The number of lines of commented-out code in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cs/lines-of-commented-out-code-in-files
 * @tags maintainability
 *       documentation
 */

import csharp

from SourceFile f, int n
where
  n =
    count(CommentLine line |
      exists(CommentBlock block |
        block.getLocation().getFile() = f and
        line = block.getAProbableCodeLine()
      )
    )
select f, n order by n desc
