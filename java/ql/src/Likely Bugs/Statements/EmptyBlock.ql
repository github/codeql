/**
 * @name Empty branch of conditional, or empty loop body
 * @description An undocumented empty block or statement hinders readability. It may also
 *              indicate incomplete code.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/empty-block
 * @tags reliability
 *       readability
 */

import semmle.code.java.Statement

/** A block without statements or comments. */
private BlockStmt emptyBlock() {
  result.getNumStmt() = 0 and
  result.getLocation().getNumberOfCommentLines() = 0
}

/** Auxiliary predicate: file and line of a comment. */
private predicate commentedLine(File file, int line) {
  exists(JavadocText text, Location loc |
    loc = text.getLocation() and
    loc.getFile() = file and
    loc.getStartLine() = line and
    loc.getEndLine() = line
  )
}

/** An uncommented empty statement */
private EmptyStmt emptyStmt() {
  not commentedLine(result.getFile(), result.getLocation().getStartLine())
}

/** An empty statement or an empty block. */
Stmt emptyBody() { result = emptyBlock() or result = emptyStmt() }

/**
 * Empty blocks or empty statements should not occur as immediate children of if-statements or loops.
 * Empty blocks should not occur within other blocks.
 */
predicate blockParent(Stmt empty, string msg) {
  empty = emptyBody() and
  (
    empty.getParent() instanceof IfStmt and
    msg = "The body of an if statement should not be empty."
    or
    empty.getParent() instanceof LoopStmt and msg = "The body of a loop should not be empty."
    or
    empty.getParent() instanceof BlockStmt and
    empty instanceof BlockStmt and
    msg = "This block should not be empty."
  )
}

from Stmt empty, string msg
where
  empty = emptyBody() and
  blockParent(empty, msg)
select empty, msg + " Typographical error or missing code?"
