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

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) {
      exists(Sink s | sink = s | not s.doubleDashIsSanitizing())
    }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /**
   * Tracks taint flow for reasoning about command-injection vulnerabilities
   * with sinks which are not sanitized by `--`.
   */
  module Flow = TaintTracking::Global<Config>;

  private class ArgumentArrayWithDoubleDash extends DataFlow::Node {
    int doubleDashIndex;

    ArgumentArrayWithDoubleDash() {
      // Call whose argument list contains a "--"
      exists(DataFlow::CallNode c |
        this = c and
        (c = Builtin::append().getACall() or c = any(SystemCommandExecution sce)) and
        c.getSyntacticArgument(doubleDashIndex).getStringValue() = "--"
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
        DataFlow::localFlow(alreadyHasDoubleDash, userCall.getSyntacticArgument(doubleDashIndex))
      )
    }

    DataFlow::Node getASanitizedElement() {
      exists(int sanitizedIndex |
        sanitizedIndex > doubleDashIndex and
        (
          result = this.(DataFlow::CallNode).getSyntacticArgument(sanitizedIndex) or
          result = DataFlow::exprNode(this.asExpr().(ArrayOrSliceLit).getElement(sanitizedIndex))
        )
      )
    }
  }

  private module DoubleDashSanitizingConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { exists(Sink s | sink = s | s.doubleDashIsSanitizing()) }

    predicate isBarrier(DataFlow::Node node) {
      node instanceof Sanitizer or
      node = any(ArgumentArrayWithDoubleDash array).getASanitizedElement()
    }
  }

  /**
   * Tracks taint flow for reasoning about command-injection vulnerabilities
   * with sinks which are sanitized by `--`.
   */
  module DoubleDashSanitizingFlow = TaintTracking::Global<DoubleDashSanitizingConfig>;
}
