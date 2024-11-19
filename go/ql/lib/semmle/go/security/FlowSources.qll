/**
 * Provides classes representing various flow sources for taint tracking.
 */

import go
private import semmle.go.dataflow.ExternalFlow as ExternalFlow
private import codeql.threatmodels.ThreatModels

/**
 * DEPRECATED: Use `RemoteFlowSource` instead.
 */
deprecated class UntrustedFlowSource = RemoteFlowSource;

/**
 * A source of data that is controlled by an untrusted user.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RemoteFlowSource::Range` instead.
 */
class RemoteFlowSource extends DataFlow::Node instanceof RemoteFlowSource::Range { }

/**
 * DEPRECATED: Use `RemoteFlowSource` instead.
 */
deprecated module UntrustedFlowSource = RemoteFlowSource;

/** Provides a class for modeling new sources of untrusted data. */
module RemoteFlowSource {
  /**
   * A source of data that is controlled by an untrusted user.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RemoteFlowSource` instead.
   */
  abstract class Range extends SourceNode {
    override string getThreatModel() { result = "remote" }
  }

  /**
   * A source of data that is controlled by an untrusted user.
   */
  class MaDRemoteSource extends Range {
    MaDRemoteSource() { ExternalFlow::sourceNode(this, "remote") }
  }
}

/**
 * A data flow source.
 */
abstract class SourceNode extends DataFlow::Node {
  /**
   * Gets a string that represents the source kind with respect to threat modeling.
   */
  abstract string getThreatModel();
}

/**
 * DEPRECATED: Use `ActiveThreatModelSource` instead.
 *
 * A class of data flow sources that respects the
 * current threat model configuration.
 */
deprecated class ThreatModelFlowSource = ActiveThreatModelSource;

/**
 * A data flow source that is enabled in the current threat model configuration.
 */
class ActiveThreatModelSource extends DataFlow::Node {
  ActiveThreatModelSource() {
    exists(string kind |
      // Specific threat model.
      currentThreatModel(kind) and
      (this.(SourceNode).getThreatModel() = kind or ExternalFlow::sourceNode(this, kind))
    )
  }
}
