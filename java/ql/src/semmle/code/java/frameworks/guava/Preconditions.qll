/** Definitions of flow steps through the Preconditions class in the Guava framework. */

import java
private import semmle.code.java.dataflow.FlowSteps

/**
 * The class `com.google.common.base.Preconditions`.
 */
class TypeGuavaPreconditions extends Class {
  TypeGuavaPreconditions() { this.hasQualifiedName("com.google.common.base", "Preconditions") }
}

/**
 * A method that returns its argumnets.
 */
private class GuavaPreconditionsMethod extends TaintPreservingCallable {
  GuavaPreconditionsMethod() {
    this.getDeclaringType() instanceof TypeGuavaPreconditions and
    this.hasName("checkNotNull")
  }

  override predicate returnsTaintFrom(int src) { src = 0 }
}
