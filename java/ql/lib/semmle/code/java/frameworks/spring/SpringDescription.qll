import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/**
 * A `<description>` element in a Spring XML file.
 *
 * Its contents can be accessed using `SpringXMLElement.getContentString()`.
 */
class SpringDescription extends SpringXmlElement {
  SpringDescription() { this.getName() = "description" }
}
