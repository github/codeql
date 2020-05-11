/**
 * @name Duplicate code block
 * @description This block of code is duplicated elsewhere. If possible, the shared code should be refactored so there is only one occurrence left. It may not always be possible to address these issues; other duplicate code checks (such as duplicate function, duplicate class) give subsets of the results with higher confidence.
 * @kind problem
 * @problem.severity recommendation
 * @sub-severity low
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 * @deprecated
 * @precision medium
 * @id py/duplicate-block
 */

import python
import CodeDuplication

predicate sorted_by_location(DuplicateBlock x, DuplicateBlock y) {
  if x.sourceFile() = y.sourceFile()
  then x.sourceStartLine() < y.sourceStartLine()
  else x.sourceFile().getAbsolutePath() < y.sourceFile().getAbsolutePath()
}

from DuplicateBlock d, DuplicateBlock other
where
  d.sourceLines() > 10 and
  other.getEquivalenceClass() = d.getEquivalenceClass() and
  sorted_by_location(other, d)
select d,
  "Duplicate code: " + d.sourceLines() + " lines are duplicated at " +
    other.sourceFile().getShortName() + ":" + other.sourceStartLine().toString()
