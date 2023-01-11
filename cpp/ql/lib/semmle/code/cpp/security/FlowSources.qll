/**
 * Provides classes representing various flow sources for taint tracking.
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.IR
import semmle.code.cpp.models.interfaces.FlowSource
private import semmle.code.cpp.ir.dataflow.internal.ModelUtil

/** A data flow source of user input, whether local or remote. */
abstract class FlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this flow source. */
  abstract string getSourceType();
}

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends FlowSource { }

/** A data flow source of local user input. */
abstract class LocalFlowSource extends FlowSource { }

private class RemoteModelSource extends RemoteFlowSource {
  string sourceType;

  RemoteModelSource() {
    exists(CallInstruction call, RemoteFlowSourceFunction func, FunctionOutput output |
      call.getStaticCallTarget() = func and
      func.hasRemoteFlowSource(output, sourceType) and
      this = callOutput(call, output)
    )
  }

  override string getSourceType() { result = sourceType }
}

private class LocalModelSource extends LocalFlowSource {
  string sourceType;

  LocalModelSource() {
    exists(CallInstruction call, LocalFlowSourceFunction func, FunctionOutput output |
      call.getStaticCallTarget() = func and
      func.hasLocalFlowSource(output, sourceType) and
      this = callOutput(call, output)
    )
  }

  override string getSourceType() { result = sourceType }
}

private class ArgvSource extends LocalFlowSource {
  ArgvSource() {
    exists(Function main, Parameter argv |
      main.hasGlobalName("main") and
      main.getParameter(1) = argv and
      this.asParameter(_) = argv
    )
  }

  override string getSourceType() { result = "a command-line argument" }
}

/** A remote data flow sink. */
abstract class RemoteFlowSink extends DataFlow::Node {
  /** Gets a string that describes the type of this flow sink. */
  abstract string getSinkType();
}

private class RemoteParameterSink extends RemoteFlowSink {
  string sourceType;

  RemoteParameterSink() {
    exists(CallInstruction call, RemoteFlowSinkFunction func, FunctionInput input |
      call.getStaticCallTarget() = func and
      func.hasRemoteFlowSink(input, sourceType) and
      this = callInput(call, input)
    )
  }

  override string getSinkType() { result = sourceType }
}
