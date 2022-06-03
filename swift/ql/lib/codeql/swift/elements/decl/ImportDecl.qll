private import codeql.swift.generated.decl.ImportDecl

class ImportDecl extends ImportDeclBase {
  override string toString() { result = "import ..." }
}
