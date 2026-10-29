import java

predicate mayDropThroughWithoutComment(SwitchStmt switch, Stmt switchCase) {
  exists(int caseIx, SwitchCase next, int nextCaseStmtIx, Stmt lastInCase, ControlFlowNode node |
    switch.getCase(caseIx) = switchCase and
    switch.getCase(caseIx + 1) = next and
    switch.getStmt(nextCaseStmtIx) = next and
    switch.getStmt(nextCaseStmtIx - 1) = lastInCase and
    lastInCase != switchCase and
    node.isAfter(lastInCase) and
    node.getANormalSuccessor().asStmt() = switch.getAStmt() and
    not fallThroughCommented(next)
  )
}

private predicate fallThroughCommented(Stmt case) {
  exists(Location loc |
    loc = case.getLocation() and
    loc.getStartLine() = fallThroughCommentedLine(loc.getFile())
  )
}

private int fallThroughCommentedLine(File f) {
  exists(Location loc, JavadocText text |
    loc.getFile() = f and
    text.getLocation() = loc and
    text.getText().toLowerCase().regexpMatch(".*falls?[ -]?(through|thru).*") and
    result = loc.getStartLine() + 1
  )
  or
  exists(int mid |
    mid = fallThroughCommentedLine(f) and
    not stmtLine(f) = mid and
    mid < max(stmtLine(f)) and
    result = mid + 1
  )
}

private int stmtLine(File f) {
  exists(Stmt s, Location loc |
    s.getLocation() = loc and
    loc.getFile() = f and
    loc.getStartLine() = result
  )
}
