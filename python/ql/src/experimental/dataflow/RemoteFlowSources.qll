private import python
private import experimental.dataflow.DataFlow
// Need to import since frameworks can extend `RemoteFlowSource::Range`
private import experimental.semmle.python.Frameworks
private import experimental.semmle.python.Concepts

/**
 * A data flow source of remote user input.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RemoteFlowSource::Range` instead.
 */
class RemoteFlowSource extends DataFlow::Node {
  RemoteFlowSource::Range self;

  RemoteFlowSource() { this = self }

  /** Gets a string that describes the type of this remote flow source. */
  string getSourceType() { result = self.getSourceType() }
}

/** Provides a class for modeling new sources of remote user input. */
module RemoteFlowSource {
  /**
   * A data flow source of remote user input.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RemoteFlowSource` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets a string that describes the type of this remote flow source. */
    abstract string getSourceType();
  }
}
