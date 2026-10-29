private import codeql.swift.generated.type.TypeRepr

module Impl {
  class TypeRepr extends Generated::TypeRepr {
    override string toStringImpl() { result = this.getType().toStringImpl() }
  }
}
