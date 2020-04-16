/**
 * Provides classes representing various flow sources for taint tracking.
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.IR
import semmle.code.cpp.models.interfaces.FlowSource

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
}

class FileDescriptorTaintedReturnSource extends RemoteFlowSource {
  FileDescriptorTaintedReturnSource() {
    exists(RemoteFlowFunction func, CallInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getStaticCallTarget() = func and
      func.hasFlowSource(output) and
      output.isReturnValue()
    )
  }
}

class FileTaintedParameterSource extends RemoteFlowSource {
  FileTaintedParameterSource() {
    exists(RemoteFlowFunction func, ReadSideEffectInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget() = func and
      func.hasFlowSource(output) and
      output.isParameterDeref(instr.getIndex())
    )
  }
}

