import java
import semmle.code.java.frameworks.spring.SpringMergable

/** A `<map>` element in Spring XML files. */
class SpringMap extends SpringMergable {
  SpringMap() { this.getName() = "map" }

  /** Gets the value of the `key-type` attribute. */
  string getKeyTypeName() { result = this.getAttributeValue("key-type") }

  /** Gets the Java `RefType` (class or interface) that is referred to by the `key-type` attribute. */
  RefType getKeyType() { result.getQualifiedName() = this.getKeyTypeName() }

  /** Gets the value of the `value-type` attribute. */
  string getValueTypeName() { result = this.getAttributeValue("value-type") }

  /** Gets the Java `RefType` (class or interface) that is referred to by the `value-type` attribute. */
  RefType getValueType() { result.getQualifiedName() = this.getValueTypeName() }
}
