private import codeql.swift.generated.Element

class Element extends Generated::Element {
  override string toString() { result = this.getPrimaryQlClasses() }
}

class UnknownElement extends Element {
  UnknownElement() { this.isUnknown() }
}
