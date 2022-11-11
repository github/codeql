private import codeql.swift.generated.UnspecifiedElement
import codeql.swift.elements.Location

class UnspecifiedElement extends Generated::UnspecifiedElement {
  override string toString() {
    exists(string source, string index |
      (
        source = " from " + this.getParent().getPrimaryQlClasses()
        or
        not this.hasParent() and source = ""
      ) and
      (
        index = "[" + this.getIndex() + "]"
        or
        not this.hasIndex() and index = ""
      ) and
      result = "missing " + this.getProperty() + index + source
    )
  }

  override Location getImmediateLocation() { result = this.getParent().(Locatable).getLocation() }
}
