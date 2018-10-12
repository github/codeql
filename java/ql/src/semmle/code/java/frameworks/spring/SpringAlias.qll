import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBean

/** An `<alias>` element in Spring XML files. */
class SpringAlias extends SpringXMLElement {
  SpringAlias() { this.getName() = "alias" }

  /** Gets the value of the `alias` attribute. */
  string getBeanAlias() { result = this.getAttributeValue("alias") }

  /** Gets the value of the `name` attribute. */
  string getBeanName() { result = this.getAttributeValue("name") }

  /** Gets the bean referred to by the alias. */
  SpringBean getBean() {
    exists(SpringBean b |
      b.getBeanIdentifier() = this.getBeanName() and
      result = b
    )
  }
}
