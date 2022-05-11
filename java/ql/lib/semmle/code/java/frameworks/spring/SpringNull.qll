import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** A `<null>` element in Spring XML files. */
class SpringNull extends SpringXmlElement {
  SpringNull() { this.getName() = "null" }
}
