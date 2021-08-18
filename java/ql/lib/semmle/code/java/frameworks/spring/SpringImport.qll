import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** An `<import>` element in a Spring XML file. */
class SpringImport extends SpringXMLElement {
  SpringImport() { this.getName() = "import" }

  /** Gets the value of the `resource` attribute. */
  string getResourceString() { result = this.getAttributeValue("resource") }
}
