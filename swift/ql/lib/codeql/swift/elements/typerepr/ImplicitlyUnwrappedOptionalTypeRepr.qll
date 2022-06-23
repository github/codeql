private import codeql.swift.generated.typerepr.ImplicitlyUnwrappedOptionalTypeRepr

class ImplicitlyUnwrappedOptionalTypeRepr extends ImplicitlyUnwrappedOptionalTypeReprBase {
  override string toString() { result = "...!" }
}
