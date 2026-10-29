import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The standard functions `getdelim`, `getwdelim` and the glibc variant `__getdelim`.
 */
private class GetDelimFunction extends TaintFunction, AliasFunction, SideEffectFunction,
  RemoteFlowSourceFunction
{
  GetDelimFunction() { this.hasGlobalName(["getdelim", "getwdelim", "__getdelim"]) }

  override predicate hasTaintFlow(FunctionInput i, FunctionOutput o) {
    i.isParameter(3) and o.isParameterDeref(0)
  }

  override predicate isPartialWrite(FunctionOutput o) { o.isParameterDeref(3) }

  override predicate parameterNeverEscapes(int index) { index = [0, 1, 3] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = [0, 1] and
    buffer = false and
    mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 3 and buffer = false
  }

  override predicate hasRemoteFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(0) and
    description = "string read by " + this.getName()
  }
}
