/**
 * DEPRECATED: The logic is now incorporated into the
 * cs/cleartext-storage-of-sensitive-information query.
 *
 * Provides a taint-tracking configuration for reasoning about private information flowing unencrypted to an external location.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink
private import semmle.code.csharp.security.PrivateData

/**
 * A data flow source for private information flowing unencrypted to an external location.
 */
abstract deprecated class Source extends DataFlow::ExprNode { }

/**
 * A data flow sink for private information flowing unencrypted to an external location.
 */
abstract deprecated class Sink extends DataFlow::ExprNode { }

/**
 * A sanitizer for private information flowing unencrypted to an external location.
 */
abstract deprecated class Sanitizer extends DataFlow::ExprNode { }

/**
 * DEPRECATED: Use `ExposureOfPrivateInformation` instead.
 *
 * A taint-tracking configuration for private information flowing unencrypted to an external location.
 */
deprecated class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "ExposureOfPrivateInformation" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking configuration for private information flowing unencrypted to an external location.
 */
deprecated private module ExposureOfPrivateInformationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for private information flowing unencrypted to an external location.
 */
deprecated module ExposureOfPrivateInformation =
  TaintTracking::Global<ExposureOfPrivateInformationConfig>;

deprecated private class PrivateDataSource extends Source {
  PrivateDataSource() { this.getExpr() instanceof PrivateDataExpr }
}

deprecated private class ExternalLocation extends Sink instanceof ExternalLocationSink { }
