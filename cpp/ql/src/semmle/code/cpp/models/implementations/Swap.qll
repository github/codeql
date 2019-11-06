import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard function `swap`.
 */
class Swap extends DataFlowFunction {
  Swap() { this.hasQualifiedName("std", "swap") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isParameterDeref(1)
    or
    input.isParameterDeref(1) and
    output.isParameterDeref(0)
  }
}
