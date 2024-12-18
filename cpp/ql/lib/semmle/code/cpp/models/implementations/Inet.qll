import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.FlowSource

private class InetNtoa extends TaintFunction {
  InetNtoa() { this.hasGlobalName("inet_ntoa") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValueDeref()
  }
}

private class InetAton extends TaintFunction, ArrayFunction {
  InetAton() { this.hasGlobalName("inet_aton") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isParameterDeref(1)
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isParameterDeref(1) }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 1 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithFixedSize(int bufParam, int elemCount) {
    bufParam = 1 and
    elemCount = 1
  }
}

private class InetAddr extends TaintFunction, ArrayFunction, AliasFunction {
  InetAddr() { this.hasGlobalName("inet_addr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValue()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate parameterNeverEscapes(int index) { index = 0 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }
}

private class InetNetwork extends TaintFunction, ArrayFunction {
  InetNetwork() { this.hasGlobalName("inet_network") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValue()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

private class InetMakeaddr extends TaintFunction {
  InetMakeaddr() { this.hasGlobalName("inet_makeaddr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameter(0) or
      input.isParameter(1)
    ) and
    output.isReturnValue()
  }
}

private class InetLnaof extends TaintFunction {
  InetLnaof() { this.hasGlobalName("inet_lnaof") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

private class InetNetof extends TaintFunction {
  InetNetof() { this.hasGlobalName("inet_netof") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

private class InetPton extends TaintFunction, ArrayFunction {
  InetPton() { this.hasGlobalName("inet_pton") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameter(0) or
      input.isParameterDeref(1)
    ) and
    output.isParameterDeref(2)
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 1 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 2 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 1 }

  override predicate hasArrayWithUnknownSize(int bufParam) { bufParam = 2 }
}

private class Gethostbyname extends TaintFunction, ArrayFunction {
  Gethostbyname() { this.hasGlobalName("gethostbyname") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

private class Gethostbyaddr extends TaintFunction, ArrayFunction {
  Gethostbyaddr() { this.hasGlobalName("gethostbyaddr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameterDeref(0) or
      input.isParameter(1) or
      input.isParameter(2)
    ) and
    output.isReturnValueDeref()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

private class Getaddrinfo extends TaintFunction, ArrayFunction, RemoteFlowSourceFunction {
  Getaddrinfo() { this.hasGlobalName("getaddrinfo") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref([0 .. 2]) and
    output.isParameterDeref(3)
  }

  override predicate hasArrayInput(int bufParam) { bufParam in [0, 1] }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam in [0, 1] }

  override predicate hasRemoteFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(3, 2) and
    description = "address returned by " + this.getName()
  }
}
