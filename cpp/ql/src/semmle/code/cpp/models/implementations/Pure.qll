import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint

class PureFunction extends ArrayFunction, TaintFunction {
  PureFunction() {
    exists(string name |
      hasName(name) and
      (
        name = "abs"
        or name = "atof"
        or name = "atoi"
        or name = "atol"
        or name = "atoll"
        or name = "labs"
        or name = "strcasestr"
        or name = "strchnul"
        or name = "strchr"
        or name = "strchrnul"
        or name = "strcmp"
        or name = "strcspn"
        or name = "strlen"
        or name = "strncmp"
        or name = "strnlen"
        or name = "strrchr"
        or name = "strspn"
        or name = "strstr"
        or name = "strtod"
        or name = "strtof"
        or name = "strtol"
        or name = "strtoll"
        or name = "strtoq"
        or name = "strtoul"
      )
    )
  }
  
  override predicate hasArrayInput(int bufParam) {
    getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }
  
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists (ParameterIndex i |
      input.isInParameter(i) or
      (
        input.isInParameterPointer(i) and
        getParameter(i).getUnspecifiedType() instanceof PointerType
      )
    ) and
    (
      (
        output.isOutReturnPointer() and
        getUnspecifiedType() instanceof PointerType
      ) or
      output.isOutReturnValue()
    )
  }
}