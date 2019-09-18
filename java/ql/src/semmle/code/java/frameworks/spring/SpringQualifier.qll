import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/** A `<qualifier>` element in a Spring XML file. */
class SpringQualifier extends SpringXMLElement {
  SpringQualifier() { this.getName() = "qualifier" }

  /** Gets the name of the Java class of this qualifier. */
  string getQualifierTypeName() {
    if this.hasAttribute("type")
    then result = this.getAttributeValue("type")
    else result = "org.springframework.beans.factory.annotation.Qualifier"
  }

  /** Holds if this qualifier has a `value` attribute. */
  predicate hasQualifierValue() { this.hasAttribute("value") }

  /** Gets the value of the `value` attribute. */
  string getQualifierValue() { result = this.getAttributeValue("value") }
}
