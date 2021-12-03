/**
 * @name Misleading indentation after control statement
 * @description The body of a control statement should have appropriate indentation to clarify which
 *              statements it controls and which ones it does not control.
 * @kind problem
 * @problem.severity warning
 * @id js/misleading-indentation-after-control-statement
 * @tags correctness
 *       statistical
 *       non-attributable
 *       external/cwe/cwe-483
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

/**
 * Holds if `ctrl` controls statement `s1`, which is followed by another statement `s2`
 * that `ctrl` does not control.
 */
predicate misleadingIndentationCandidate(ControlStmt ctrl, Stmt s1, Stmt s2) {
  not ctrl.getTopLevel().isMinified() and
  s1 = ctrl.getAControlledStmt() and
  s1.getLastToken().getNextToken() = s2.getFirstToken() and
  not s2 = ctrl.getAControlledStmt()
}

from
  ControlStmt ctrl, Stmt s1, Stmt s2, string indent, int ctrlStartColumn, int startColumn, File f,
  int ctrlStartLine, int startLine1, int startLine2
where
  misleadingIndentationCandidate(ctrl, s1, s2) and
  ctrl.getLocation().hasLocationInfo(f.getAbsolutePath(), ctrlStartLine, ctrlStartColumn, _, _) and
  // `s1` and `s2` are indented the same
  s1.getLocation().hasLocationInfo(f.getAbsolutePath(), startLine1, startColumn, _, _) and
  s2.getLocation().hasLocationInfo(f.getAbsolutePath(), startLine2, startColumn, _, _) and
  // `s1` is indented relative to `ctrl`
  startColumn > ctrlStartColumn and
  // `ctrl`, `s1` and `s2` all have the same indentation character
  f.hasIndentation(ctrlStartLine, indent, _) and
  f.hasIndentation(startLine1, indent, _) and
  f.hasIndentation(startLine2, indent, _) and
  not s2 instanceof EmptyStmt
select s2.(FirstLineOf),
  "The indentation of this statement suggests that it is controlled by $@, while in fact it is not.",
  ctrl.(FirstLineOf), "this statement"
