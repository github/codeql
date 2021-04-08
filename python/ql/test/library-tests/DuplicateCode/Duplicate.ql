/**
 * @name Duplicate
 * @description Insert description here...
 * @kind table
 * @problem.severity warning
 */

import python
import external.CodeDuplication

predicate lexically_sorted(DuplicateBlock dup1, DuplicateBlock dup2) {
  dup1.sourceFile().getAbsolutePath() < dup2.sourceFile().getAbsolutePath()
  or
  dup1.sourceFile().getAbsolutePath() = dup2.sourceFile().getAbsolutePath() and
  dup1.sourceStartLine() < dup2.sourceStartLine()
}

from DuplicateBlock dup1, DuplicateBlock dup2
where
  dup1.getEquivalenceClass() = dup2.getEquivalenceClass() and
  lexically_sorted(dup1, dup2)
select dup1.toString(), dup2.toString(), dup1.sourceFile().getShortName(), dup1.sourceStartLine(),
  dup1.sourceEndLine()
