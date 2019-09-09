import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard function `swap`.
 */
class Swap extends DataFlowFunction {
  Swap() { this.hasQualifiedName("std", "swap") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameterPointer(0) and
    output.isOutParameterPointer(1)
    or
    input.isInParameterPointer(1) and
    output.isOutParameterPointer(0)
  }
}
