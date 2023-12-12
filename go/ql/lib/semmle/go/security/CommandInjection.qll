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
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities
   * with sinks which are not sanitized by `--`.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "CommandInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) {
      exists(Sink s | sink = s | not s.doubleDashIsSanitizing())
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

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

  /**
   * DEPRECATED: Use `DoubleDashSanitizingFlow` instead.
   *
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities
   * with sinks which are sanitized by `--`.
   */
  deprecated class DoubleDashSanitizingConfiguration extends TaintTracking::Configuration {
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
  }

  private module DoubleDashSanitizingConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { exists(Sink s | sink = s | s.doubleDashIsSanitizing()) }

    predicate isBarrier(DataFlow::Node node) {
      node instanceof Sanitizer or
      node = any(ArgumentArrayWithDoubleDash array).getASanitizedElement()
    }

    // Hack: with use-use flow, we might have x (use at line 1) -> x (use at line 2),
    // x (use at line 1) -> array at line 1 and x (use at line 2) -> array at line 2,
    // in the context
    //
    // array1 := {"--", x}
    // array2 := {x, "--"}
    //
    // We want to taint array2 but not array1, which suggests excluding the edge x (use 1) -> array1
    // However isSanitizer only allows us to remove nodes (isSanitizerIn/Out permit removing all outgoing
    // or incoming edges); we can't remove an individual edge, so instead we supply extra edges connecting
    // the definition with the next use.
    predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(
        ArgumentArrayWithDoubleDash array, DataFlow::InstructionNode sanitized,
        DataFlow::SsaNode defn
      |
        sanitized = array.getASanitizedElement() and sanitized = defn.getAUse()
      |
        pred = defn and succ = sanitized.getASuccessor()
      )
    }
  }

  /**
   * Tracks taint flow for reasoning about command-injection vulnerabilities
   * with sinks which are sanitized by `--`.
   */
  module DoubleDashSanitizingFlow = TaintTracking::Global<DoubleDashSanitizingConfig>;
}
