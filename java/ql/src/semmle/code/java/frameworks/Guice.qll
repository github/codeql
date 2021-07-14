/**
 * Provides classes and predicates for working with the Guice framework.
 */

import java
import semmle.code.java.dataflow.FlowSteps

/**
 * A `@com.google.inject.servlet.RequestParameters` annotation.
 */
class GuiceRequestParametersAnnotation extends Annotation {
  GuiceRequestParametersAnnotation() {
    this.getType().hasQualifiedName("com.google.inject.servlet", "RequestParameters")
  }
}

/**
 * The interface `com.google.inject.Provider`.
 */
class GuiceProvider extends Interface {
  GuiceProvider() { this.hasQualifiedName("com.google.inject", "Provider") }

  /**
   * The method named `get` declared on the interface `com.google.inject.Provider`.
   */
  Method getGetMethod() {
    result.getDeclaringType() = this and result.getName() = "get" and result.hasNoParameters()
  }

  /**
   * A method that overrides the `get` method on the interface `com.google.inject.Provider`.
   */
  Method getAnOverridingGetMethod() {
    exists(Method m | m.getSourceDeclaration() = getGetMethod() | result.overrides*(m))
  }
}

private class OverridingGetMethod extends TaintPreservingCallable {
  OverridingGetMethod() { this = any(GuiceProvider gp).getAnOverridingGetMethod() }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}
