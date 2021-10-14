import java

private Stmt getASwitchChild(SwitchStmt s) {
  result = s.getAChild()
  or
  exists(Stmt mid |
    mid = getASwitchChild(s) and not mid instanceof SwitchStmt and result = mid.getAChild()
  )
}

private predicate blockInSwitch(SwitchStmt s, BasicBlock b) {
  b.getFirstNode().getEnclosingStmt() = getASwitchChild(s)
}

private predicate switchCaseControlFlow(SwitchStmt switch, BasicBlock b1, BasicBlock b2) {
  blockInSwitch(switch, b1) and
  b1.getABBSuccessor() = b2 and
  blockInSwitch(switch, b2)
}

predicate switchCaseControlFlowPlus(SwitchStmt switch, BasicBlock b1, BasicBlock b2) {
  switchCaseControlFlow(switch, b1, b2)
  or
  exists(BasicBlock mid |
    switchCaseControlFlowPlus(switch, mid, b2) and
    switchCaseControlFlow(switch, b1, mid) and
    not mid.getFirstNode() = switch.getACase()
  )
}

predicate mayDropThroughWithoutComment(SwitchStmt switch, Stmt switchCase) {
  switchCase = switch.getACase() and
  exists(Stmt other, BasicBlock b1, BasicBlock b2 |
    b1.getFirstNode() = switchCase and
    b2.getFirstNode() = other and
    switchCaseControlFlowPlus(switch, b1, b2) and
    other = switch.getACase() and
    not fallThroughCommented(other)
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
