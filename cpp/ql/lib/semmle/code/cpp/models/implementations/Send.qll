/**
 * Provides implementation classes modeling `send` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.models.interfaces.SideEffect

/** The function `send` and its assorted variants */
private class Send extends AliasFunction, ArrayFunction, SideEffectFunction, RemoteFlowSinkFunction {
  Send() {
    this.hasGlobalName([
        "send", // send(socket, buf, len, flags)
        "sendto", // sendto(socket, buf, len, flags, to, tolen)
        "sendmsg", // sendmsg(socket, msg, flags)
        "write", // write(socket, buf, len)
        "writev", // writev(socket, buf, len)
        "pwritev", // pwritev(socket, buf, len, offset)
        "pwritev2" // pwritev2(socket, buf, len, offset, flags)
      ])
  }

  override predicate parameterNeverEscapes(int index) {
    this.getParameter(index).getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    not this.hasGlobalName("sendmsg") and
    bufParam = 1 and
    countParam = 2
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 1 }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 1 and buffer = true
    or
    this.hasGlobalName("sendto") and i = 4 and buffer = false
    or
    this.hasGlobalName("sendmsg") and i = 1 and buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) { i = 1 and result = 2 }

  override predicate hasRemoteFlowSink(FunctionInput input, string description) {
    input.isParameterDeref(1, 1) and description = "buffer sent by " + this.getName()
  }

  override predicate hasSocketInput(FunctionInput input) { input.isParameter(0) }
}
