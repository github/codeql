private import AstImport

class TypeNameExpr extends Expr, TTypeNameExpr {
  private predicate parseName(string namespace, string typename) {
    exists(string fullName | fullName = this.getPossiblyQualifiedName() |
      if fullName.matches("%.%")
      then
        namespace = fullName.regexpCapture("([a-zA-Z0-9\\.]+)\\.([a-zA-Z0-9]+)", 1) and
        typename = fullName.regexpCapture("([a-zA-Z0-9\\.]+)\\.([a-zA-Z0-9]+)", 2)
      else (
        namespace = "" and
        typename = fullName
      )
    )
  }

  string getLowerCaseName() { this.parseName(_, result) }

  bindingset[result]
  pragma[inline_late]
  string getAName() { this.parseName(_, result.toLowerCase()) }

  /** If any */
  string getPossiblyQualifiedName() {
    result = getRawAst(this).(Raw::TypeNameExpr).getName().toLowerCase()
  }

  // TODO: What to do when System is omitted?
  string getNamespace() { this.parseName(result, _) }

  override string toString() { result = this.getLowerCaseName() }

  predicate isQualified() { this.getNamespace() != "" }

  predicate hasQualifiedName(string namespace, string typename) {
    this.isQualified() and
    this.parseName(namespace, typename)
  }
}

class QualifiedTypeNameExpr extends TypeNameExpr {
  QualifiedTypeNameExpr() { this.isQualified() }
}
