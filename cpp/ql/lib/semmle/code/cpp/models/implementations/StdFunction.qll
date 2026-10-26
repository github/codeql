/**
 * Provides models for C++ `std::function` class.
 */

import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias

/**
 * An instantiation of the `std::function` class template.
 */
class StdFunction extends ClassTemplateInstantiation {
  StdFunction() { this.hasGlobalOrStdOrBslName("function") }
}

private class StdFunctionConstructor extends Constructor, SideEffectFunction, AliasFunction {
  StdFunctionConstructor() { this.getDeclaringType() instanceof StdFunction }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and buffer = false
  }
}

private class StdFunctionDestructor extends Destructor, SideEffectFunction, AliasFunction {
  StdFunctionDestructor() { this.getDeclaringType() instanceof StdFunction }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}
