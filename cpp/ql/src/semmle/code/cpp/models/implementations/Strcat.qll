
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint


/**
 * The standard function `strcat` and its wide, sized, and Microsoft variants.
 */
class StrcatFunction extends TaintFunction, DataFlowFunction, ArrayFunction {
  StrcatFunction() {
    exists(string name | name = getName()|
      name = "strcat" // strcat(dst, src)
      or name = "strncat" // strncat(dst, src, max_amount)
      or name = "wcscat" // wcscat(dst, src)
      or name = "_mbscat" // _mbscat(dst, src)
      or name = "wcsncat" // wcsncat(dst, src, max_amount)
      or name = "_mbsncat" // _mbsncat(dst, src, max_amount)
      or name = "_mbsncat_l" // _mbsncat_l(dst, src, max_amount, locale)
    )
  }
  
  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameter(0) and
    output.isOutReturnValue()
  }
  
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(string name | name = getName()
    | (
        (
          name = "strncat" or
          name = "wcsncat" or
          name = "_mbsncat" or
          name = "_mbsncat_l"
        ) and
        input.isInParameter(2) and
        output.isOutParameterPointer(0)
      ) or (
        name = "_mbsncat_l" and
        input.isInParameter(3) and
        output.isOutParameterPointer(0)
      )
    ) or (
      input.isInParameterPointer(0) and
      output.isOutParameterPointer(0)
    ) or (
      input.isInParameter(1) and
      output.isOutParameterPointer(0)
    )
  }
  
  override predicate hasArrayInput(int param) {
    param = 0 or
    param = 1
  }
  
  override predicate hasArrayOutput(int param) {
    param = 0
  }
  
  override predicate hasArrayWithNullTerminator(int param) {
    param = 1
  }
  
  override predicate hasArrayWithUnknownSize(int param) {
    param = 0
  }
}