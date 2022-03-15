import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** A `<value>` element in a Spring XML file. */
class SpringValue extends SpringXmlElement {
  SpringValue() { this.getName() = "value" }

  /** Gets the value of the `type` attribute. */
  string getTypeName() { result = this.getAttributeValue("type") }

  /** Gets the Java `RefType` (class or interface) referred to by the `type` attribute. */
  RefType getType() { result.getQualifiedName() = this.getTypeName() }
}
