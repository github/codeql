/**
 * Provides an extension point for modeling user-controlled data.
 * Such data is often used as data-flow sources in security queries.
 */

private import semmle.code.powershell.dataflow.internal.DataFlowPublic as DataFlow
// Need to import since frameworks can extend `RemoteFlowSource::Range`
private import semmle.code.powershell.Frameworks
private import semmle.code.powershell.dataflow.flowsources.FlowSources

/**
 * A data flow source of remote user input.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RemoteFlowSource::Range` instead.
 */
class RemoteFlowSource extends SourceNode instanceof RemoteFlowSource::Range {
  override string getSourceType() { result = "remote flow source" }

  override string getThreatModel() { result = "remote" }
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

private class ExternalRemoteFlowSource extends RemoteFlowSource::Range {
  ExternalRemoteFlowSource() { this = ModelOutput::getASourceNode("remote", _).asSource() }

  override string getSourceType() { result = "remote flow" }
}
