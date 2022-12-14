private import codeql.swift.generated.type.Type

class Type extends Generated::Type {
  override string toString() { result = this.getName() }
}
