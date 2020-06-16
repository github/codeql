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
  abstract class Source extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a source. */
    DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }
  }

  /**
   * A data flow sink for resource exhaustion vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a sink. */
    DataFlow::FlowLabel getAFlowLabel() { result instanceof Label::Number }

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
   * Provides data flow labels for resource exhaustion vulnerabilities.
   */
  module Label {
    /**
     * A number data flow label.
     */
    class Number extends DataFlow::FlowLabel {
      Number() { this = "number" }
    }
  }

  /**
   * A sanitizer that blocks taint flow if the size of a number is limited.
   */
  class UpperBoundsCheckSanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode,
    DataFlow::ValueNode {
    override RelationalComparison astNode;

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      label instanceof Label::Number and
      (
        true = outcome and
        e = astNode.getLesserOperand()
        or
        false = outcome and
        e = astNode.getGreaterOperand()
      )
    }
  }

  /**
   * A test of form `typeof x === "something"`, preventing `x` from being a number in some cases.
   */
  class TypeTestGuard extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::ValueNode {
    override EqualityTest astNode;
    TypeofExpr typeof;
    boolean polarity;

    TypeTestGuard() {
      astNode.getAnOperand() = typeof and
      (
        // typeof x === "number" sanitizes `x` when it evaluates to false
        astNode.getAnOperand().getStringValue() = "number" and
        polarity = astNode.getPolarity().booleanNot()
        or
        // typeof x === "string" sanitizes `x` when it evaluates to true
        astNode.getAnOperand().getStringValue() != "number" and
        polarity = astNode.getPolarity()
      )
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      polarity = outcome and
      e = typeof.getOperand() and
      label instanceof Label::Number
    }
  }

  /** A source of remote user input, considered as a data flow source for resource exhaustion vulnerabilities. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A node that determines the size of a buffer, considered as a data flow sink for resource exhaustion vulnerabilities.
   */
  class BufferSizeSink extends Sink {
    BufferSizeSink() {
      exists(DataFlow::SourceNode clazz, DataFlow::InvokeNode invk, int index |
        clazz = DataFlow::globalVarRef("Buffer") and this = invk.getArgument(index)
      |
        exists(string name |
          invk = clazz.getAMemberCall(name) and
          (
            name = "from" and index = 2
            or
            name = ["alloc", "allocUnsafe", "allocUnsafeSlow"] and index = 0
          )
        )
        or
        invk = clazz.getAnInvocation() and
        (
          invk.getNumArgument() = 1 and
          index = 0
          or
          invk.getNumArgument() = 3 and index = 2
        )
      )
      or
      this = DataFlow::globalVarRef("SlowBuffer").getAnInstantiation().getArgument(0)
    }

    override string getProblemDescription() {
      result = "This creates a buffer with a user-controlled size"
    }
  }

  /**
   * A node that determines the size of an array, considered as a data flow sink for resource exhaustion vulnerabilities.
   */
  class DenseArraySizeSink extends Sink {
    DenseArraySizeSink() {
      // Arrays are sparse by default, so we must also look at how the array is used
      exists(DataFlow::ArrayConstructorInvokeNode instance |
        this = instance.getArgument(0) and
        instance.getNumArgument() = 1
      |
        exists(instance.getAMethodCall(["map", "fill", "join", "toString"])) or
        instance.flowsToExpr(any(AddExpr p).getAnOperand())
      )
    }

    override string getProblemDescription() {
      result = "This creates an array with a user-controlled length"
    }
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

    override DataFlow::FlowLabel getAFlowLabel() { any() }

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

    override DataFlow::FlowLabel getAFlowLabel() { any() }

    override string getProblemDescription() {
      result = "This creates a timer with a user-controlled duration"
    }
  }
}
