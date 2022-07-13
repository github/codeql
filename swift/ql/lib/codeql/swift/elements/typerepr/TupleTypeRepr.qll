private import codeql.swift.generated.typerepr.TupleTypeRepr

class TupleTypeRepr extends TupleTypeReprBase {
  override string toString() { result = "(...)" }
}
