private import codeql.swift.generated.Element

class Element extends ElementBase {
  override string toString() { result = getPrimaryQlClasses() }
}

class UnknownElement extends Element {
  UnknownElement() { isUnknown() }

  override string toString() { result = "TBD (" + getPrimaryQlClasses() + ")" }
}
