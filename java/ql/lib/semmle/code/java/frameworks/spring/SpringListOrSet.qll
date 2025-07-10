import java
import semmle.code.java.frameworks.spring.SpringMergable

/**
 * A common superclass of `SpringList` and `SpringSet`, which represent `<list>` and `<set>`
 * elements in Spring XML files.
 */
class SpringListOrSet extends SpringMergable {
  SpringListOrSet() {
    this.getName() = "list" or
    this.getName() = "set"
  }

  /** Gets the value of the `value-type` attribute. */
  string getValueTypeName() { result = this.getAttributeValue("value-type") }

  /** Gets the Java `RefType` (class or interface) that corresponds to the `value-type` attribute. */
  RefType getValueType() { result.getQualifiedName() = this.getValueTypeName() }
}
