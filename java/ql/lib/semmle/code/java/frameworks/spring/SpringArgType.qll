import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** An `<arg-type>` element in Spring XML files. */
class SpringArgType extends SpringXmlElement {
  SpringArgType() { this.getName() = "arg-type" }

  /** Gets the value of the `match` attribute. */
  string getMatchPattern() { result = this.getAttributeValue("match") }
}
