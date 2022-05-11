import java

query predicate breakLabel(BreakStmt s, string label) { s.getLabel() = label }

query predicate continueLabel(ContinueStmt s, string label) { s.getLabel() = label }

query predicate breakTarget(KtBreakStmt s, KtLoopStmt l) { s.getLoopStmt() = l }

query predicate continueTarget(KtContinueStmt s, KtLoopStmt l) { s.getLoopStmt() = l }
