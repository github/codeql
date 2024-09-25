/** Classes to represent sanitizers commonly used in dataflow and taint tracking configurations. */

import java
private import semmle.code.java.dataflow.DataFlow

/**
 * A node whose type is a simple type unlikely to carry taint, such as primitives and their boxed counterparts,
 * `java.util.UUID` and `java.util.Date`.
 */
class SimpleTypeSanitizer extends DataFlow::Node {
  SimpleTypeSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType or
    this.getType().(RefType).hasQualifiedName("java.util", "UUID") or
    this.getType().(RefType).getASourceSupertype*().hasQualifiedName("java.util", "Date") or
    this.getType().(RefType).hasQualifiedName("java.util", "Calendar") or
    this.getType().(RefType).hasQualifiedName("java.util", "BitSet") or
    this.getType()
        .(RefType)
        .getASourceSupertype*()
        .hasQualifiedName("java.time.temporal", "TemporalAmount") or
    this.getType()
        .(RefType)
        .getASourceSupertype*()
        .hasQualifiedName("java.time.temporal", "TemporalAccessor")
  }
}
