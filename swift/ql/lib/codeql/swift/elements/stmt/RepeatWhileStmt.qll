private import codeql.swift.generated.stmt.RepeatWhileStmt

class RepeatWhileStmt extends RepeatWhileStmtBase {
  override string toString() { result = "repeat { ... } while ... " }
}
