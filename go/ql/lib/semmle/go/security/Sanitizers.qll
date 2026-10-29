/**
 * Classes to represent sanitizers commonly used in dataflow and taint tracking
 * configurations.
 */

import go

/**
 * A node whose type is a simple type unlikely to carry taint, such as a
 * numeric or boolean type.
 */
class SimpleTypeSanitizer extends DataFlow::Node {
  SimpleTypeSanitizer() {
    this.getType() instanceof NumericType or this.getType() instanceof BoolType
  }
}
