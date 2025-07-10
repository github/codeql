import java
import semmle.code.java.frameworks.spring.SpringListOrSet

/** A `<set>` element in a Spring XML file. */
class SpringSet extends SpringListOrSet {
  SpringSet() { this.getName() = "set" }
}
