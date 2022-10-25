private import codeql.swift.generated.stmt.RepeatWhileStmt

class RepeatWhileStmt extends Generated::RepeatWhileStmt {
  override string toString() { result = "repeat { ... } while ... " }
}
