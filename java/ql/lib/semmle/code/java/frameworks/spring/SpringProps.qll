import java
import semmle.code.java.frameworks.spring.SpringMergable

/** A `<props>` element in a Spring XML file. */
class SpringProps extends SpringMergable {
  SpringProps() { this.getName() = "props" }
}
