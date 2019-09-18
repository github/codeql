/**
 * @name AV Rule 192
 * @description All if, else if constructs will contain either a final else clause
 *              or a comment indicating why a final else clause is not necessary.
 * @kind problem
 * @id cpp/jsf/av-rule-192
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

// the extractor associates comments with the statement immediately following them
// additionally, we also want to count comments that come right after the if statement,
// as this seems a likely place to put a comment explaining the absence of an else
predicate isCommented(IfStmt i) {
  exists(Comment c |
    c.getCommentedElement() = i or
    i.getLocation().getEndLine() = c.getLocation().getStartLine()
  )
}

from IfStmt i
where
  i.fromSource() and
  // only applies if there are one or more else-ifs
  exists(IfStmt i2 | i2.getElse() = i) and
  not i.hasElse() and
  not isCommented(i)
select i,
  "AV Rule 192: All if-else if chains will have an else clause or a comment explaining its absence."
