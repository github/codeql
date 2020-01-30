/**
 * @name Average cyclomatic complexity of files
 * @description The average cyclomatic complexity of the functions in a file.
 * @kind treemap
 * @id cpp/average-cyclomatic-complexity-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags testability
 *       complexity
 */

import cpp

from File f, float complexity, float loc
where
  f.fromSource() and
  loc = sum(FunctionDeclarationEntry fde | fde.getFile() = f | fde.getNumberOfLines()).(float) and
  if loc > 0
  then
    // Weighted average of complexity by function length
    complexity =
      sum(FunctionDeclarationEntry fde |
          fde.getFile() = f
        |
          fde.getNumberOfLines() * fde.getCyclomaticComplexity()
        ).(float) / loc
  else complexity = 0
select f, complexity
