private import codeql.swift.generated.decl.IfConfigDecl

class IfConfigDecl extends IfConfigDeclBase {
  override string toString() { result = "#if ..." }
}
