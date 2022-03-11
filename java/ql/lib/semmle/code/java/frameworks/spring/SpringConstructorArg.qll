import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBean
import semmle.code.java.frameworks.spring.SpringAbstractRef
import semmle.code.java.frameworks.spring.SpringValue

/** A `<constructor-arg>` element in a Spring XML file. */
class SpringConstructorArg extends SpringXmlElement {
  SpringConstructorArg() { this.getName() = "constructor-arg" }

  /** Holds if this `constructor-arg` element has an `index` attribute. */
  predicate hasArgIndex() { this.hasAttribute("index") }

  /** Gets the value of the `index` attribute. */
  string getArgIndex() { result = this.getAttributeValue("index") }

  /** Holds if the `constructor-arg` has a `ref` attribute. */
  predicate hasArgRefString() { this.hasAttribute("ref") }

  /** Gets the value of the `ref` attribute. */
  string getArgRefString() { result = this.getAttributeValue("ref") }

  /**
   * Gets the bean pointed to by the `ref` attribute or a child `<ref>` or `<idref>` element.
   */
  SpringBean getArgRefBean() {
    if this.hasArgRefString()
    then result.getBeanIdentifier() = this.getArgRefString()
    else exists(SpringAbstractRef ref | ref = this.getAChild() and result = ref.getBean())
  }

  /** Holds if the `constructor-arg` has a `type` attribute. */
  predicate hasArgTypeName() { this.hasAttribute("type") }

  /** Gets the value of the `type` attribute. */
  string getArgTypeName() { result = this.getAttributeValue("type") }

  /** Gets the Java `RefType` (class or interface) that the `type` attribute refers to. */
  RefType getArgType() { result.getQualifiedName() = this.getArgTypeName() }

  /** Holds if the `constructor-arg` has a `value` attribute. */
  predicate hasArgValueString() { this.hasAttribute("value") }

  /**
   * Gets the value of the `value` attribute.
   *
   * Note that this does not take into consideration any
   * nested `<value>` elements. (See also `getArgValue()`.)
   */
  string getArgValueString() { result = this.getAttributeValue("value") }

  /**
   * Gets the value of the `value` attribute, or the content of a child `<value>`
   * element, whichever is present.
   */
  string getArgValue() {
    if this.hasArgValueString()
    then result = this.getArgValueString()
    else exists(SpringValue val | this.getAChild() = val and result = val.getContentString())
  }

  /**
   * Holds if a `constructor-arg` conflicts with another `constructor-arg`.
   *
   * Used to check overriding in inheritance.
   */
  predicate conflictsWithArg(SpringConstructorArg other) {
    this.getArgIndex() = other.getArgIndex()
    or
    this.getArgTypeName() = other.getArgTypeName() and
    (not this.hasArgIndex() or not other.hasArgIndex())
  }
}
