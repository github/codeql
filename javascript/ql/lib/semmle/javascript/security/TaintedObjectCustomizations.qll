/**
 * Provides access to the "tainted object" flow label defined in `TaintedObject.qll`, without
 * materializing that flow label.
 */

import javascript

/** Provides classes and predicates for reasoning about deeply tainted objects. */
module TaintedObject {
  /** A flow label representing a deeply tainted object. */
  abstract class TaintedObjectLabel extends DataFlow::FlowLabel {
    TaintedObjectLabel() { this = "tainted-object" }
  }

  /**
   * Gets the flow label representing a deeply tainted object.
   *
   * A "tainted object" is an array or object whose property values are all assumed to be tainted as well.
   *
   * Note that the presence of the this label generally implies the presence of the `taint` label as well.
   */
  DataFlow::FlowLabel label() { result instanceof TaintedObjectLabel }

  /**
   * A source of a user-controlled deep object.
   */
  abstract class Source extends DataFlow::Node { }
}
