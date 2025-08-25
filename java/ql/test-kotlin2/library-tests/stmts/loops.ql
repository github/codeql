import java

query predicate breakLabel(BreakStmt s, string label) { s.getLabel() = label }

query predicate continueLabel(ContinueStmt s, string label) { s.getLabel() = label }

query predicate jumpTarget(JumpStmt s, StmtParent p) { s.getTarget() = p }
