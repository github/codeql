import java
import semmle.code.java.frameworks.spring.SpringListOrSet

/** A `<list>` element in Spring XML files. */
class SpringList extends SpringListOrSet {
  SpringList() { this.getName() = "list" }
}
