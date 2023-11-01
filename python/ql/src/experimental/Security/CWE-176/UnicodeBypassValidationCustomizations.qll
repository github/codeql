/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Unicode transformation"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Unicode transformation"
 * vulnerabilities, as well as extension points for adding your own.
 */
module UnicodeBypassValidation {
  /**
   * A data flow source for "Unicode transformation" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "Unicode transformation" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "Unicode transformation" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }
}
