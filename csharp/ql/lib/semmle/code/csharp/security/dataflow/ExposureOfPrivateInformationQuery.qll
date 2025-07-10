/**
 * Provides a taint-tracking configuration for reasoning about private information flowing unencrypted to an external location.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink
private import semmle.code.csharp.security.PrivateData

/**
 * A data flow source for private information flowing unencrypted to an external location.
 */
abstract class Source extends DataFlow::ExprNode { }

/**
 * A data flow sink for private information flowing unencrypted to an external location.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for private information flowing unencrypted to an external location.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for private information flowing unencrypted to an external location.
 */
private module ExposureOfPrivateInformationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for private information flowing unencrypted to an external location.
 */
module ExposureOfPrivateInformation = TaintTracking::Global<ExposureOfPrivateInformationConfig>;

private class PrivateDataSource extends Source {
  PrivateDataSource() { this.getExpr() instanceof PrivateDataExpr }
}

private class ExternalLocation extends Sink instanceof ExternalLocationSink { }
