import java
import semmle.code.java.frameworks.spring.SpringBean

/**
 * A `RefType` (class or interface) that is referred to by
 * a class attribute in a `<bean>` element.
 */
class SpringBeanRefType extends RefType {
  SpringBeanRefType() { exists(SpringBean b | b.getClass() = this) }

  /** Gets the `<bean>` element that refers to this `RefType`. */
  SpringBean getSpringBean() { result.getClass() = this }
}
