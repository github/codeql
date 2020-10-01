/**
 * Definitions for tracking taint steps through the methods of `com.google.common.base.Strings`.
 */

import java
import Guava

/**
 * The class `com.google.common.base.Strings`.
 */
class TypeGuavaStrings extends Class {
  TypeGuavaStrings() { this.hasQualifiedName("com.google.common.base", "Strings") }
}

/**
 * A Guava string utility method that preserves taint from its first argument.
 */
private class GuavaStringsTaintPropagationMethod extends GuavaTaintPropagationMethodToReturn {
  GuavaStringsTaintPropagationMethod() {
    this.getDeclaringType() instanceof TypeGuavaStrings and
    // static String emptyToNull(String string)
    // static String emptyToNull(String string)
    // static String padEnd(String string, int minLength, char padChar)
    // static String padStart(String string, int minLength, char padChar)
    // static String repeat(String string, int count)
    this.hasName(["emptyToNull", "nullToEmpty", "padStart", "padEnd", "repeat"])
  }

  override predicate propagatesTaint(int src) { src = 0 }
}

/**
 * The method `Strings.lenientFormat`.
 */
private class GuavaStringsFormatMethod extends GuavaTaintPropagationMethodToReturn {
  GuavaStringsFormatMethod() {
    this.getDeclaringType() instanceof TypeGuavaStrings and
    // static String lenientFormat(String template, Object ... args)
    this.hasName("lenientFormat")
  }

  override predicate propagatesTaint(int src) { src in [0 .. getNumberOfParameters()] }
}
