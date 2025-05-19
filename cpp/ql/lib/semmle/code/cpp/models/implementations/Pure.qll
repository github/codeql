import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * A function that operates on strings and is pure. That is, its evaluation is
 * guaranteed to be side-effect free.
 */
private class PureStrFunction extends AliasFunction, ArrayFunction, TaintFunction,
  SideEffectFunction, DataFlowFunction
{
  PureStrFunction() {
    this.hasGlobalOrStdOrBslName([
        atoi(), "strcasestr", "strchnul", "strchr", "strchrnul", "strstr", "strpbrk", "strrchr",
        "strspn", strrev(), strcmp(), strlwr(), strupr()
      ])
  }

  override predicate hasArrayInput(int bufParam) {
    this.getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    this.getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  /** Holds if `i` is a locale parameter that does not carry taint. */
  private predicate isLocaleParameter(ParameterIndex i) {
    this.getName().matches("%\\_l") and i + 1 = this.getNumberOfParameters()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // For these functions we add taint flow according to the following rules:
    // 1. If the parameter is of a pointer type then there is taint from the
    // indirection of the parameter. Otherwise, there is taint from the
    // parameter.
    // 2. If the return value is of a pointer type then there is taint to the
    // indirection of the return. Otherwise, there is taint to the return.
    exists(ParameterIndex i |
      exists(this.getParameter(i)) and
      // Functions that end with _l also take a locale argument (always as the last argument),
      // and we don't want taint from those arguments.
      not this.isLocaleParameter(i)
    |
      if this.getParameter(i).getUnspecifiedType() instanceof PointerType
      then input.isParameterDeref(i)
      else input.isParameter(i)
    ) and
    (
      if this.getUnspecifiedType() instanceof PointerType
      then output.isReturnValueDeref()
      else output.isReturnValue()
    )
    or
    // If there is taint flow from *input to *output then there is also taint
    // flow from input to output.
    this.hasTaintFlow(input.getIndirectionInput(), output.getIndirectionOutput()) and
    // No need to add taint flow if we already have data flow.
    not this.hasDataFlow(input, output)
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    exists(int i |
      input.isParameter(i) and
      not this.isLocaleParameter(i) and
      // These functions always return the same pointer as they are given
      this.hasGlobalOrStdOrBslName([strrev(), strlwr(), strupr()]) and
      this.getParameter(i).getUnspecifiedType() instanceof PointerType and
      output.isReturnValue()
    )
  }

  override predicate parameterNeverEscapes(int i) {
    this.getParameter(i).getUnspecifiedType() instanceof PointerType and
    not this.parameterEscapesOnlyViaReturn(i)
  }

  override predicate parameterEscapesOnlyViaReturn(int i) {
    i = 0 and
    this.getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterIsAlwaysReturned(int i) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = true
  }
}

private string atoi() { result = ["atof", "atoi", "atol", "atoll"] }

private string strlwr() {
  result = ["_strlwr", "_wcslwr", "_mbslwr", "_strlwr_l", "_wcslwr_l", "_mbslwr_l"]
}

private string strupr() {
  result = ["_strupr", "_wcsupr", "_mbsupr", "_strupr_l", "_wcsupr_l", "_mbsupr_l"]
}

private string strrev() { result = ["_strrev", "_wcsrev", "_mbsrev", "_mbsrev_l"] }

private string strcmp() {
  // NOTE: `strcoll` doesn't satisfy _all_ the definitions of purity: its behavior depends on
  // `LC_COLLATE` (which is set by `setlocale`). Not sure this behavior worth including in the model, so
  // for now we interpret the function as being pure.
  result =
    [
      "strcmp", "strcspn", "strncmp", "strcoll", "strverscmp", "_mbsnbcmp", "_mbsnbcmp_l",
      "_stricmp"
    ]
}

/**
 * A function such as `strlen` that returns the length of the given string.
 */
private class StrLenFunction extends AliasFunction, ArrayFunction, SideEffectFunction {
  StrLenFunction() {
    this.hasGlobalOrStdOrBslName(["strlen", "strnlen", "wcslen"])
    or
    this.hasGlobalName(["_mbslen", "_mbslen_l", "_mbstrlen", "_mbstrlen_l"])
  }

  override predicate hasArrayInput(int bufParam) {
    this.getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    this.getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterNeverEscapes(int i) {
    this.getParameter(i).getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterEscapesOnlyViaReturn(int i) { none() }

  override predicate parameterIsAlwaysReturned(int i) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = true
  }
}

/**
 * A function that is pure, that is, its evaluation is guaranteed to be
 * side-effect free. Excludes functions modeled by `PureStrFunction` and `PureMemFunction`.
 */
private class PureFunction extends TaintFunction, SideEffectFunction {
  PureFunction() { this.hasGlobalOrStdOrBslName(["abs", "labs"]) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(ParameterIndex i |
      input.isParameter(i) and
      exists(this.getParameter(i))
    ) and
    output.isReturnValue()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

/**
 * A function that operates on memory buffers and is pure. That is, its
 * evaluation is guaranteed to be side-effect free.
 */
private class PureMemFunction extends AliasFunction, ArrayFunction, TaintFunction,
  SideEffectFunction
{
  PureMemFunction() {
    this.hasGlobalOrStdOrBslName([
        "memchr", "__builtin_memchr", "memrchr", "rawmemchr", "memcmp", "__builtin_memcmp", "memmem"
      ]) or
    this.hasGlobalName("memfrob")
  }

  override predicate hasArrayInput(int bufParam) {
    this.getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(ParameterIndex i |
      (
        input.isParameter(i) and
        exists(this.getParameter(i))
        or
        input.isParameterDeref(i) and
        this.getParameter(i).getUnspecifiedType() instanceof PointerType
      ) and
      // `memfrob` should not have taint from the size argument.
      (not this.hasGlobalName("memfrob") or i = 0)
    ) and
    (
      output.isReturnValueDeref() and
      this.getUnspecifiedType() instanceof PointerType
      or
      output.isReturnValue()
    )
  }

  override predicate parameterNeverEscapes(int i) {
    this.getParameter(i).getUnspecifiedType() instanceof PointerType and
    not this.parameterEscapesOnlyViaReturn(i)
  }

  override predicate parameterEscapesOnlyViaReturn(int i) {
    i = 0 and
    this.getUnspecifiedType() instanceof PointerType
  }

  override predicate parameterIsAlwaysReturned(int i) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = true
  }
}
