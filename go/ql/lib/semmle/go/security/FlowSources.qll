/**
 * Provides classes representing various flow sources for taint tracking.
 */

import go
private import semmle.go.dataflow.ExternalFlow as ExternalFlow

/**
 * A source of data that is controlled by an untrusted user.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `UntrustedFlowSource::Range` instead.
 */
class UntrustedFlowSource extends DataFlow::Node {
  UntrustedFlowSource::Range self;

  UntrustedFlowSource() { this = self }
}

/** Provides a class for modeling new sources of untrusted data. */
module UntrustedFlowSource {
  /**
   * A source of data that is controlled by an untrusted user.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `UntrustedFlowSource` instead.
   */
  abstract class Range extends DataFlow::Node { }

  class CsvRemoteSource extends Range {
    CsvRemoteSource() { ExternalFlow::sourceNode(this, "remote") }
  }
}
