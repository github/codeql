import java

/**
 * A deployment descriptor file, typically called `struts.xml`.
 */
class StrutsXmlFile extends XMLFile {
  StrutsXmlFile() {
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "struts"
  }
}

/** DEPRECATED: Alias for StrutsXmlFile */
deprecated class StrutsXMLFile = StrutsXmlFile;

/**
 * An XML element in a `StrutsXMLFile`.
 */
class StrutsXmlElement extends XMLElement {
  StrutsXmlElement() { this.getFile() instanceof StrutsXmlFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = this.allCharactersString().trim() }
}

/** DEPRECATED: Alias for StrutsXmlElement */
deprecated class StrutsXMLElement = StrutsXmlElement;

/**
 * A `<constant>` element in a `StrutsXMLFile`.
 */
class ConstantParameter extends StrutsXmlElement {
  ConstantParameter() { this.getName() = "constant" }

  /**
   * Gets the value of the `name` attribute of this `<constant>`.
   */
  string getNameValue() { result = this.getAttributeValue("name") }

  /**
   * Gets the value of the `value` attribute of this `<constant>`.
   */
  string getValueValue() { result = this.getAttributeValue("value") }
}
