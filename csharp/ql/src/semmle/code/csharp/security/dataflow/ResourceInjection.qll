/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in resource descriptors.
 */

import csharp

module ResourceInjection {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.security.dataflow.flowsources.Local
  import semmle.code.csharp.frameworks.system.Data
  import semmle.code.csharp.security.Sanitizers

  /**
   * A data flow source for untrusted user input used in resource descriptors.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for untrusted user input used in resource descriptors.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for untrusted user input used in resource descriptors.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for untrusted user input used in resource descriptors.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "ResourceInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /** A source of local user input. */
  class LocalSource extends Source {
    LocalSource() { this instanceof LocalFlowSource }
  }

  /** An argument to the `ConnectionString` property on a data connection class. */
  class SqlConnectionStringSink extends Sink {
    SqlConnectionStringSink() {
      this.getExpr() =
        any(SystemDataConnectionClass dataConn).getConnectionStringProperty().getAnAssignedValue()
    }
  }

  private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

  private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
}
