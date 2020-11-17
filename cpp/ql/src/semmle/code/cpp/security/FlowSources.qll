/**
 * Provides classes representing various flow sources for taint tracking.
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.IR
import semmle.code.cpp.models.interfaces.FlowSource

/** A data flow source of user input, whether local or remote. */
abstract class FlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this flow source. */
  abstract string getSourceType();
}

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends FlowSource { }

/** A data flow source of local user input. */
abstract class LocalFlowSource extends FlowSource { }

private class RemoteReturnSource extends RemoteFlowSource {
  string sourceType;

  RemoteReturnSource() {
    exists(RemoteFlowFunction func, CallInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getStaticCallTarget() = func and
      func.hasRemoteFlowSource(output, sourceType) and
      (
        output.isReturnValue()
        or
        output.isReturnValueDeref()
      )
    )
  }

  override string getSourceType() { result = sourceType }
}

private class RemoteParameterSource extends RemoteFlowSource {
  string sourceType;

  RemoteParameterSource() {
    exists(RemoteFlowFunction func, WriteSideEffectInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget() = func and
      func.hasRemoteFlowSource(output, sourceType) and
      output.isParameterDerefOrQualifierObject(instr.getIndex())
    )
  }

  override string getSourceType() { result = sourceType }
}

private class LocalReturnSource extends LocalFlowSource {
  string sourceType;

  LocalReturnSource() {
    exists(LocalFlowFunction func, CallInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getStaticCallTarget() = func and
      func.hasLocalFlowSource(output, sourceType) and
      (
        output.isReturnValue()
        or
        output.isReturnValueDeref()
      )
    )
  }

  override string getSourceType() { result = sourceType }
}

private class LocalParameterSource extends LocalFlowSource {
  string sourceType;

  LocalParameterSource() {
    exists(LocalFlowFunction func, WriteSideEffectInstruction instr, FunctionOutput output |
      asInstruction() = instr and
      instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget() = func and
      func.hasLocalFlowSource(output, sourceType) and
      output.isParameterDerefOrQualifierObject(instr.getIndex())
    )
  }

  override string getSourceType() { result = sourceType }
}

private class ArgvSource extends LocalFlowSource {
  ArgvSource() {
    exists(Parameter argv |
      argv.hasName("argv") and
      argv.getFunction().hasGlobalName("main") and
      this.asExpr() = argv.getAnAccess()
    )
  }

  override string getSourceType() { result = "a command-line argument" }
}
