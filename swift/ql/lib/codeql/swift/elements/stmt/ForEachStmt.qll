private import codeql.swift.generated.stmt.ForEachStmt

class ForEachStmt extends Generated::ForEachStmt {
  override string toString() {
    if this.hasWhere()
    then result = "for ... in ... where ... { ... }"
    else result = "for ... in ... { ... }"
  }
}
