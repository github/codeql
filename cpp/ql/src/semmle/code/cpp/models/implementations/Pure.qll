import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/** Pure string functions. */
class PureStrFunction extends AliasFunction, ArrayFunction, TaintFunction, SideEffectFunction {
  PureStrFunction() {
    hasGlobalOrStdName([
        "atof", "atoi", "atol", "atoll", "strcasestr", "strchnul", "strchr", "strchrnul", "strstr",
        "strpbrk", "strcmp", "strcspn", "strncmp", "strrchr", "strspn", "strtod", "strtof",
        "strtol", "strtoll", "strtoq", "strtoul"
      ])
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

/** String standard `strlen` function, and related functions for computing string lengths. */
class StrLenFunction extends AliasFunction, ArrayFunction, SideEffectFunction {
  StrLenFunction() {
    hasGlobalOrStdName(["strlen", "strnlen", "wcslen"])
    or
    hasGlobalName(["_mbslen", "_mbslen_l", "_mbstrlen", "_mbstrlen_l"])
  }

  override predicate hasArrayInput(int bufParam) {
    getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterNeverEscapes(int i) {
    getParameter(i).getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterEscapesOnlyViaReturn(int i) { none() }

  override predicate parameterIsAlwaysReturned(int i) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = true
  }
}

/** Pure functions. */
class PureFunction extends TaintFunction, SideEffectFunction {
  PureFunction() { hasGlobalOrStdName(["abs", "labs"]) }

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

/** Pure raw-memory functions. */
class PureMemFunction extends AliasFunction, ArrayFunction, TaintFunction, SideEffectFunction {
  PureMemFunction() { hasGlobalOrStdName(["memchr", "memrchr", "rawmemchr", "memcmp", "memmem"]) }

  override predicate hasArrayInput(int bufParam) {
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
