import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBean
import semmle.code.java.frameworks.spring.SpringAbstractRef
import semmle.code.java.frameworks.spring.SpringKey
import semmle.code.java.frameworks.spring.SpringValue

/** An `<entry>` element in Spring XML files. */
class SpringEntry extends SpringXmlElement {
  SpringEntry() { this.getName() = "entry" }

  /** Holds if this `entry` has a `key` attribute. */
  predicate hasKeyString() { this.hasAttribute("key") }

  /** Gets the value of the `key` attribute. */
  string getKeyString() { result = this.getAttributeValue("key") }

  /** Holds if this `entry` has a `key-ref` attribute. */
  predicate hasKeyRefString() { this.hasAttribute("key-ref") }

  /** Gets the value of `key-ref` attribute. */
  string getKeyRefString() { result = this.getAttributeValue("key-ref") }

  /**
   * Gets the bean pointed to by the `key-ref` attribute, or a nested
   * `<ref>` or `<idref>` element.
   */
  SpringBean getKeyRefBean() {
    if this.hasKeyRefString()
    then result.getBeanIdentifier() = this.getKeyRefString()
    else
      exists(SpringKey key, SpringAbstractRef ref |
        key = this.getASpringChild() and
        ref = key.getASpringChild() and
        result = ref.getBean()
      )
  }

  /** Holds if this `entry` has a `value` attribute. */
  predicate hasValueStringRaw() { this.hasAttribute("value") }

  /** Gets the value of the `value` attribute. */
  string getValueStringRaw() { result = this.getAttributeValue("value") }

  /**
   * Gets the value of the `value` attribute, or a nested `<value>` element, whichever
   * is present.
   */
  string getValueString() {
    if this.hasValueStringRaw()
    then result = this.getValueStringRaw()
    else
      exists(SpringValue val |
        val = this.getASpringChild() and
        result = val.getContentString()
      )
  }

  /** Holds if this `entry` has a `value-ref` attribute. */
  predicate hasValueRefString() { this.hasAttribute("value-ref") }

  /** Gets the value of the `value-ref` attribute. */
  string getValueRefString() { result = this.getAttributeValue("value-ref") }

  /**
   * Gets the bean pointed to by either the `value-ref` attribute, or a nested
   * `<ref> or `<idref>` element, whichever is present.
   */
  SpringBean getValueRefBean() {
    if this.hasValueRefString()
    then result.getBeanIdentifier() = this.getValueRefString()
    else
      exists(SpringAbstractRef ref |
        ref = this.getASpringChild() and
        result = ref.getBean()
      )
  }
}
