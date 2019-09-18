import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** A `<prop>` element in Spring XML files. */
class SpringProp extends SpringXMLElement {
  SpringProp() { this.getName() = "prop" }

  /** Gets the value of the `key` attribute. */
  string getKeyString() { result = this.getAttributeValue("key") }
}
