/**
 * Provides a taint-tracking configuration for reasoning about command injection vulnerabilities.
 */

import csharp

module CommandInjection {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.system.Diagnostics
  import semmle.code.csharp.security.Sanitizers

  /**
   * A source specific to command injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A sink for command injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for user input treated as code vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for command injection vulnerabilities.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "CommandInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A sink in `System.Diagnostic.Process` or its related classes.
   */
  class SystemProcessCommandInjectionSink extends Sink {
    SystemProcessCommandInjectionSink() {
      // Arguments passed directly to the `System.Diagnostics.Process.Start` method
      exists(SystemDiagnosticsProcessClass processClass |
        this.getExpr() = processClass.getAStartMethod().getAParameter().getAnAssignedArgument()
      )
      or
      // Values set on a `System.Diagnostics.ProcessStartInfo` class
      exists(SystemDiagnosticsProcessStartInfoClass startInfoClass |
        this.getExpr() = startInfoClass.getAConstructor().getACall().getAnArgument()
        or
        exists(Property p |
          p = startInfoClass.getArgumentsProperty() or
          p = startInfoClass.getFileNameProperty() or
          p = startInfoClass.getWorkingDirectoryProperty()
        |
          this.getExpr() = p.getSetter().getParameter(0).getAnAssignedArgument()
        )
      )
    }
  }

  private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

  private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
}
