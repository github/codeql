/**
 * @name Semicolon insertion
 * @description Code that uses automatic semicolon insertion inconsistently is hard to read and maintain.
 * @kind problem
 * @problem.severity recommendation
 * @id js/automatic-semicolon-insertion
 * @tags maintainability
 *       language-features
 *       statistical
 *       non-attributable
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

/**
 * Holds if statement `s` in statement container `sc` either has a semicolon
 * inserted and `asi` is true, or does not have a semicolon inserted and `asi`
 * is `false`.
 */
predicate asi(StmtContainer sc, Stmt s, boolean asi) {
  exists(TopLevel tl | tl = sc.getTopLevel() |
    not tl instanceof EventHandlerCode and
    not tl.isExterns()
  ) and
  sc = s.getContainer() and
  s.isSubjectToSemicolonInsertion() and
  (if s.hasSemicolonInserted() then asi = true else asi = false)
}

from Stmt s, StmtContainer sc, string sctype, float asi, int nstmt, int perc
where
  s.hasSemicolonInserted() and
  sc = s.getContainer() and
  (if sc instanceof Function then sctype = "function" else sctype = "script") and
  asi = strictcount(Stmt ss | asi(sc, ss, true)) and
  nstmt = strictcount(Stmt ss | asi(sc, ss, _)) and
  perc = ((1 - asi / nstmt) * 100).floor() and
  perc >= 90
select s.(LastLineOf),
  "Avoid automated semicolon insertion " + "(" + perc +
    "% of all statements in $@ have an explicit semicolon).", sc, "the enclosing " + sctype
