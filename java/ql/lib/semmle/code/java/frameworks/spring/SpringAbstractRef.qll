import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBean

/** A common supertype of `SpringRef` and `SpringIdRef`. */
class SpringAbstractRef extends SpringXmlElement {
  SpringAbstractRef() {
    this.getName() = "idref" or
    this.getName() = "ref"
  }

  /** Holds if this reference has a bean attribute. */
  predicate hasBeanName() { this.hasAttribute("bean") }

  /** Gets the value of the bean attribute. */
  string getBeanName() { result = this.getAttributeValue("bean") }

  /** Holds if this reference has a local attribute. */
  predicate hasBeanLocalName() { this.hasAttribute("local") }

  /** Gets the value of the local attribute. */
  string getBeanLocalName() { result = this.getAttributeValue("local") }

  /** Gets the bean pointed to by this reference. */
  SpringBean getBean() {
    if this.hasBeanLocalName()
    then result.getBeanId() = this.getBeanLocalName()
    else result.getBeanIdentifier() = this.getBeanName()
  }

  /** Holds if `other` is also a reference and points to the same bean as this reference. */
  override predicate isSimilar(SpringXmlElement other) {
    exists(SpringAbstractRef otherRef |
      otherRef = other and
      this.getBean() = otherRef.getBean()
    )
  }
}
