import semmle.code.cpp.models.interfaces.DataFlow

/**
 * Returns the transated text index for a given gettext function `f`
 */
private int getTextArg(Function f) {
  // basic variations of gettext
  f.hasGlobalOrStdName("gettext") and result = 0
  or
  f.hasGlobalOrStdName("dgettext") and result = 1
  or
  f.hasGlobalOrStdName("dcgettext") and result = 1
  or
  // plural variations of gettext that take one format string for singular and another for plural form
  f.hasGlobalOrStdName("ngettext") and
  (result = 0 or result = 1)
  or
  f.hasGlobalOrStdName("dngettext") and
  (result = 1 or result = 2)
  or
  f.hasGlobalOrStdName("dcngettext") and
  (result = 1 or result = 2)
}

class GetTextFunction extends DataFlowFunction {
  int argInd;

  GetTextFunction() { argInd = getTextArg(this) }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(argInd) and output.isReturnValueDeref()
  }
}
