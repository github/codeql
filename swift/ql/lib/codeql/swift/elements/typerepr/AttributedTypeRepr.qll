private import codeql.swift.generated.typerepr.AttributedTypeRepr

class AttributedTypeRepr extends AttributedTypeReprBase {
  override string toString() { result = "@..." }
}
