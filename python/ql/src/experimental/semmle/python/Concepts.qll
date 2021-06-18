/**
 * This version resides in the experimental area and provides a space for
 * external contributors to place new concepts, keeping to our preferred
 * structure while remaining in the experimental area.
 *
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import experimental.semmle.python.Frameworks

/** Provides classes for modeling HTTP Header APIs. */
module HeaderDeclaration {
  /**
   * A data-flow node that collects functions setting HTTP Headers' content.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `HeaderDeclaration` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the header value.
     */
    abstract DataFlow::Node getHeaderInput();
  }
}

/**
 * A data-flow node that collects functions setting HTTP Headers' content.
 *
 * Extend this class to model new APIs. If you want to refine existing API models,
 * extend `HeaderDeclaration` instead.
 */
class HeaderDeclaration extends DataFlow::Node {
  HeaderDeclaration::Range range;

  HeaderDeclaration() { this = range }

  /**
   * Gets the argument containing the header value.
   */
  DataFlow::Node getHeaderInput() { result = range.getHeaderInput() }
}
