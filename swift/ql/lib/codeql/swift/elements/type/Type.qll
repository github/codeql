private import codeql.swift.generated.type.Type

class Type extends TypeBase {
  override string toString() { result = this.getName() }
}
