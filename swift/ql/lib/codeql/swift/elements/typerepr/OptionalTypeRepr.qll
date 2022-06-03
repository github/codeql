private import codeql.swift.generated.typerepr.OptionalTypeRepr

class OptionalTypeRepr extends OptionalTypeReprBase {
  override string toString() { result = "...?" }
}
