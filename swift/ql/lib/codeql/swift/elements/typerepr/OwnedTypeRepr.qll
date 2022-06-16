private import codeql.swift.generated.typerepr.OwnedTypeRepr

class OwnedTypeRepr extends OwnedTypeReprBase {
  override string toString() { result = "owned ..." }
}
