/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * resource exhaustion vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

/**
 * Provides sources, sinks, and sanitizers for reasoning about
 * resource exhaustion vulnerabilities.
 */
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

  /** A source of remote user input, considered as a data flow source for resource exhaustion vulnerabilities. */
  class RemoteFlowSourceAsSource extends Source instanceof RemoteFlowSource {
    RemoteFlowSourceAsSource() {
      // exclude source that only happen client-side
      not this instanceof ClientSideRemoteFlowSource and
      not this = DataFlow::parameterNode(any(PostMessageEventHandler pmeh).getEventParameter())
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
            name = "from" and index = 2 // the length argument
            or
            name = ["alloc", "allocUnsafe", "allocUnsafeSlow"] and index = 0 // the buffer size
          )
        )
        or
        invk = clazz.getAnInvocation() and
        (
          // invk.getNumArgument() = 1 and // `new Buffer(size)`, it's only an issue if the size is a number, which we don't track precisely.
          // index = 0
          // or
          invk.getNumArgument() = 3 and index = 2 // the length argument
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
   * This is only an issue if the argument is a number, which we don't track precisely.
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
}
