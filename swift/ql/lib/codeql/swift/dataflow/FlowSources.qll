/**
 * Provides classes representing various flow sources for taint tracking.
 */

private import ExternalFlow
private import internal.DataFlowPublic

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();
}

/**
 * A data flow source of remote user input that is defined through 'models as data'.
 */
private class ExternalRemoteFlowSource extends RemoteFlowSource {
  ExternalRemoteFlowSource() { sourceNode(this, "remote") }

  override string getSourceType() { result = "external" }
}
