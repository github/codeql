import java
import semmle.code.java.frameworks.spring.SpringAbstractRef

/** An `<idref>` element in a Spring XML file. */
class SpringIdRef extends SpringAbstractRef {
  SpringIdRef() { this.getName() = "idref" }
}
