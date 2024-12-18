/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in resource descriptors.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.system.Data
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for untrusted user input used in resource descriptors.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for untrusted user input used in resource descriptors.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for untrusted user input used in resource descriptors.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for untrusted user input used in resource descriptors.
 */
private module ResourceInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for untrusted user input used in resource descriptors.
 */
module ResourceInjection = TaintTracking::Global<ResourceInjectionConfig>;

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of local user input.
 */
deprecated class LocalSource extends DataFlow::Node instanceof LocalFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

/** An argument to the `ConnectionString` property on a data connection class. */
class SqlConnectionStringSink extends Sink {
  SqlConnectionStringSink() {
    this.getExpr() =
      any(SystemDataConnectionClass dataConn).getConnectionStringProperty().getAnAssignedValue()
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
