/** Classes to represent sanitizers commonly used in dataflow and taint tracking configurations. */

import java
private import semmle.code.java.dataflow.DataFlow

/**
 * A node whose type is a common scalar type, such as primitives or their boxed counterparts.
 */
class SimpleScalarSanitizer extends DataFlow::Node {
  SimpleScalarSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}
