/**
 * @name Number of authors (Javadoc)
 * @description The number of different authors (by Javadoc tag) of a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @id java/authors-per-file
 * @tags maintainability
 */

import java

from CompilationUnit u, int num
where
  num =
    strictcount(string s | exists(Documentable d | d.getAuthor() = s and d.getCompilationUnit() = u))
select u, num
