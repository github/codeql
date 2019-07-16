import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

class PureStrFunction extends AliasFunction, ArrayFunction, TaintFunction,  SideEffectFunction {
  PureStrFunction() {
    exists(string name |
      hasGlobalName(name) and
      (
        name = "atof"
        or name = "atoi"
        or name = "atol"
        or name = "atoll"
        or name = "strcasestr"
        or name = "strchnul"
        or name = "strchr"
        or name = "strchrnul"
        or name = "strstr"
        or name = "strpbrk"
        or name = "strcmp"
        or name = "strcspn"
        or name = "strlen"
        or name = "strncmp"
        or name = "strnlen"
        or name = "strrchr"
        or name = "strspn"
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
      input.isInParameter(i) and
      exists(getParameter(i))
      or
      input.isInParameterPointer(i) and
      getParameter(i).getUnspecifiedType() instanceof PointerType
    ) and
    (
      output.isOutReturnPointer() and
      getUnspecifiedType() instanceof PointerType
      or
      output.isOutReturnValue()
    )
  }

  override predicate parameterNeverEscapes(int i) {
    getParameter(i).getUnspecifiedType() instanceof PointerType and
    not parameterEscapesOnlyViaReturn(i)
  }

  override predicate parameterEscapesOnlyViaReturn(int i) {
    i = 0 and
    getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterIsAlwaysReturned(int i) {
    none()
  }

  override predicate neverReadsMemory() {
    none()
  }
  
  override predicate neverWritesMemory() {
    any()
  }
}

class PureFunction extends TaintFunction, SideEffectFunction {
  PureFunction() {
    exists(string name |
      hasGlobalName(name) and
      (
        name = "abs" or
        name = "labs"
      )
    )
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists (ParameterIndex i |
      input.isInParameter(i) and
      exists(getParameter(i))
    ) and
    output.isOutReturnValue()
  }

  override predicate neverReadsMemory() {
    any()
  }
  
  override predicate neverWritesMemory() {
    any()
  }
}