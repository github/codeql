/**
 * @deprecated
 * @name Similar lines in files
 * @description The number of lines in a file (including code, comment and whitespace lines)
 *              occurring in a block of lines that is similar to a block of lines seen
 *              somewhere else.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision high
 * @id js/similar-lines-in-files
 * @tags testability
 *       duplicate-code
 *       non-attributable
 */

import external.CodeDuplication

/**
 * Holds if line `l` of file `f` belong to a block of lines that is similar to a block
 * of lines appearing somewhere else.
 */
predicate simLine(int l, File f) {
  exists(SimilarBlock d | d.sourceFile() = f | l in [d.sourceStartLine() .. d.sourceEndLine()])
}

from File f, int n
where n = count(int l | simLine(l, f))
select f, n order by n desc
