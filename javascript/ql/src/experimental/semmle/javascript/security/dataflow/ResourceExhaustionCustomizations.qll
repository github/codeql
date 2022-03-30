/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * resource exhaustion vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

module ResourceExhaustion {
  /**
   * A data flow source for resource exhaustion vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for resource exhaustion vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a description of why this is a problematic sink.
     */
    abstract string getProblemDescription();
  }

  /**
   * A data flow sanitizer for resource exhaustion vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer that blocks taint flow if the size of a number is limited.
   */
  class UpperBoundsCheckSanitizerGuard extends TaintTracking::SanitizerGuardNode,
    DataFlow::ValueNode {
    override RelationalComparison astNode;

    override predicate sanitizes(boolean outcome, Expr e) {
      true = outcome and
      e = astNode.getLesserOperand()
      or
      false = outcome and
      e = astNode.getGreaterOperand()
    }
  }

  /** A source of remote user input, considered as a data flow source for resource exhaustion vulnerabilities. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A node that determines the repetitions of a string, considered as a data flow sink for resource exhaustion vulnerabilities.
   */
  class StringRepetitionSink extends Sink {
    StringRepetitionSink() {
      exists(DataFlow::MethodCallNode repeat |
        repeat.getMethodName() = "repeat" and
        this = repeat.getArgument(0)
      )
    }

    override string getProblemDescription() {
      result = "This creates a string with a user-controlled length"
    }
  }

  /**
   * A node that determines the duration of a timer, considered as a data flow sink for resource exhaustion vulnerabilities.
   */
  class TimerDurationSink extends Sink {
    TimerDurationSink() {
      this = DataFlow::globalVarRef(["setTimeout", "setInterval"]).getACall().getArgument(1) or
      this = LodashUnderscore::member(["delay", "throttle", "debounce"]).getACall().getArgument(1)
    }

    override string getProblemDescription() {
      result = "This creates a timer with a user-controlled duration"
    }
  }
}
