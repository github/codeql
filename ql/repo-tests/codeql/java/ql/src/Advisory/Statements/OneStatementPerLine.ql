/**
 * @name Multiple statements on line
 * @description More than one statement per line decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/multiple-statements-on-same-line
 * @tags maintainability
 */

import java

predicate lineDefinesEnum(File f, int line) {
  exists(Location l |
    exists(EnumType e | e.getLocation() = l) or
    exists(EnumConstant e | e.getLocation() = l)
  |
    f = l.getFile() and line = l.getStartLine()
  )
}

predicate oneLineStatement(Stmt s, File f, int line, int col) {
  exists(Location l | s.getLocation() = l |
    f = l.getFile() and
    line = l.getStartLine() and
    line = l.getEndLine() and
    col = l.getStartColumn()
  ) and
  // Exclude blocks: `{break;}` is not really a violation.
  not s instanceof BlockStmt and
  // Exclude implicit super constructor invocations.
  not s instanceof SuperConstructorInvocationStmt and
  // Java enums are desugared to a whole bunch of generated statements.
  not lineDefinesEnum(f, line)
}

from Stmt s, Stmt s2
where
  exists(File f, int line, int col, int col2 |
    oneLineStatement(s, f, line, col) and
    oneLineStatement(s2, f, line, col2) and
    col < col2 and
    // Don't report multiple results if more than 2 statements are on a single line.
    col = min(int otherCol | oneLineStatement(_, f, line, otherCol))
  )
select s, "This statement is followed by another on the same line."
