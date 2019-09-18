/**
 * Provides a class for modelling sources of remote user input.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.security.dataflow.DOM

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();

  /**
   * Holds if this can be a user-controlled object, such as a JSON object parsed from user-controlled data.
   */
  predicate isUserControlledObject() { none() }
}
