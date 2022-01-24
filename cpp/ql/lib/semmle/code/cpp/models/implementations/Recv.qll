/**
 * Provides implementation classes modeling `recv` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.models.interfaces.SideEffect

/** The function `recv` and its assorted variants */
private class Recv extends AliasFunction, ArrayFunction, SideEffectFunction,
  RemoteFlowSourceFunction {
  Recv() {
    this.hasGlobalName([
        "recv", // recv(socket, dest, len, flags)
        "recvfrom", // recvfrom(socket, dest, len, flags, from, fromlen)
        "recvmsg", // recvmsg(socket, msg, flags)
        "read", // read(socket, dest, len)
        "pread", // pread(socket, dest, len, offset)
        "readv", // readv(socket, dest, len)
        "preadv", // readv(socket, dest, len, offset)
        "preadv2" // readv2(socket, dest, len, offset, flags)
      ])
  }

  override predicate parameterNeverEscapes(int index) {
    this.getParameter(index).getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    not this.hasGlobalName("recvmsg") and
    bufParam = 1 and
    countParam = 2
  }

  override predicate hasArrayInput(int bufParam) { this.hasGlobalName("recvfrom") and bufParam = 4 }

  override predicate hasArrayOutput(int bufParam) {
    bufParam = 1
    or
    this.hasGlobalName("recvfrom") and bufParam = 4
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.hasGlobalName("recvfrom") and
    (
      i = 4 and buffer = true
      or
      i = 5 and buffer = false
    )
    or
    this.hasGlobalName("recvmsg") and
    i = 1 and
    buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) { i = 1 and result = 2 }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 1 and buffer = true and mustWrite = false
    or
    this.hasGlobalName("recvfrom") and
    (
      i = 4 and buffer = true and mustWrite = false
      or
      i = 5 and buffer = false and mustWrite = false
    )
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasRemoteFlowSource(FunctionOutput output, string description) {
    (
      output.isParameterDeref(1)
      or
      this.hasGlobalName("recvfrom") and output.isParameterDeref([4, 5])
    ) and
    description = "Buffer read by " + this.getName()
  }

  override predicate hasSocketInput(FunctionInput input) { input.isParameter(0) }
}
