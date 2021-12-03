/**
 * @name Empty branch of conditional, or empty loop body
 * @description Empty blocks that occur as a branch of a conditional or as a loop body may indicate
 *              badly-maintained code or a bug due to an unhandled case.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/empty-block
 * @tags reliability
 *       readability
 */

import csharp

predicate loopStmtWithEmptyBlock(BlockStmt child) {
  exists(LoopStmt stmt, SourceLocation l |
    stmt.getAChild() = child and
    child.getNumberOfStmts() = 0 and
    child.getLocation() = l and
    l.getStartLine() != l.getEndLine()
  )
}

predicate conditionalWithEmptyBlock(BlockStmt child) {
  exists(IfStmt stmt |
    stmt.getThen() = child and child.getNumberOfStmts() = 0 and not exists(stmt.getElse())
  )
  or
  exists(IfStmt stmt, SourceLocation l |
    stmt.getThen() = child and
    child.getNumberOfStmts() = 0 and
    exists(stmt.getElse()) and
    child.getLocation() = l and
    l.getStartLine() != l.getEndLine()
  )
  or
  exists(IfStmt stmt | stmt.getElse() = child and child.getNumberOfStmts() = 0)
}

from BlockStmt s
where
  (loopStmtWithEmptyBlock(s) or conditionalWithEmptyBlock(s)) and
  not exists(CommentBlock c | c.getParent() = s) and
  not exists(ForStmt fs | fs.getBody() = s and exists(fs.getAnUpdate()))
select s, "Empty block."
