private import codeql.swift.generated.typerepr.DictionaryTypeRepr

class DictionaryTypeRepr extends DictionaryTypeReprBase {
  override string toString() { result = "[... : ...]" }
}
