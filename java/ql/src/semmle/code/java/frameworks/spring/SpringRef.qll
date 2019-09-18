import java
import semmle.code.java.frameworks.spring.SpringAbstractRef

/** A `<ref>` element in a Spring XML file. */
class SpringRef extends SpringAbstractRef {
  SpringRef() { this.getName() = "ref" }

  /** Holds if this `ref` has a `parent` attribute. */
  predicate hasBeanNameInParent() { this.hasAttribute("parent") }

  /** Gets the value of the `parent` attribute. */
  string getBeanNameInParent() { result = this.getAttributeValue("parent") }

  /** Gets the bean referred to by the `ref` element. */
  override SpringBean getBean() {
    if this.hasBeanLocalName()
    then result.getBeanId() = this.getBeanLocalName()
    else result.getBeanIdentifier() = this.getBeanName()
  }
}
