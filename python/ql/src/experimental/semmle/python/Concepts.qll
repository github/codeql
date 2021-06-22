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

/** Provides classes for modeling XML parsing APIs. */
module XMLParsing {
  /**
   * A data-flow node that collects functions parsing XML.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `XMLParsing` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the content to parse.
     */
    abstract DataFlow::Node getAnInput();

    /**
     * Holds if the parser may be parsing the input dangerously.
     */
    abstract predicate mayBeDangerous();
  }
}

/**
 * A data-flow node that collects functions setting HTTP Headers' content.
 *
 * Extend this class to model new APIs. If you want to refine existing API models,
 * extend `XMLParsing` instead.
 */
class XMLParsing extends DataFlow::Node {
  XMLParsing::Range range;

  XMLParsing() { this = range }

  /**
   * Gets the argument containing the content to parse.
   */
  DataFlow::Node getAnInput() { result = range.getAnInput() }

  /**
   * Holds if the parser may be parsing the input dangerously.
   */
  predicate mayBeDangerous() { range.mayBeDangerous() }
}
