private import codeql.swift.generated.type.TypeRepr

module Impl {
  class TypeRepr extends Generated::TypeRepr {
    override string toString() { result = this.getType().toString() }
  }
}
