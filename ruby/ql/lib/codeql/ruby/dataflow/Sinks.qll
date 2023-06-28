/**
 * Provides an extension point for modeling sinks.
 */

private import codeql.ruby.dataflow.internal.DataFlowPublic as DataFlow
// Need to import since frameworks can extend `AdditionalSink::Range`
private import codeql.ruby.Frameworks

/**
 * A data flow sink.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `AdditionalSink::Range` instead.
 */
class AdditionalSink extends DataFlow::Node instanceof AdditionalSink::Range {
  /** Gets a string that describes the type of this sink. */
  string getSinkType() { result = super.getSinkType() }
}

/** Provides a class for modeling new sources of remote user input. */
module AdditionalSink {
  /**
   * A data flow sink.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `AdditionalSink` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets a string that describes the type of this sink. */
    abstract string getSinkType();
  }
}
