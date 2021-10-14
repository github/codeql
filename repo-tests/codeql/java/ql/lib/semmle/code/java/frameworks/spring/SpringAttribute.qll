import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** An `<attribute>` element in Spring XML files. */
class SpringAttribute extends SpringXMLElement {
  SpringAttribute() { this.getName() = "attribute" }

  /** Gets the value of the `key` attribute. */
  string getKeyString() { result = this.getAttributeValue("key") }

  /** Gets the value of the `value` attribute. */
  string getValueString() { result = this.getAttributeValue("value") }
}
