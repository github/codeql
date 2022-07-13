private import codeql.swift.generated.decl.TopLevelCodeDecl

class TopLevelCodeDecl extends TopLevelCodeDeclBase {
  override string toString() { result = this.getBody().toString() }
}
