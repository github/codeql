import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function templates `std::move` and `std::forward`.
 */
private class IdentityFunction extends DataFlowFunction, SideEffectFunction, AliasFunction,
  FunctionTemplateInstantiation {
  IdentityFunction() { this.hasQualifiedName("std", ["move", "forward"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { none() }

  override predicate parameterEscapesOnlyViaReturn(int index) {
    // These functions simply return the argument value.
    index = 0
  }

  override predicate parameterIsAlwaysReturned(int index) {
    // These functions simply return the argument value.
    index = 0
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // These functions simply return the argument value.
    input.isParameter(0) and output.isReturnValue()
    or
    input.isParameterDeref(0) and output.isReturnValueDeref()
  }
}
