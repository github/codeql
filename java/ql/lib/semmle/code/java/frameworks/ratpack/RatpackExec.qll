/**
 * Provides classes and predicates related to `ratpack.exec.*`.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/** A reference type that extends a parameterization the Promise type. */
private class RatpackPromise extends RefType {
  RatpackPromise() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("ratpack.exec", "Promise")
  }
}

/**
 * Ratpack `Promise` method that will return `this`.
 */
private class RatpackPromiseFluentMethod extends FluentMethod {
  RatpackPromiseFluentMethod() {
    not this.isStatic() and
    // It's generally safe to assume that if the return type exactly matches the declaring type, `this` will be returned.
    exists(ParameterizedType t |
      t instanceof RatpackPromise and
      t = this.getDeclaringType() and
      t = this.getReturnType()
    )
  }
}
