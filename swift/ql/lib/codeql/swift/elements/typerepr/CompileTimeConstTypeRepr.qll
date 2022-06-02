private import codeql.swift.generated.typerepr.CompileTimeConstTypeRepr

class CompileTimeConstTypeRepr extends CompileTimeConstTypeReprBase {
  override string toString() { result = "_const ..." }
}
