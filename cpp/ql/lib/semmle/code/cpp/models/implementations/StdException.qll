/**
 * Provides models for the C++ `std::exception` class and subclasses.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/** The `std::exception` class. */
class StdException extends Class {
  StdException() { this.hasGlobalOrStdOrBslName("exception") }
}

/** The `std::bad_alloc` class. */
class StdBadAllocException extends Class {
  StdBadAllocException() { this.hasGlobalOrStdOrBslName("bad_alloc") }
}

private class StdBadAllocExceptionConstructor extends Constructor, SideEffectFunction, AliasFunction
{
  StdBadAllocExceptionConstructor() { this.getDeclaringType() instanceof StdBadAllocException }

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
