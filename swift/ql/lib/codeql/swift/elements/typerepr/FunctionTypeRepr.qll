private import codeql.swift.generated.typerepr.FunctionTypeRepr

class FunctionTypeRepr extends FunctionTypeReprBase {
  override string toString() { result = "... -> ..." }
}
