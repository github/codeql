import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** A `<meta>` element in Spring XML files. */
class SpringMeta extends SpringXMLElement {
  SpringMeta() { this.getName() = "meta" }

  /** Gets the value of the `key` attribute. */
  string getMetaKey() { result = this.getAttributeValue("key") }

  /** Gets the value of the `value` attribute. */
  string getMetaValue() { result = this.getAttributeValue("value") }
}
