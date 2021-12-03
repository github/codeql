/** Provides classes and predicates related to Java naming conventions. */

import java

/** A field that is both `static` and `final`. */
class ConstantField extends Field {
  ConstantField() {
    this.isStatic() and
    this.isFinal()
  }
}
