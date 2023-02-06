private import codeql.swift.generated.decl.TopLevelCodeDecl

class TopLevelCodeDecl extends Generated::TopLevelCodeDecl {
  override string toString() { result = this.getBody().toString() }
}
