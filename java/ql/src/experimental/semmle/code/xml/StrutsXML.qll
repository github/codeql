deprecated module;

import java

/**
 * A deployment descriptor file, typically called `struts.xml`.
 */
class StrutsXmlFile extends XmlFile {
  StrutsXmlFile() {
    count(XmlElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "struts"
  }
}

/**
 * An XML element in a `StrutsXMLFile`.
 */
class StrutsXmlElement extends XmlElement {
  StrutsXmlElement() { this.getFile() instanceof StrutsXmlFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = this.allCharactersString().trim() }
}

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
