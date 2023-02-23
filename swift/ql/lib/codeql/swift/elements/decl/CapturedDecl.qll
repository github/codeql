private import codeql.swift.generated.decl.CapturedDecl

class CapturedDecl extends Generated::CapturedDecl {
  override string toString() { result = this.getDecl().toString() }
}
