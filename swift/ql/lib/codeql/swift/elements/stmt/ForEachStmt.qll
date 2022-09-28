private import codeql.swift.generated.stmt.ForEachStmt

class ForEachStmt extends ForEachStmtBase {
  override string toString() {
    if this.hasWhere()
    then result = "for ... in ... where ... { ... }"
    else result = "for ... in ... { ... }"
  }
}
