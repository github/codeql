/**
 * Provides a taint-tracking configuration for reasoning about private information flowing unencrypted to an external location.
 */

import csharp

module ExposureOfPrivateInformation {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink
  import semmle.code.csharp.security.PrivateData

  /**
   * A data flow source for private information flowing unencrypted to an external location.
   */
  abstract class Source extends DataFlow::ExprNode { }

  /**
   * A data flow sink for private information flowing unencrypted to an external location.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for private information flowing unencrypted to an external location.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for private information flowing unencrypted to an external location.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "ExposureOfPrivateInformation" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  class PrivateDataSource extends Source {
    PrivateDataSource() { this.getExpr() instanceof PrivateDataExpr }
  }

  class ExternalLocation extends Sink {
    ExternalLocation() { this instanceof ExternalLocationSink }
  }
}
