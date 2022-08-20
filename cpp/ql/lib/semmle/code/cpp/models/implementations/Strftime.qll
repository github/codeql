import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.ArrayFunction

private class Strftime extends TaintFunction, ArrayFunction {
  Strftime() { hasGlobalName("strftime") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameter(1) or
      input.isParameterDeref(2) or
      input.isParameterDeref(3)
    ) and
    output.isParameterDeref(0)
  }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 2 }

  override predicate hasArrayWithFixedSize(int bufParam, int elemCount) {
    bufParam = 3 and
    elemCount = 1
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = 0 and
    countParam = 1
  }

  override predicate hasArrayInput(int bufParam) {
    bufParam = 2 or
    bufParam = 3
  }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }
}
