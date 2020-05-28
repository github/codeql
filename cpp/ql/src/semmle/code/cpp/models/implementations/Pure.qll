import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

class PureStrFunction extends AliasFunction, ArrayFunction, TaintFunction, SideEffectFunction {
  PureStrFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      (
        name = "atof" or
        name = "atoi" or
        name = "atol" or
        name = "atoll" or
        name = "strcasestr" or
        name = "strchnul" or
        name = "strchr" or
        name = "strchrnul" or
        name = "strstr" or
        name = "strpbrk" or
        name = "strcmp" or
        name = "strcspn" or
        name = "strncmp" or
        name = "strrchr" or
        name = "strspn" or
        name = "strtod" or
        name = "strtof" or
        name = "strtol" or
        name = "strtoll" or
        name = "strtoq" or
        name = "strtoul"
      )
    )
  }

  override predicate hasArrayInput(int bufParam) {
    getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(ParameterIndex i |
      input.isParameter(i) and
      exists(getParameter(i))
      or
      input.isParameterDeref(i) and
      getParameter(i).getUnspecifiedType() instanceof PointerType
    ) and
    (
      output.isReturnValueDeref() and
      getUnspecifiedType() instanceof PointerType
      or
      output.isReturnValue()
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

  override predicate parameterIsAlwaysReturned(int i) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = true
  }
}

class StrLenFunction extends AliasFunction, ArrayFunction, TaintFunction, SideEffectFunction {
  StrLenFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      (
        name = "strlen" or
        name = "strnlen" or
        name = "wcslen"
      )
      or
      hasGlobalName(name) and
      (
        name = "_mbslen" or
        name = "_mbslen_l" or
        name = "_mbstrlen" or
        name = "_mbstrlen_l"
      )
    )
  }

  override predicate hasArrayInput(int bufParam) {
    getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(ParameterIndex i |
      input.isParameter(i) and
      exists(getParameter(i))
      or
      input.isParameterDeref(i) and
      getParameter(i).getUnspecifiedType() instanceof PointerType
    ) and
    (
      output.isReturnValueDeref() and
      getUnspecifiedType() instanceof PointerType
      or
      output.isReturnValue()
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

  override predicate parameterIsAlwaysReturned(int i) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = true
  }
}

class PureFunction extends TaintFunction, SideEffectFunction {
  PureFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      (
        name = "abs" or
        name = "labs"
      )
    )
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(ParameterIndex i |
      input.isParameter(i) and
      exists(getParameter(i))
    ) and
    output.isReturnValue()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}
