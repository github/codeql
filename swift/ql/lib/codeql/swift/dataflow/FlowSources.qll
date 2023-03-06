/**
 * Provides classes representing various flow sources for taint tracking.
 */

private import ExternalFlow
private import internal.DataFlowPublic

/**
 * A data flow source of user input, whether local or remote.
 */
abstract class FlowSource extends Node {
  /** Gets a string that describes the type of this flow source. */
  abstract string getSourceType();
}

/**
 * A data flow source of local user input, that is, user input from the same
 * device as the code is running on.
 */
abstract class LocalFlowSource extends FlowSource { }

/**
 * A data flow source of remote user input. In this context, 'remote' means
 * either across a network or from another application that is not trusted.
 */
abstract class RemoteFlowSource extends FlowSource { }

/**
 * A data flow source of local user input that is defined through 'models as data'.
 */
private class ExternalLocalFlowSource extends LocalFlowSource {
  ExternalLocalFlowSource() { sourceNode(this, "local") }

  override string getSourceType() { result = "external" }
}

/**
 * A data flow source of remote user input that is defined through 'models as data'.
 */
private class ExternalRemoteFlowSource extends RemoteFlowSource {
  ExternalRemoteFlowSource() { sourceNode(this, "remote") }

  override string getSourceType() { result = "external" }
}
