import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBean

/** A `<replaced-method>` element in a Spring XML file. */
class SpringReplacedMethod extends SpringXMLElement {
  SpringReplacedMethod() { this.getName() = "replaced-method" }

  /** Gets the value of the `name` attribute. */
  string getMethodName() { result = this.getAttributeValue("name") }

  /** Gets the value of the `replacer` attribute. */
  string getReplacerBeanName() { result = this.getAttributeValue("replacer") }

  /** Gets the bean referred to by the `replacer` attribute. */
  SpringBean getReplacerBean() { result.getBeanIdentifier() = this.getReplacerBeanName() }
}
