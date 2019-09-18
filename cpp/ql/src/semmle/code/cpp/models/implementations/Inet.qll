import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.ArrayFunction

class InetNtoa extends TaintFunction {
  InetNtoa() { hasGlobalName("inet_ntoa") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameter(0) and
    output.isOutReturnPointer()
  }
}

class InetAton extends TaintFunction, ArrayFunction {
  InetAton() { hasGlobalName("inet_aton") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameterPointer(0) and
    output.isOutParameterPointer(1)
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 1 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithFixedSize(int bufParam, int elemCount) {
    bufParam = 1 and
    elemCount = 1
  }
}

class InetAddr extends TaintFunction, ArrayFunction {
  InetAddr() { hasGlobalName("inet_addr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameterPointer(0) and
    output.isOutReturnValue()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

class InetNetwork extends TaintFunction, ArrayFunction {
  InetNetwork() { hasGlobalName("inet_network") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameterPointer(1) and
    output.isOutReturnValue()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

class InetMakeaddr extends TaintFunction {
  InetMakeaddr() { hasGlobalName("inet_makeaddr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isInParameter(0) or
      input.isInParameter(1)
    ) and
    output.isOutReturnValue()
  }
}

class InetLnaof extends TaintFunction {
  InetLnaof() { hasGlobalName("inet_lnaof") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameter(0) and
    output.isOutReturnValue()
  }
}

class InetNetof extends TaintFunction {
  InetNetof() { hasGlobalName("inet_netof") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameter(0) and
    output.isOutReturnValue()
  }
}

class InetPton extends TaintFunction, ArrayFunction {
  InetPton() { hasGlobalName("inet_pton") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isInParameter(0) or
      input.isInParameterPointer(1)
    ) and
    output.isOutParameterPointer(2)
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 1 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 2 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 1 }

  override predicate hasArrayWithUnknownSize(int bufParam) { bufParam = 2 }
}

class Gethostbyname extends TaintFunction, ArrayFunction {
  Gethostbyname() { hasGlobalName("gethostbyname") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameterPointer(0) and
    output.isOutReturnPointer()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}

class Gethostbyaddr extends TaintFunction, ArrayFunction {
  Gethostbyaddr() { hasGlobalName("gethostbyaddr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isInParameterPointer(0) or
      input.isInParameter(1) or
      input.isInParameter(2)
    ) and
    output.isOutReturnPointer()
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }
}
