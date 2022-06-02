import java
import semmle.code.java.frameworks.spring.SpringXMLElement

/**
 * A common superclass for mergeable Spring XML elements (`list`, `map`).
 */
/*abstract*/ class SpringMergable extends SpringXmlElement {
  string getMergeRaw() { result = this.getAttributeValueWithDefault("merge") }

  /** Holds if this element is merged, taking `default-merged` values in `<beans>` into account. */
  predicate isMerged() {
    if this.getMergeRaw() != "default"
    then this.getMergeRaw() = "true"
    else this.getSpringBeanFile().isDefaultMerge()
  }
}
