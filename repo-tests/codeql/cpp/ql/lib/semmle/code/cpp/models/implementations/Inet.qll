import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.ArrayFunction

private class InetNtoa extends TaintFunction {
  InetNtoa() { hasGlobalName("inet_ntoa") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValueDeref()
  }
}

private class InetAton extends TaintFunction, ArrayFunction {
  InetAton() { hasGlobalName("inet_aton") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isParameterDeref(1)
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 1 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithFixedSize(int bufParam, int elemCount) {
    bufParam = 1 and
    elemCount = 1
  }
}

private class InetAddr extends TaintFunction, ArrayFunction, AliasFunction {
  InetAddr() { hasGlobalName("inet_addr") }

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
  InetNetwork() { hasGlobalName("inet_network") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValue()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

private class InetMakeaddr extends TaintFunction {
  InetMakeaddr() { hasGlobalName("inet_makeaddr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameter(0) or
      input.isParameter(1)
    ) and
    output.isReturnValue()
  }
}

private class InetLnaof extends TaintFunction {
  InetLnaof() { hasGlobalName("inet_lnaof") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

private class InetNetof extends TaintFunction {
  InetNetof() { hasGlobalName("inet_netof") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }
}

private class InetPton extends TaintFunction, ArrayFunction {
  InetPton() { hasGlobalName("inet_pton") }

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
  Gethostbyname() { hasGlobalName("gethostbyname") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

private class Gethostbyaddr extends TaintFunction, ArrayFunction {
  Gethostbyaddr() { hasGlobalName("gethostbyaddr") }

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
