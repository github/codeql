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

    predicate observeDiffInformedIncrementalMode() {
      any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 26 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:8:28:21), Column 5 does not select a source or sink originating from the flow call on line 26 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:71:28:86)
    }

    Location getASelectedSourceLocation(DataFlow::Node source) {
      none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 26 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:8:28:21), Column 5 does not select a source or sink originating from the flow call on line 26 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:71:28:86)
    }

    Location getASelectedSinkLocation(DataFlow::Node sink) {
      none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 26 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:8:28:21), Column 5 does not select a source or sink originating from the flow call on line 26 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:71:28:86)
    }
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

    predicate observeDiffInformedIncrementalMode() {
      any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:8:28:21), Column 5 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:71:28:86)
    }

    Location getASelectedSourceLocation(DataFlow::Node source) {
      none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:8:28:21), Column 5 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:71:28:86)
    }

    Location getASelectedSinkLocation(DataFlow::Node sink) {
      none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:8:28:21), Column 5 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-078/CommandInjection.ql@28:71:28:86)
    }
  }

  /**
   * Tracks taint flow for reasoning about command-injection vulnerabilities
   * with sinks which are sanitized by `--`.
   */
  module DoubleDashSanitizingFlow = TaintTracking::Global<DoubleDashSanitizingConfig>;
}
