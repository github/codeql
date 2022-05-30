private import codeql.swift.generated.decl.PrecedenceGroupDecl

class PrecedenceGroupDecl extends PrecedenceGroupDeclBase {
  override string toString() {
    result = "precedencegroup ..." // TODO: Once we extract the name we can improve this.
  }
}
