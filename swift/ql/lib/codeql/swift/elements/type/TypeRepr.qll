private import codeql.swift.generated.type.TypeRepr

class TypeRepr extends TypeReprBase {
  override string toString() { result = getType().toString() }
}
