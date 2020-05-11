/**
 * @name Similar
 * @description Insert description here...
 * @kind table
 * @problem.severity warning
 */

import python
import external.CodeDuplication

predicate lexically_sorted(SimilarBlock dup1, SimilarBlock dup2) {
  dup1.sourceFile().getAbsolutePath() < dup2.sourceFile().getAbsolutePath()
  or
  dup1.sourceFile().getAbsolutePath() = dup2.sourceFile().getAbsolutePath() and
  dup1.sourceStartLine() < dup2.sourceStartLine()
}

from SimilarBlock dup1, SimilarBlock dup2
where
  dup1.getEquivalenceClass() = dup2.getEquivalenceClass() and
  lexically_sorted(dup1, dup2)
select dup1, dup2, dup1.sourceFile().getShortName(), dup1.sourceStartLine(), dup1.sourceEndLine()
