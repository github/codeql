private import codeql.swift.generated.typerepr.InOutTypeRepr

class InOutTypeRepr extends InOutTypeReprBase {
  override string toString() { result = "inout ..." }
}
