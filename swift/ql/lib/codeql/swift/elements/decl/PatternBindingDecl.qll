private import codeql.swift.generated.decl.PatternBindingDecl

class PatternBindingDecl extends Generated::PatternBindingDecl {
  override string toString() { result = "var ... = ..." }
}
