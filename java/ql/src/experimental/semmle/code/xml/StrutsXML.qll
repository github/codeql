import java

/**
 * A deployment descriptor file, typically called `struts.xml`.
 */
class StrutsXMLFile extends XMLFile {
  StrutsXMLFile() {
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "struts"
  }
}

/**
 * An XML element in a `StrutsXMLFile`.
 */
class StrutsXMLElement extends XMLElement {
  StrutsXMLElement() { this.getFile() instanceof StrutsXMLFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = allCharactersString().trim() }
}

/**
 * A `<constant>` element in a `StrutsXMLFile`.
 */
class ConstantParameter extends StrutsXMLElement {
  ConstantParameter() { this.getName() = "constant" }

  /**
   * Gets the value of the `name` attribute of this `<constant>`.
   */
  string getNameValue() { result = getAttributeValue("name") }

  /**
   * Gets the value of the `value` attribute of this `<constant>`.
   */
  string getValueValue() { result = getAttributeValue("value") }
}
