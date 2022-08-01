private import codeql.swift.generated.type.Type

class Type extends TypeBase {
  override string toString() { result = this.getDiagnosticsName() }

  string getName() { result = this.getDiagnosticsName() }
}
