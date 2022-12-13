/**
 * Provides an extension point for for modeling user-controlled data.
 * Such data is often used as data-flow sources in security queries.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
// Need to import since frameworks can extend `LocalFlowSource::Range`
private import semmle.python.Frameworks
private import semmle.python.Concepts

/**
 * A data flow source of local user input.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LocalFlowSource::Range` instead.
 */
class LocalFlowSource extends DataFlow::Node {
  LocalFlowSource::Range self;

  LocalFlowSource() { this = self }

  /** Gets a string that describes the type of this local flow source. */
  string getSourceType() { result = self.getSourceType() }
}

/** Provides a class for modeling new sources of local user input. */
module LocalFlowSource {
  /**
   * A data flow source of local user input.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LocalFlowSource` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets a string that describes the type of this local flow source. */
    abstract string getSourceType();
  }
}
