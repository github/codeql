/**
 * Provides classes representing various flow sources for taint tracking.
 */

import go
private import semmle.go.dataflow.ExternalFlow as ExternalFlow

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
  abstract class Range extends DataFlow::Node { }

  /**
   * A source of data that is controlled by an untrusted user.
   */
  class MaDRemoteSource extends Range {
    MaDRemoteSource() { ExternalFlow::sourceNode(this, "remote") }
  }
}
