/**
 * Provides classes representing various flow steps for taint tracking.
 */

import java

/**
 * A method that returns tainted data when one of its inputs (an argument or the qualifier) are tainted.
 *
 * Extend this class to add additional taint steps through a method that should
 * apply to all taint configurations.
 */
abstract class TaintPreservingMethod extends Method {
  /**
   * Holds if this method returns tainted data when `arg` tainted.
   * `arg` is a parameter index, or is -1 to indicate the qualifier.
   */
  abstract predicate returnsTaint(int arg);
}

/**
 * A method that transfers taint from one of its inputs (an argument or the qualifier) to another.
 *
 * Extend this class to add additional taint steps through a method that should
 * apply to all taint configurations.
 */
abstract class TaintTransferringMethod extends Method {
  /**
   * Holds if this method writes tainted data to `sink` when `src` is tainted.
   * `src` and `sink` are parameter indices, or -1 to indicate the qualifier.
   */
  abstract predicate transfersTaint(int src, int sink);
}

private class StringTaintPreservingMethod extends TaintPreservingMethod {
  StringTaintPreservingMethod() {
    getDeclaringType() instanceof TypeString and
    hasName(["concat", "copyValueOf", "endsWith", "format", "formatted", "getBytes", "indent",
          "intern", "join", "repeat", "split", "strip", "stripIndent", "stripLeading",
          "stripTrailing", "substring", "toCharArray", "toLowerCase", "toString", "toUpperCase",
          "trim"])
  }

  override predicate returnsTaint(int arg) {
    arg = -1
    or
    this.hasName(["concat", "copyValueOf"]) and arg = 0
    or
    this.hasName(["format", "formatted", "join"]) and arg = [0 .. getNumberOfParameters()]
  }
}
