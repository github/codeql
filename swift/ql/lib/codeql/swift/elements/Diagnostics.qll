private import codeql.swift.generated.Diagnostics

class Diagnostics extends Generated::Diagnostics {
  override string toString() { result = getText() }
}
