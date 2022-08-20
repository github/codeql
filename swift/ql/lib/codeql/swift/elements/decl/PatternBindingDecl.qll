private import codeql.swift.generated.decl.PatternBindingDecl

class PatternBindingDecl extends PatternBindingDeclBase {
  override string toString() { result = "var ... = ..." }
}
