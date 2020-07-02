/**
 * Provides classes representing various flow sources for taint tracking.
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.IR
import semmle.code.cpp.models.interfaces.FlowSource

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();
}

private class TaintedReturnSource extends RemoteFlowSource {
  string sourceType;

  TaintedReturnSource() {
    exists(RemoteFlowFunction func, CallInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getStaticCallTarget() = func and
      func.hasRemoteFlowSource(output, sourceType) and
      output.isReturnValue()
    )
  }

  override string getSourceType() { result = sourceType }
}

private class TaintedParameterSource extends RemoteFlowSource {
  string sourceType;

  TaintedParameterSource() {
    exists(RemoteFlowFunction func, WriteSideEffectInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget() = func and
      func.hasRemoteFlowSource(output, sourceType) and
      output.isParameterDeref(instr.getIndex())
    )
  }

  override string getSourceType() { result = sourceType }
}
