private import codeql.swift.generated.type.TypeRepr

class TypeRepr extends Generated::TypeRepr {
  override string toString() { result = this.getType().toString() }
}
