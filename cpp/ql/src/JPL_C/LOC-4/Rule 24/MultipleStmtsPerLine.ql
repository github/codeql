/**
 * @name More than one statement per line
 * @description Putting more than one statement on a single line hinders program understanding.
 * @kind problem
 * @id cpp/jpl-c/multiple-stmts-per-line
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp
import semmle.code.cpp.commons.Exclusions

class OneLineStmt extends Stmt {
  OneLineStmt() {
    this.getLocation().getStartLine() = this.getLocation().getEndLine() and
    not exists(ForStmt for | this = for.getInitialization())
  }

  predicate onLine(File f, int line) {
    f = this.getFile() and line = this.getLocation().getStartLine()
  }
}

int numStmt(File f, int line) { result = strictcount(OneLineStmt o | o.onLine(f, line)) }

from File f, int line, OneLineStmt o, int cnt
where
  numStmt(f, line) = cnt and
  cnt > 1 and
  o.onLine(f, line) and
  o.getLocation().getStartColumn() =
    min(OneLineStmt other, int toMin |
      other.onLine(f, line) and toMin = other.getLocation().getStartColumn()
    |
      toMin
    ) and
  // Exclude statements that are from invocations of system-header macros.
  // Example: FD_ISSET from glibc.
  not isFromSystemMacroDefinition(o)
select o, "This line contains " + cnt + " statements; only one is allowed."
