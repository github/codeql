/**
 * Provides a taint tracking configuration for reasoning about command
 * injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjection::Configuration` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint tracking configuration for reasoning about command
 * injection vulnerabilities.
 */
module CommandInjection {
  import CommandInjectionCustomizations::CommandInjection

  /**
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities
   * with sinks which are not sanitized by `--`.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "CommandInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) {
      exists(Sink s | sink = s | not s.doubleDashIsSanitizing())
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }

  private class ArgumentArrayWithDoubleDash extends DataFlow::Node {
    int doubleDashIndex;

    ArgumentArrayWithDoubleDash() {
      // Call whose argument list contains a "--"
      exists(DataFlow::CallNode c |
        this = c and
        (c = Builtin::append().getACall() or c = any(SystemCommandExecution sce)) and
        c.getArgument(doubleDashIndex).getStringValue() = "--"
      )
      or
      // array/slice literal containing a "--"
      exists(ArrayOrSliceLit litExpr |
        this = DataFlow::exprNode(litExpr) and
        litExpr.getElement(doubleDashIndex).getStringValue() = "--"
      )
      or
      // call consuming an existing an array with a "--"
      exists(ArgumentArrayWithDoubleDash alreadyHasDoubleDash, DataFlow::CallNode userCall |
        (
          alreadyHasDoubleDash.getType().getUnderlyingType() instanceof ArrayType or
          alreadyHasDoubleDash.getType() instanceof SliceType
        ) and
        this = userCall and
        DataFlow::localFlow(alreadyHasDoubleDash, userCall.getArgument(doubleDashIndex))
      )
    }

    DataFlow::Node getASanitizedElement() {
      exists(int sanitizedIndex |
        sanitizedIndex > doubleDashIndex and
        (
          result = this.(DataFlow::CallNode).getArgument(sanitizedIndex) or
          result = DataFlow::exprNode(this.asExpr().(ArrayOrSliceLit).getElement(sanitizedIndex))
        )
      )
    }
  }

  /**
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities
   * with sinks which are sanitized by `--`.
   */
  class DoubleDashSanitizingConfiguration extends TaintTracking::Configuration {
    DoubleDashSanitizingConfiguration() { this = "CommandInjectionWithDoubleDashSanitizer" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) {
      exists(Sink s | sink = s | s.doubleDashIsSanitizing())
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer or
      node = any(ArgumentArrayWithDoubleDash array).getASanitizedElement()
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
