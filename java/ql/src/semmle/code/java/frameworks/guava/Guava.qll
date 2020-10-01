/**
 * Definitions for tracking taint steps throught the Guava framework.
 */

import java
private import Strings
private import Splitter
private import Joiner

/**
 * A method in the guava framework that propegates taint.
 */
abstract class GuavaTaintPropagationMethod extends Method {
  /**
   * Holds if this method propagates taint between the given source and sink.
   * `src` and `sink` are indicies of arguments to this method, or -1 to represent the qualifier.
   * `sink` can also be -2 to represent the return value.
   */
  abstract predicate propagatesTaint(int src, int sink);
}

/**
 * A method in the guava framework that returns tainted data when a specific input
 * (either an argument or the qualifier) is tainted.
 */
abstract class GuavaTaintPropagationMethodToReturn extends GuavaTaintPropagationMethod {
  /**
   * Holds if this method returns tainted data when the given source is tainted.
   * `src` is an argument index, or -1 to indicate the qualifier.
   */
  abstract predicate propagatesTaint(int src);

  override predicate propagatesTaint(int src, int sink) { propagatesTaint(src) and sink = -2 }
}
