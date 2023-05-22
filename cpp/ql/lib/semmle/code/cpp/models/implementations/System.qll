import cpp
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.CommandExecution

/**
 * A function for running a command using a command interpreter.
 */
private class SystemFunction extends CommandExecutionFunction, ArrayFunction, AliasFunction,
  SideEffectFunction
{
  SystemFunction() {
    this.hasGlobalOrStdName("system") or // system(command)
    this.hasGlobalName("popen") or // popen(command, mode)
    // Windows variants
    this.hasGlobalName("_popen") or // _popen(command, mode)
    this.hasGlobalName("_wpopen") or // _wpopen(command, mode)
    this.hasGlobalName("_wsystem") // _wsystem(command)
  }

  override predicate hasCommandArgument(FunctionInput input) { input.isParameterDeref(0) }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 or bufParam = 1 }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 or bufParam = 1 }

  override predicate parameterNeverEscapes(int index) { index = 0 or index = 1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() {
    this.hasGlobalOrStdName("system") or
    this.hasGlobalName("_wsystem")
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    (i = 0 or i = 1) and
    buffer = true
  }
}
