/**
 * Definitions for tracking taint steps through the methods of `com.google.common.base.Strings`.
 */

import java
import semmle.code.java.dataflow.FlowSteps

/**
 * The class `com.google.common.base.Strings`.
 */
class TypeGuavaStrings extends Class {
  TypeGuavaStrings() { this.hasQualifiedName("com.google.common.base", "Strings") }
}

/**
 * A Guava string utility method that preserves taint.
 */
private class GuavaStringsTaintPreservingMethod extends TaintPreservingCallable {
  GuavaStringsTaintPreservingMethod() {
    this.getDeclaringType() instanceof TypeGuavaStrings and
    // static String emptyToNull(String string)
    // static String emptyToNull(String string)
    // static String padEnd(String string, int minLength, char padChar)
    // static String padStart(String string, int minLength, char padChar)
    // static String repeat(String string, int count)
    // static String lenientFormat(String template, Object ... args)
    this.hasName(["emptyToNull", "nullToEmpty", "padStart", "padEnd", "repeat", "lenientFormat"])
  }

  override predicate returnsTaintFrom(int src) {
    src = 0
    or
    this.hasName("lenientFormat") and
    src = [0 .. getNumberOfParameters()]
  }
}
