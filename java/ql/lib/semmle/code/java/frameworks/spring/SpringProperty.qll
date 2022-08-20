import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBean
import semmle.code.java.frameworks.spring.SpringAbstractRef
import semmle.code.java.frameworks.spring.SpringList
import semmle.code.java.frameworks.spring.SpringValue

/** A `<property>` element in Spring XML files. */
class SpringProperty extends SpringXmlElement {
  SpringProperty() { this.getName() = "property" }

  override string toString() { result = this.getPropertyName() }

  /** Gets the value of the `name` attribute. */
  string getPropertyName() { result = this.getAttributeValue("name") }

  /** Holds if this property has a `ref` attribute. */
  predicate hasPropertyRefString() { this.hasAttribute("ref") }

  /** Gets the value of the `ref` attribute. */
  string getPropertyRefString() { result = this.getAttributeValue("ref") }

  /** Gets the bean referred to by the `ref` attribute or a nested `<ref>` element. */
  SpringBean getPropertyRefBean() {
    if this.hasPropertyRefString()
    then result.getBeanIdentifier() = this.getPropertyRefString()
    else
      exists(SpringAbstractRef ref |
        ref = this.getASpringChild() and
        result = ref.getBean()
      )
  }

  /** Holds if this property has a `value` attribute. */
  predicate hasPropertyValueString() { this.hasAttribute("value") }

  /** Gets the value of the `value` attribute. */
  string getPropertyValueString() { result = this.getAttributeValue("value") }

  /**
   * Gets the value of the `value` attribute, or a nested `<value>` element,
   * whichever is present.
   */
  string getPropertyValue() {
    if this.hasPropertyValueString()
    then result = this.getPropertyValueString()
    else
      exists(SpringValue val |
        val = this.getASpringChild() and
        result = val.getContentString()
      )
  }

  /**
   * Holds if this property is similar to another property.
   * Currently only checks the property name and references to beans.
   */
  override predicate isSimilar(SpringXmlElement element) {
    exists(SpringProperty other |
      other = element and this.getPropertyName() = other.getPropertyName()
    |
      this.getPropertyRefBean() = other.getPropertyRefBean()
      or
      exists(SpringBean thisBean, SpringBean otherBean |
        thisBean = this.getASpringChild() and
        otherBean = other.getASpringChild() and
        thisBean.isSimilar(otherBean)
      )
    )
  }

  /**
   * Gets a setter method declared on this property's enclosing bean that sets this property.
   */
  Method getSetterMethod() {
    this.getEnclosingBean().getClass().hasMethod(result, _) and
    result.getName().toLowerCase() = "set" + this.getPropertyName().toLowerCase()
  }

  /**
   * Gets a setter method declared on bean `context` that sets this property.
   *
   * This property must be declared on a bean that is an ancestor of `context`.
   */
  Method getSetterMethod(SpringBean context) {
    this.getEnclosingBean() = context.getBeanParent*() and
    context.getClass().hasMethod(result, _) and
    result.getName().toLowerCase() = "set" + this.getPropertyName().toLowerCase()
  }
}
