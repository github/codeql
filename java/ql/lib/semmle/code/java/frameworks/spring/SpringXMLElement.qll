import java
import semmle.code.java.frameworks.spring.SpringBeanFile
import semmle.code.java.frameworks.spring.SpringBean

/** A common superclass for all Spring XML elements. */
class SpringXmlElement extends XmlElement {
  SpringXmlElement() { this.getFile() instanceof SpringBeanFile }

  /** Gets a child of this Spring XML element. */
  SpringXmlElement getASpringChild() { result = this.getAChild() }

  /** Gets the bean file of this XML element. */
  SpringBeanFile getSpringBeanFile() { result = this.getFile() }

  /**
   * Gets the value of the attribute with name `attributeName`, or "default" if the
   * attribute is not present.
   */
  string getAttributeValueWithDefault(string attributeName) {
    this.hasAttribute(attributeName) and
    if exists(this.getAttribute(attributeName))
    then result = this.getAttributeValue(attributeName)
    else result = "default"
  }

  /** Gets the closest enclosing `<bean>` element. */
  SpringBean getEnclosingBean() {
    if this instanceof SpringBean
    then result = this
    else result = this.getParent().(SpringXmlElement).getEnclosingBean()
  }

  /**
   * Overridden by subclasses. Used to match `value`, `property` and `ref` elements for similarity.
   */
  predicate isSimilar(SpringXmlElement other) { none() }

  string getContentString() { result = this.allCharactersString() }
}
