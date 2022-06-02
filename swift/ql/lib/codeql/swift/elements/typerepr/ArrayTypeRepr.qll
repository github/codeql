private import codeql.swift.generated.typerepr.ArrayTypeRepr

class ArrayTypeRepr extends ArrayTypeReprBase {
  override string toString() { result = "[...]" }
}
