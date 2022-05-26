import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** A `<key>` element in Spring XML files. */
class SpringKey extends SpringXmlElement {
  SpringKey() { this.getName() = "key" }
}
